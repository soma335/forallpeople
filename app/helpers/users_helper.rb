module UsersHelper
  require 'nokogiri'
  def gravatar_for(user, options = { size: 80 })
    if user.email.present?
      gravatar_id = Digest::MD5::hexdigest(user.email.downcase)
      size = options[:size]
      gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}?s=#{size}"
      return image_tag(gravatar_url, alt: user.name, class: "gravatar")
    else
      twitter_url = user.image_url
      return image_tag(twitter_url, alt: user.name, size:options[:size], class: "gravatar")
    end
  end
  
  
  def recommend(user)
      f = File.open("2014.html")
      doc = Nokogiri::HTML(f)
      f.close()
      ary_1 = []
      
      doc.xpath('//*[@id="mw-content-text"]/div/ul/li').each do |node|
          ary_1 << node.css('a').inner_text
      end
      int = user.hash % ary_1.size
      return  ary_1[int]
  end
end
