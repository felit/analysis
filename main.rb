gem 'nokogiri'
require 'nokogiri'
require 'net/http'
require 'uri'
require File.expand_path('../db.rb', __FILE__)
def job(url,coll)
  html=Net::HTTP.get(URI.parse(url))
  doc=Nokogiri::HTML(html)
  doc.css(".terminalpage .terminalpage-left").each do |p|
    left = p.css('.top-left')
    table = left.css("table:first")
    job_name = table.css("tr:first h1").text
    company_elem = table.css("tr:eq(2) h2 a")
    company_name = company_elem.text.strip
    company_url = company_elem.attr('href').content
    industries = []
    table.css("tr:last td:last a").each do |i|
      industries.push({url: i.attr('href'), name: i.text})
    end
    table2 = left.css('table:last')
    job_types = []
    table2.css("tr:last td:last a").each do |t|
      job_types.push({url: t.attr('href'), name: t.text})
    end
    content = p.css("div:eq(2) .terminalpage-content").text
    coll.insert url:url,company_url: company_url, company_name: company_name, job_name: job_name, industries: industries, job_types: job_types, content: content
  end

end

puts "begining..."
html = Net::HTTP.get(URI.parse('http://sou.zhaopin.com/jobs/searchresult.ashx?jl=%E5%8C%97%E4%BA%AC&sm=0&p=1'))
doc = Nokogiri::HTML(html)
db = DB.new
doc.css('.search-result-cont .search-result-tab .Jobname a').each do |p|
  url = p.attr('href')
  job(url,db)
end