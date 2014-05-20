
module CommandLine
  class CommandFormatter

    def self.format_command(cmd, options)
      result = cmd
      options.each { |o, v| result += " #{o} \"#{v}\"" }
      result
    end
    
  end

  class Command

    def initialize(cmd, opt)
      @cmd = CommandFormatter.format_command(cmd, opt)
    end

    def run
      system @cmd
    end

  end
end
