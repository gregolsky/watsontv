
module WatsOnTv

  class EpisodeMatcher
  
    def self.matches?(name, episode)
      normalized = EpisodeMatcher.normalize_name(name)
      show_name = EpisodeMatcher.normalize_name(episode.show)
      episode_number = "S#{episode.season}E#{episode.number}"
      normalized.include?(show_name) and normalized.include?(episode_number)      
    end
  
    def self.normalize_name(filename)
      filename
        .tr('^A-Za-z0-9 .', '')
        .tr('.', ' ')
        .gsub(/ +/, ' ')
        .upcase
        .chomp
    end
  
  end

end
