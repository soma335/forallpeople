module StaticPagesHelper
    require 'nokogiri'
    def recommend
      f = File.open("2014.html")
      doc = Nokogiri::HTML(f)
      f.close()
      str = Date.today.strftime("%Y-%m-%d")
      ary_1 = []
      
      doc.xpath('//*[@id="mw-content-text"]/div/ul/li').each do |node|
          ary_1 << node.css('a').inner_text
      end
      int = str.hash % ary_1.size
      return  ary_1[int]
    end
end
