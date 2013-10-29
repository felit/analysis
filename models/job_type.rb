class JobType
  include Initializable
  @@fields= [:key,:name,:url]
  attr_accessor *@@fields
  def fields
    @@fields
  end
  def key
    @key||= Base64.encode64(url).gsub(/\s/, '')
  end
end