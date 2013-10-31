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
    @@parse_errors = @@db.collection('parse_errors')
    ids = ->(collection) { collection.find({}).map { |e| e['key'] }.uniq.compact }
    @@job_keys = ids.call(@@jobs)
    @@companies_keys=ids.call(@@companies)
    @@job_types_keys=ids.call(@@job_types)
    @@industries_keys=ids.call(@@industries)

    def save_job(job)
      unless @@job_keys.include?(job.key)
        @@job_keys << job.key
        @@jobs.insert(job.to_hash)
      end
    end

    def save_company(company)
      unless @@companies_keys.include?(company.key)
        @@companies_keys << company.key
        @@companies.insert(company.to_hash)
      end
    end

    def save_job_type(job_type)
      unless @@job_types_keys.include?(job_type.key)
        @@job_types_keys << job_type.key
        @@job_types.insert(job_type.to_hash)
      end
    end

    def save_industry(industry)
      unless @@industries_keys.include?(industry.key)
        @@industries_keys << industry.key
        @@industries.insert(industry.to_hash)
      end
    end

    def save_record(record)
      @@records.insert(record.to_hash)
    end

    def save_parse_error(parse_error)
      @@parse_errors.insert(parse_error.to_hash)
    end
  end
end