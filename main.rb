require 'uri'
require File.expand_path('parser/job_parser.rb')
require File.expand_path('parser/zl.rb')
require File.expand_path('basedata.rb')
require File.expand_path('db/db_mongo.rb')
require File.expand_path('models/record.rb')

parser = Parser::Zl
base_data = BaseData.new
db = DB::DbMongo.new
number=0
base_data.selected_cities.each do |city|
  already_job_types = []
  parent_job_type_ids = []
  base_data.selected_job_types.each do |job_type|
    next if already_job_types.include? job_type[:parent]
    parent_job_type = base_data.job_types.select { |e| e[:id]==job_type[:parent] }.first
    url = "http://sou.zhaopin.com/jobs/searchresult.ashx?bj=#{parent_job_type[:id]}&jl=#{URI.encode(city[:name])}&sm=0"
    if parent_job_type_ids.include?(parent_job_type[:id]) || parser.new(url).total_num > 3600
      parent_job_type_ids << parent_job_type[:id] unless parent_job_type_ids.include?(parent_job_type[:id])
      url = "http://sou.zhaopin.com/jobs/searchresult.ashx?bj=#{parent_job_type[:id]}&sj=#{job_type[:id]}&jl=#{URI.encode(city[:name])}&sm=0"
    else
      already_job_types << parent_job_type
    end

    list = parser.new(url).parse
    #TODO 添加判断是否重复
    #更新记录
    list.each do |job, company, industries, job_types|
      next unless job
      db.save_job(job)
      db.save_company(company)
      industries.each do |industry|
        db.save_industry(industry)
      end
      job_types.each do |jt|
        db.save_job_type(jt)
      end
    end
  end
end