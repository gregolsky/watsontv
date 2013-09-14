
module WatsOnTv

  class Log

    def self.info(msg)
      puts "INFO #{msg}\r\n"
    end

    def self.error(msg)
      puts "ERROR #{msg}\r\n"
    end

  end

end
