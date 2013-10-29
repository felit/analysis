gem 'mongo'
require 'mongo'
module DB
  class DbMongo
    @@client = Mongo::MongoClient.new("localhost", 27017, :pool_size => 5, :pool_timeout => 5)
    @@db=@@client.db('analysis')
    @@jobs= @@db.collection('jobs')
    @@companies=@@db.collection('companies')
    @@job_types=@@db.collection('job_types')
    @@industries=@@db.collection('industries')
    @@records = @@db.collection('records')
    @@job_ids = @@jobs.find(fields:[:id]).map{|e|e.id}
    @@companies_ids=@@companies.find(fields:[:id]).map{|e|e.id}
    @@job_types_ids=@@job_types.find(fields:[:id]).map{|e|e.id}
    @@industries_ids=@@industries.find(fields:[:id]).map{|e|e.id}

    def save_job(job)  ;puts job
      unless @@job_ids.include?(job.id)
        @@job_ids << job.id
        @@jobs.insert(job.to_hash)
      end
    end

    def save_company(company)
      unless @@companies_ids.include?(company.id)
        @@companies_ids << company.id
        @@companies.insert(company.to_hash)
      end
    end

    def save_job_type(job_type)
      unless @@job_types_ids.include?(job_type.id)
        @@job_types_ids << job_type.id
        @@job_types.insert(job_type.to_hash)
      end
    end

    def save_industry(industry)
      unless @@industries_ids.include?(industry.id)
        @@industries_ids << industry.id
        @@industries.insert(industry.to_hash)
      end
    end
    def save_record(record)
      @@records.insert(record.to_hash)
    end
  end
end