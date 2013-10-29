class Job
  @@fields =[:key, :url, :name, :content, :publishing_at, :recruited_at,
             :job_type_keys, :filename, :company_key,
             :experience, :kind, :education, :management, :salary, :people_num, :address,]
  @@md5 =  Digest::MD5.new
  attr_accessor *@@fields
  attr_accessor :html
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

  def filename
    #self.class.name.downcase + "/" + Base64.encode64(@url.sub(/http:\/\/[^\/]*\//,'')).gsub(/\n|=|\//, '') + '.html'
    self.class.name.downcase + "/" + @@md5.hexdigest(@url) + '.html'
  end

end