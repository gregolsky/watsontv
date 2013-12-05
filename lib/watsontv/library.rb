
require 'watsontv/matching'

module WatsOnTv

  class Library
  
    def initialize(files)
      @files = files
    end
    
    def contains?(episode)
      @files.any? { |f| EpisodeMatcher.matches?(f, episode) }
    end
    
    private
    
    def match(f, show, number)
      f.include?(show) and f.include?(number)      
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
