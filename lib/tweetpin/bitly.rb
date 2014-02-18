require 'httparty'

module Tweetpin
  class Bitly
    include HTTParty

    API_VERSION = '3.0'.freeze
    API_CALLS = ['shorten', 'expand', 'validate', 'clicks', 'bitly_pro_domain', 'lookup', 'authenticate', 'info']
    base_uri 'api.bit.ly'

    def initialize(login, api_key)
      self.class.default_params :login => login, :apiKey => api_key
      API_CALLS.each { |name| Bitly.define_action(name) }
    end

    def self.define_action(name)
      define_method(name) do |params|
        options = { :query => params }
        respone = self.class.get("/v3/#{name}", options)
      end
    end
  end  
end

