gem 'mongo'
require 'mongo'

class DB
  @@client = Mongo::MongoClient.new("localhost", 27017, :pool_size => 5, :pool_timeout => 5)
  @@db=@@client.db('analysis')

  def insert hash
    coll = @@db.collection('zhilian')
    id = coll.insert(hash)   ;puts id
  end
end