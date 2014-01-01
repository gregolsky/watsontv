
require 'date'

module WatsOnTv

  class Log

    @@level = 2

    class Level
      ERROR = 1
      INFO = 2
      DEBUG = 3
    end

    def self.info(msg)
      puts "#{ DateTime.now }: INFO #{msg}\r\n" unless @@level < Level::INFO
    end

    def self.error(error)
      puts "#{ DateTime.now }: ERROR #{error.to_s}\r\n"
      if error.is_a? Exception
        puts error.backtrace
      end
    end
    
    def self.debug(msg)
      puts "#{ DateTime.now }: DEBUG #{msg}\r\n" unless @@level < Level::DEBUG
    end

  end

end
