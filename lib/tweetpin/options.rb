require 'optparse'

module Tweetpin
  class Options

    TWITTER_DEFAULT_CONFIG = '/etc/tweetpin/config.yaml'
    LOG_FILE = '/var/log/tweetpin.log'
    
    attr_accessor :options

    def initialize(args)
      
      @options = {
        :config_file  => File.join('', 'etc', 'tweetpin', 'config.yml'),
        :log_file     => File.join('', 'var', 'log', 'tweetpin.log'),
        :daemonize    => false,
        :pid_file     => File.join('', 'var', 'run', 'tweetpin.pid')
      }  
      
      parse(args)
    end

    private
    def parse(args)
      OptionParser.new do |opts|
        opts.summary_width = 25
        
        opts.banner = "usage: tweetpin [options...]"

        opts.separator ""
        opts.separator "Configuration:"
        
        opts.on("-c", "--config [FILE]", String, "Configuration file (default: #{@options[:config_file]})") do |config_file|
          @options[:config_file] = config_file
        end
        
        opts.separator ""
        opts.separator "Daemon:"
        
        opts.on("-d", "--daemon") do
          @options[:daemonize] = true
        end
        
        opts.on("-l", "--log [FILE]", String, "Log file (default: #{@options[:log_file]})") do |log_file|
          @options[:log_file] = File.expand_path(log_file)
        end
        
        opts.on("-p", "--pid [FILE]", String, "Path to the PID file (default: #{@options[:pid_file]})") do |pid|
          @options[:pid] = File.expand_path(pid)
        end
        
        opts.on("-u", "--user [NAME]", String, "User to run as") do |user|
          @options[:user] = Etc.getpwnam(user).uid
        end
        
        opts.on("-g", "--group [NAME]", String, "Group to run as") do |group|
          @options[:group] = Etc.getgrnam(group).gid
        end
        
        opts.separator "" 
        opts.separator "Miscellaneous:"
        opts.on("-v", "--version", "Show version") do
          puts Tweetpin::DAEMON
          exit
        end

        opts.on("-h", "--help", "Show this message") do
          puts "#{opts}\n"
          exit
        end
        begin
          args = ["-h"] if args.empty?
          opts.parse!(args)
        rescue OptionParser::ParseError => e
          STDERR.puts e.message, "\n", opts
          exit(-1)
        end
      end # End OptionParser
    end # End parse

  end  
end
