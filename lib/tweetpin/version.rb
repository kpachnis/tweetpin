module Tweetpin
  
  module Version
    MAJOR = '0'
    MINOR = '1'
    TINY  = '0'
    
    STRING = [MAJOR, MINOR, TINY].join('.')
  end
  
  NAME = 'tweetpin'
  
  DAEMON = "#{NAME} version #{Version::STRING}".freeze
end