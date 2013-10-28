gem 'nokogiri'
require 'nokogiri'
require 'net/http'
require 'uri'
require File.expand_path('../db.rb', __FILE__)
require File.expand_path('../models/initialize.rb', __FILE__)
require File.expand_path('../models/job.rb', __FILE__)
require File.expand_path('../models/company.rb', __FILE__)
require File.expand_path('../models/industry.rb', __FILE__)

def job(url, db)
  html=Net::HTTP.get(URI.parse(url))
  doc=Nokogiri::HTML(html)
  doc.css(".terminalpage .terminalpage-left").map do |p|
    begin
    left = p.css('.top-left')
    city_url = left.css("span#positionCityCon a").attr('href').content rescue nil
    city_name = left.css("span#positionCityCon a").text rescue nil
    table = left.css("table:first")
    company_elem = table.css("tr:eq(2) h2 a")
    job = Job.new(
        id: url.match(/\d+/).to_a.first,
        name: table.css("tr:first h1").text,
        content: p.css("div:eq(2) .terminalpage-content").text,
        url: url,
        html: html,
        publishing_at: p.css('#span4freshdate').text,
        company_url: company_elem.attr('href').content,
        recruited_at: Time.new
    )

    db.save_job(job)
    company =Company.new(name: company_elem.text.strip, url: company_elem.attr('href').content)
    db.save_company(company)
    table.css("tr:last td:last a").each do |i|
      id = i.attr('href').match(/\d+/).to_a.first
      db.save_industry(Industry.new(id: id, name: i.text, url: i.attr('href')))
    end
    table2 = left.css('table:last')
    table2.css("tr:last td:last a").each do |t|
      db.save_job_type({url: t.attr('href'), name: t.text})
    end
    rescue
    end
  end

end

puts "begining..."
db = DB.new
(1..120).each do |e|
  html = Net::HTTP.get(URI.parse("http://sou.zhaopin.com/jobs/searchresult.ashx?jl=%E5%8C%97%E4%BA%AC&sm=0&p=#{e}"))
  doc = Nokogiri::HTML(html)
  doc.css('.search-result-cont .search-result-tab .Jobname a').each do |p|
    url = p.attr('href')
    job(url, db)
  end
end