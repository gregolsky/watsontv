
require 'watsontv/cli'

module TorrentClient

  class TransmissionDaemon

    CMD = 'transmission-remote'
    
    def initialize(host, port)
      @host, @port = host, port
    end
    
    def add(torrent, options)
      run_command({ '-a' => torrent.magnet_link })

      list_output = run_command({ '-l' => '' })
      list = parse_list output

      item = list.select { |t| t.name == torrent.name }[0]
      if item.nil?
        raise StandardError.new("Torrent: #{torrent.inspect} is missing from #{list.inspect}.\nThe list output is: #{output}")
      end

      run_command({ '-t' => item.id, '--move' => options[:download_directory] })
    end

    def list
      list_output = run_command({ '-l' => '' })
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
        OutputEntry.new(fields[0], self.normalize(fields[8]))
      }
    end

    def self.normalize(name)
      name.gsub(/\+/, ' ')
    end

    class OutputEntry

      attr_reader :id, :name

      def initialize(id, name)
        @id, @name = id, name
      end

    end

  end
end
