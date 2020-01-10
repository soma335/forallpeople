class Micropost < ApplicationRecord
  belongs_to :user
  default_scope -> { order(created_at: :desc) }
  mount_uploader :picture, PictureUploader
  validates :user_id, presence: true
  validates :content, presence: true, length: { maximum: 140 }
  validate  :picture_size
  has_many  :likes

  def iine(user)
    likes.create(user_id: user.id)
  end
  
  def iine?(user)
    iine_users.include?(user)
  end
  
  def uniine(user)
    likes.find_by(user_id: user.id).destroy
  end

  private

    # アップロードされた画像のサイズをバリデーションする
    def picture_size
      if picture.size > 5.megabytes
        errors.add(:picture, "should be less than 5MB")
      end
    end  
end