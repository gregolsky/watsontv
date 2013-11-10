
module WatsOnTv

  class SearchResultsFilter
  
    NAME_FILTER = [ "PREVIEW", "PEEK", "SAMPLE" ]
  
    def self.filter(episode, search_result)
    
      if not search_result.name.nil? and NAME_FILTER.any? { |filtered| search_result.name.upcase.include? filtered }
        return false
      end
      
      size = search_result.size
      runtime = episode.runtime
      if not runtime.nil? and not size.nil?
         in_gb = size.include? "GiB"
         size_in_mb = size.to_f * (in_gb ? 1000 : 1)
         estimated_min_size = runtime * 16
         
         if estimated_min_size > size_in_mb
           return false
         end
      end
      
      return true    
    end
  
  end

end
