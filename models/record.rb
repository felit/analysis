#记录收录记录
class Record
  @@fields = [:region_key,:industry_key,:job_type_key,:created_at]
  include Initializable
  attr_accessor *@@fields
  def fields
    @@fields
  end
  def created_at
    Time.new
  end
  def key
    @key||= Base64.encode64(url).gsub(/\s/, '')
  end
end