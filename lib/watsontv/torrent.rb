
require 'watsontv/cli'

module TorrentClient

  class TransmissionDaemon

    CMD = 'transmission-remote'
    
    def initialize(host, port)
      @host, @port = host, port
    end
    
    def add(torrent, options)
      run_command({ '-a' => torrent.magnet_link })
      item = list.select { |t| t.name == torrent.name }[0]
      run_command({ '-t' => item.id, '--move' => options.download_directory })
    end
    
    def list
      output = run_command({ '-l' => '' })
      parse_list output
    end
    
    def parse_list(output)
      ListOutputParser.parse output
    end

    def run_command(options)
      base = CMD + " #{@host}:#{@port}"
      CommandLine::Command.new(base, options).run
    end
    
  end

  class ListOutputParser

    def self.parse(output)
      rows = output.split("\n")
      if rows.length == 2
        return []
      end

      rows[1..-2].map { |r|
        r.split(' ')
      }.map { |fields| 
        OutputEntry.new(fields[0], fields[8])
      }
    end

    class OutputEntry

      attr_reader :id, :name

      def initialize(id, name)
        @id, @name = id, name
      end

    end

  end
end
