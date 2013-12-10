require 'uri'
require 'fileutils'
require File.expand_path('parser/job_parser.rb')
require File.expand_path('parser/zl.rb')
require File.expand_path('models/parser_error.rb')
require File.expand_path('basedata.rb')
require File.expand_path('db/db_mongo.rb')
require File.expand_path('models/record.rb')

parser = Parser::Zl
base_data = BaseData.new
db = DB::DbMongo.new
root = '/home/congsl/data'
html_root = "#{root}/html-data"
error_dir="#{html_root}/parsererror"
FileUtils.mkpath(error_dir)
[Job, JobType, Company, Industry].each do |e|
  FileUtils.mkpath("#{html_root}/#{e.to_s.downcase}")
end
base_data.selected_cities.each do |city|
  already_job_types = []
  parent_job_type_keys = []
  base_data.selected_job_types.each do |job_type|
    next if already_job_types.include? job_type[:parent]
    parent_job_type = base_data.job_types.select { |e| e[:id]==job_type[:parent] }.first
    url = "http://sou.zhaopin.com/jobs/searchresult.ashx?bj=#{parent_job_type[:id]}&jl=#{URI.encode(city[:name])}&sm=0&pd=1"
    if parent_job_type_keys.include?(parent_job_type[:id]) || parser.new(url).total_num > 3600
      db.save_record Record.new(region_key: city[:id], job_type_key: job_type[:id])
      parent_job_type_keys << parent_job_type[:id] unless parent_job_type_keys.include?(parent_job_type[:id])
      url = "http://sou.zhaopin.com/jobs/searchresult.ashx?bj=#{parent_job_type[:id]}&sj=#{job_type[:id]}&jl=#{URI.encode(city[:name])}&sm=0&pd=1"
    else
      already_job_types << parent_job_type
    end
    page = parser.new(url)
    [1..(page.total_num/30).ceil].each do |num|
      list = parser.new(url + "&p=#{num}").parse

      #更新记录
      list.each do |job, company, industries, job_types|
        if job.instance_of?(Job)
          file = File.new("#{html_root}/#{job.filename}", 'w+')
          file.write(job.html)
          file.close
          db.save_job(job)
          db.save_company(company)
          industries.each do |industry|
            db.save_industry(industry)
          end
          job_types.each do |jt|
            db.save_job_type(jt)
          end
        else
          file = File.new("#{html_root}/#{job.filename}", 'w+')
          file.write(job.html)
          file.close
          db.save_parse_error(job)
        end
      end
    end
  end
end
