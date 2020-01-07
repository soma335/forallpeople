require 'nokogiri'

#ダウンロードしたhtmlファイル
f = File.open("2014.html")
doc = Nokogiri::HTML(f)
f.close()


ary_1 = []

doc.xpath('//*[@id="mw-content-text"]/div/ul/li').each do |node|
    ary_1 << node.css('a').inner_text
end
p ary_1