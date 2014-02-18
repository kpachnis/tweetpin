begin
  require 'beanstalk-client'
  require 'twitter'
  require 'logger'
  require 'yaml'
rescue LoadError
  require 'rubygems'
  require 'beanstalk-client'
  require 'twitter'
  require 'logger'
  require 'yaml'
end

module Tweetpin
  class Messenger

    def initialize(config)
      begin
        @config = YAML.load_file(config)
      rescue Errno::ENOENT
        UI.error "File not found."
        exit 1
      rescue Errno::EACCES
        UI.error "Cannot open file. Permission denied!"
        exit 1
      end

      begin
        @beanstalk = Beanstalk::Pool.new([@config['beanstalk']['server']], @config['beanstalk']['queue'])
      rescue Beanstalk::NotConnected
        UI.error "Cannot connect to Beanstalk server"
        exit 1
      end
      
      @logger = Logger.new(@config['logger'])
      @bitly = Bitly.new(@config['bitly']['login'], @config['bitly']['apikey'])
    end

    def start
      loop { process_messages }
    end

    private
      def process_messages
        job = @beanstalk.reserve
        message =  YAML.load(job.body)
        full_url = short_url([@config['http_server_url'], message[:path].to_s].join('/'))
        twitter_post_message("New post: #{message[:title].to_s} at #{full_url}")
        job.delete
      end

      def twitter_post_message(message)
        oauth = Twitter::OAuth.new(@config['twitter']['consumer_token'], @config['twitter']['consumer_secret'])
        begin
          oauth.authorize_from_access(@config['twitter']['access_token'], @config['twitter']['access_secret'])
          client = Twitter::Base.new(oauth)
          client.update(message)
        rescue Twitter::Unauthorized
          @logger.fatal('Twitter authorization failed.')
          exit
        rescue Twitter::Unavailable
          #TODO: Handle undelivered tweets
          @logger.warn('Twitter is unavailable, will try again later.')
          return
        end
      end

      def short_url(url)
        response = @bitly.shorten :longUrl => url
        response['data']['url']
      end
  end    
end
