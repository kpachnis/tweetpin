module Tweetpin
  
  class Daemonize
    
    def initialize(pid_file = nil, user = nil, group = nil)
      @pid_file = pid_file
      @user = user
      @group = group
    end
    
    def start(config)
      pid = fork { Messenger.new(config).start }
      Process.detach(pid)
      create_pid_file(@pid_file)
    end
    
    def self.stop(pid_file)
      pid = read_pid_file(pid_file)
      Process.kill("QUIT", pid)
    end
    
    def running?
      return false unless pid
    end
    
    def create_pid_file(file)
      File.open(file, 'w+') { |f| f.write(Process.pid) }
      File.chmod(0644, file)
    end
    
    def pid
      File.exists?(@pid_file) ? File.read(@pid_file).to_i : nil
    end
    
    def self.read_pid_file(pid_file)
      File.read(pid_file).to_i
    end
    
  end
end