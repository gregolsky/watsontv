
module CommandLine
  class CommandFormatter

    def self.format_command(cmd, options)
      result = cmd
      options.each { |o, v| result += " #{o} #{ (v.nil? or v.empty?) ? '' : '"' + v + '"' }" }
      result
    end
    
  end

  class Command

    def initialize(cmd, opt)
      @cmd = CommandFormatter.format_command(cmd, opt)
    end

    def run
      `#{@cmd}`
    end

  end
end
