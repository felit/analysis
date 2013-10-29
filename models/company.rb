class Company
  include Initializable
  @@fields=[:key, :name,:url,:industries_keys]
  attr_accessor *@@fields
  def fields
    @@fields
  end
  def industries=(industries)
    @industries_keys=industries.map(&:key)
  end
  def key
    @key||= Base64.encode64(url).gsub(/\s/, '')
  end
end