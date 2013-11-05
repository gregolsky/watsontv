
module WatsOnTv

  class Library
  
    def initialize(files)
      @files = normalize(files)
    end
    
    def contains?(episode)
      show_name = normalize_name(episode.show)
      episode_number = "S#{episode.season}E#{episode.number}"
      @files.select { |f| match(f, show_name, episode_number) }.any?
    end
    
    private
    
    def match(f, show, number)
      f.include?(show) and f.include?(number)      
    end
    
    def normalize(files)
      files
       .map { |f| normalize_name(f) }
    end
    
    def normalize_name(filename)
      filename
        .tr('^A-Za-z0-9 .', '')
        .tr('.', ' ')
        .gsub(/ +/, ' ')
        .upcase
        .chomp
    end
  
  end
  
  class LibraryLoader
  
    VIDEO_FILETYPES = ['mkv', 'avi', 'mp4']

    def self.load(dir)
      files = VIDEO_FILETYPES
        .map { |video_ftype| Dir.glob(dir + '/**/*.' + video_ftype) }
        .flatten
        .map { |f| File.basename(f) }
      Library.new(files)
    end
  
  end
  
end
