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
end