class Job
  @@fields =[:id, :url, :name, :content, :publishing_at, :recruited_at, :company_url,
             :job_type_ids, :html, :filename, :company_id, :industries_ids, :job_types_ids,
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
    @company_id=company.id
  end

  def job_types=(job_types)
    @job_types_ids=job_types.map(&:id)
  end
end