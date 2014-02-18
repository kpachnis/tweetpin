require 'thor'

module Tweetpin
  class Runner < Thor
    
    check_unknown_options!
    
    desc "start", "Start tweetpin"
    method_option "daemon", :type => :boolean, :banner => "Run daemonized in the background"
    method_option "user",   :type => :string, :banner => "User to run daemon as"
    method_option "group",  :type => :string, :banner => "Group to run daemon as"
    method_option "pid",    :type => :string, :banner => "File to store PID (default /var/run/tweetpin.pid)"
    method_option "config", :type => :string, :required => :true, :banner => "Configuration file"
    def start
      if options[:daemon]
        pid_file = options[:pid] ? options[:pid] : "/var/run/tweetpin.pid"
        Daemonize.new(pid_file, 'j', 'j').start(options[:config])

      else
        UI.info "Tweetpin starting, press ^C to exit"
        Messenger.new(options[:config]).start

      end
    end
    
    desc "stop", "Stop tweetpin"
    method_option "pid", :type => :string, :banner => "PID file (default /var/run/tweetpin.pid)"
    def stop
      pid_file = options[:pid] ? options[:pid] : "/var/run/tweetpin.pid"
      Daemonize.stop(File.expand_path(pid_file))
    end
    
    desc "status", "Prints tweetpin status"
    def status
      
    end
    
    desc "version", "Prints the tweetpin version information"
    def version
      puts Tweetpin::DAEMON
    end
    map %w(-v --version) => :version
    
  end
end
