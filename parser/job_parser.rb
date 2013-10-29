gem 'nokogiri'
require 'nokogiri'
require 'net/http'
require File.expand_path('../../models/initialize.rb',__FILE__)
require File.expand_path('../../models/job.rb',__FILE__)
require File.expand_path('../../models/company.rb',__FILE__)
require File.expand_path('../../models/industry.rb',__FILE__)
require File.expand_path('../../models/job_type.rb',__FILE__)
require File.expand_path('../../models/record.rb',__FILE__)
module Parser
  class JobParser
    attr_accessor :url,:html,:doc

    def initialize(url)
      @url = url
      @html = to_html(@url)
      @doc = to_doc(@html)
    end

    def total_num
      raise 'unimplement'
    end

    def parse
      raise 'unimplement'
    end

    protected
    def to_html(url)
      Net::HTTP.get(URI.parse(url))
    end

    def to_doc(html)
      Nokogiri::HTML(html)
    end
  end
end