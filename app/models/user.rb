class User < ApplicationRecord
  has_many :microposts, dependent: :destroy
  has_many :active_relationships,
        class_name: 'Relationship',
       foreign_key: :follower_id,
         dependent: :destroy
  has_many :passive_relationships,
        class_name: 'Relationship',
       foreign_key: :followed_id,
         dependent: :destroy
  # @user.active_relationships.map(&:followed)
  # @user.following
  has_many :following,
    through: 'active_relationships',
     source: 'followed'
  has_many :followers,
    through: 'passive_relationships',
     source: 'follower'
  has_many :likes
  has_many :liked_microposts, through: :likes, source: :micropost
  attr_accessor :remember_token, :activation_token, :reset_token
  before_create :create_activation_digest
  before_save :downcase_email, unless: :uid?
  validates :name, presence: true, unless: :uid?, length: { maximum: 50 }
  validates :email, presence: true, unless: :uid?, length: { maximum: 255 },
                    format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i },
                    uniqueness: { case_sensitive: false }
  has_secure_password validations: false

  validates :password, presence: true,
    length: { minimum: 6 }, allow_nil: true
    

  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  def User.new_token
    SecureRandom.urlsafe_base64
  end

  def remember
    self.remember_token = User.new_token
    self.update_attribute(:remember_digest,
      User.digest(remember_token))
  end

  def forget
    self.update_attribute(:remember_digest, nil)
  end

  # 渡されたトークンがダイジェストと一致したらtrueを返す
  def authenticated?(attribute, token)
    digest = self.send("#{attribute}_digest")
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
  end

  def activate
    update_attribute(:activated,    true)
    update_attribute(:activated_at, Time.zone.now)
  end

  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end

  def create_reset_digest
    self.reset_token = User.new_token
    update_attribute(:reset_digest,  User.digest(reset_token))
    update_attribute(:reset_sent_at, Time.zone.now)
  end

  def send_password_reset_email
    UserMailer.password_reset(self).deliver_now
  end

  def password_reset_expired?
    reset_sent_at < 2.hours.ago
  end


  # 試作feedの定義
  # 完全な実装は次章の「ユーザーをフォローする」を参照
  # current_user.feed
  # current_user.id
  # current_user.microposts
  def feed
    following_ids = "SELECT followed_id FROM relationships
                     WHERE follower_id = :user_id"
    Micropost.where("user_id IN (#{following_ids}) OR user_id = :user_id",
                                 user_id: self.id)
  end

  def follow(other_user)
    self.active_relationships.create(followed_id: other_user.id)
  end

  def unfollow(other_user)
    self.active_relationships.find_by(followed_id: other_user.id).destroy
  end

  def following?(other_user)
    self.following.include?(other_user)
  end
  
  def activate
    update_attribute(:activated,    true)
    update_attribute(:activated_at, Time.zone.now)
  end

  # 有効化用のメールを送信する
  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end
  
  def already_liked?(micropost)
    self.likes.exists?(micropost_id: micropost.id)
  end
  
  def self.find_or_create_from_auth(auth)
    provider = auth[:provider]
    uid = auth[:uid]
    name = auth[:info][:name]
    image = auth[:info][:image]

    self.find_or_create_by(provider: provider, uid: uid) do |user|
      user.name = name
      user.image_url = image
    end
  end
  
  private

    def downcase_email
      self.email = self.email.downcase
    end

    def create_activation_digest
      self.activation_token  = User.new_token
      self.activation_digest = User.digest(self.activation_token)
      # @user.activation_digest => ハッシュ値
    end
end