class Company
  include Initializable
  @@fields=[:id, :name,:url,:industries_ids]
  attr_accessor *@@fields
  def fields
    @@fields
  end
  def industries=(industries)
    @industries_ids=industries.map(&:id)
  end
end