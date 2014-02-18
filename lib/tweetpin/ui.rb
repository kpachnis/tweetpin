module Tweetpin
  class UI
    
    def self.error(msg)
      say(msg, :red)
    end
    
    def self.warn(msg)
      say(msg, :yellow)
    end
    
    def self.info(msg)
      say(msg, :green)
    end
    
    private
    def self.say(msg, color)
      $stdout.puts Color.set_color(msg, color)
      $stdout.flush
    end
  end
end