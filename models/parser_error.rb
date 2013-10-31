class ParserError
  include Initializable
  @@fields =[:key, :created_at, :url, :filename]
  @@md5 = Digest::MD5.new

  def fields
    @@fields
  end

  def key
    @key||=Base64.encode64(@url)
  end

  def filename
    self.class.name.downcase + "/" + @@md5.hexdigest(@url) + '.html'
  end
end
