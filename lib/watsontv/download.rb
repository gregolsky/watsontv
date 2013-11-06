
require 'date'
require 'watsontv/date'
require 'watsontv/logging'
require 'watsontv/filter'

module WatsOnTv

  class DownloadManager

    def initialize(cfg, shows_provider, library, search_client, torrent_client, notifier)
      @hours_after_air_time = cfg['hours after air time'].to_i;
      @search_term_suffix = cfg['search term suffix']
      @shows_provider = shows_provider
      @library = library
      @search_client = search_client
      @torrent_client = torrent_client
      @notifier = notifier
    end

    def manage
      episodes = current_episodes
      
      Log.info("Current episodes:\r\n #{episodes.inspect}")

      episodes.each do |episode|

        term = search_term_for(episode)
        Log.info("Searching for: #{term}")
        results = @search_client.search(term)
        download_info = filter_search_results(results)[0]
        
        if not download_info.nil?
          Log.info("Search results:\r\n #{download_info.inspect}")
          add_to_download_queue download_info
        else
          Log.info("No results for #{episode.summary}.")
          @notifier.notify("#{episode.summary} could not be found.", "")
        end
      end
    rescue StandardError => error  
      Log.error(error)
      raise error
    end

    private

    def add_to_download_queue(search_result)
      @torrent_client.add search_result.magnet_link
    end

    def current_episodes
      @shows_provider.shows_for(CurrentTime.get, 1)
      .select { |e|
        !@library.contains?(e) && 
        e.airtime + (@hours_after_air_time / 24.0) <= CurrentTime.get
      }
    end

    def search_term_for(episode)
      show_for_term = episode.show.tr('^A-Za-z0-9 .', '')
      "#{show_for_term} S#{episode.season}E#{episode.number} #{@search_term_suffix}"
    end
    
    def filter_search_results(episode, results)
      results.select { |t| SearchResultsFilter.filter(episode, t) }
    end

  end

end
