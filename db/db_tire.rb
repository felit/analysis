gem 'tire'
require 'tire'
puts Tire.methods.sort - Object.methods
Tire.configure do
  url 'http://192.168.2.104:9200/'
end