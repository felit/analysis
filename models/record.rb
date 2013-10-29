#记录收录记录
class Record
  @@fields = [:region_id,:industry_id,:job_type_id,:created_at]
  include Initializable
  attr_accessor *@@fields
  def fields
    @@fields
  end
  def created_at
    Time.new
  end
end