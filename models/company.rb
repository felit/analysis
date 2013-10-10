class Company
  include Initializable
  @@fields=[:id, :name,:url]
  attr_accessor *@@fields
  def fields
    @@fields
  end
end