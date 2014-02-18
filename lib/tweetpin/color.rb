module Tweetpin
  class Color
    @colors = {
      :black    => "\e[30m",
      :red      => "\e[31m",
      :green    => "\e[32m",
      :yellow   => "\e[33m",
      :blue     => "\e[34m",
      :magenta  => "\e[35m",
      :cyan     => "\e[36m",
      :white    => "\e[37m"
    }

    def self.set_color(str, color)
      @colors[color] + str + "\e[0m"
    end

  end
end