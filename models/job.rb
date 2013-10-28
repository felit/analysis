class Job
  @@fields =[:id, :url, :name, :content, :publishing_at, :recruited_at, :company_url, :industry_ids, :job_type_ids, :html, :filename]
  attr_accessor *@@fields
  include Initializable

  def fields
    @@fields
  end

  def == (other)
    return url==other.url
  end

=begin
  include Initializable
  def to_hash
    {
        id: id,
        url: url,
        name: name,
        content: content,
        publishing_at: publishing_at,
        recruited_at: recruited_at,
        company_url: company_url,
        industry_ids: industry_ids,
        job_type_ids: job_type_ids,
        html: html
    }
  end
=end
end