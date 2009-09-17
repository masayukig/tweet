$LOAD_PATH << File.dirname(__FILE__)
require 'rubygems'
require 'activesupport'
require 'rest_client'
require 'open-uri'
require 'json'


module Tweet
  CONFIG_FILE = ENV['HOME']+'/.tweet'
  
  class << self
    attr_accessor :username, :password
    
    def create_status(status)
      get_credentials!
      status = shorten_url(status)
      resource = RestClient::Resource.new 'http://twitter.com/statuses/update.xml', username, password
      resource.post(:status => status, :source => 'tweetgem', :content_type => 'application/xml', :accept => 'application/xml')
    end
    
    def get_credentials!
      abort "You must create a #{CONFIG_FILE} file to use this CLI." unless File.exist?(CONFIG_FILE)
      config = YAML.load(File.read(CONFIG_FILE)).symbolize_keys
      @username, @password = config[:username], config[:password]
      @bitly_username, @bitly_apikey = config[:bitly_username], config[:bitly_apikey]
    end

    def shorten_url(status)
      status = status.gsub(/(https?\:[\w\.\~\-\/\?\&\+\=\:¥@¥%\;¥#¥%]+)/){ |x|
        url = 'http://api.bit.ly/shorten?version=2.0.1&longUrl=' + x + '&login=' + @bitly_username + '&apiKey=' + @bitly_apikey
        buffer = open(url, "UserAgent" => "Ruby-Client").read
        result = JSON.parse(buffer)
        results = result['results'][x]['shortUrl']
        results.each do |result|
        end
       }
      return status
    end
    
  end
end
