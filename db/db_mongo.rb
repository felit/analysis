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

    def insert hash
      coll = @@db.collection('zhilian')
      id = coll.insert(hash)
    end

    def save_job(job)
      if (Hash === job)
        @@jobs.insert(job)
      else
        @@jobs.insert(job.to_hash)
      end
    end

    def save_company(company)
      if (Hash === company)
        @@companies.insert(company)
      else
        @@companies.insert(company.to_hash)
      end
    end

    def save_job_type(job_type)
      if (Hash === job_type)
        @@job_types.insert(job_type)
      else
        @@job_types.insert(job_type.to_hash)
      end
    end

    def save_industry(industry)
      if (Hash === industry)
        @@industries.insert(industry)
      else
        @@industries.insert(industry.to_hash)
      end
    end
  end
end