
require 'digest/md5'
require 'base64'

module WatsOnTv

  class DownloadMarker

    def initialize
      @marked = []
    end

    def load(io)
      @marked = io.readlines.map { |l| l.strip }
    end

    def mark(episode)
      @marked << digest(episode)
    end
    
    def marked?(episode)
      @marked.include? digest(episode)
    end

    def save(io)
      @marked.each { |m| io.puts m }
    end

    private 

    def marked_file_path
      File.expand_path(MARK_FILE)
    end
    
    def digest(episode)
      Digest::MD5.base64digest(episode.summary)
    end

  end

end
