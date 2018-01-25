require 'nokogiri' 
require 'json'

page = Nokogiri::HTML(open("INDEX1.html"))

#remove empty divz...
page.xpath('/html/body/div/div').each do |div|
  div.remove if (div.content.strip.empty? and div.children.count <= 1)
end

projects = []

page.xpath('/html/body/div').each_slice(4) do |div|
  project = {}
  project['image'] = div[0].css('img').collect{|i| i['src']}[0].split('/').last rescue nil
  unless project['image']
    project['image'] = div[0].css('img').collect{|i| i['src']} rescue nil
  end
  project['info'] = div[1].css('p span').collect{|i| i.text} rescue nil
  project['photo_credit'] = div[2].css('p span').collect{|i| i.text}[0] rescue nil
  unless project['photo_credit']
    project['photo_credit'] = div[2].css('p span').collect{|i| i.text} rescue nil
  end
  project['description'] = div[3].css('p span').collect{|i| i.text} rescue nil
  projects << project
end

# require 'pp'
# pp projects

File.open("projects.json","w") do |f|
  f.write(projects.to_json)
end
