require 'base64'
module Initializable
  def initialize(hash)
    hash.each do |k, v|
      send "#{k}=", v
    end
  end

  def fields
    @@fields
  end

  def to_hash
    fields.inject({}) do |r, e|
      r.store(e, send(e))
      r
    end
  end

  def filename
    self.class.name + "/" + Base64.encode64(@url).gsub("\n", '') + '.html'
  end

  def id
    @id||= Base64.encode64(self.url).gsub(/\s/, '')
  end
end