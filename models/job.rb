class Job
  @@fields =[:key,:url, :name, :content, :publishing_at, :recruited_at,
             :job_type_keys, :html, :filename, :company_key,
             :experience, :kind, :education, :management, :salary, :people_num, :address,]
  attr_accessor *@@fields
  include Initializable

  def fields
    @@fields
  end

  def == (other)
    return url==other.url
  end

  def company=(company)
    @company_key=company.key
  end

  def job_types=(job_types)
    @job_types_keys=job_types.map(&:key)
  end

  def key
    @key||= Base64.encode64(url).gsub(/\s/, '')
  end
end