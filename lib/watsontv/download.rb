
require 'date'
require 'watsontv/date'
require 'watsontv/logging'

module WatsOnTv

  class DownloadManager

    def initialize(cfg, shows_provider, download_marker, search_client, torrent_client, notifier)
      @hours_after_air_time = cfg['hours after air time'].to_i;
      @search_term_suffix = cfg['search term suffix']
      @shows_provider = shows_provider
      @download_marker = download_marker
      @search_client = search_client
      @torrent_client = torrent_client
      @notifier = notifier
    end

    def manage
      episodes = current_episodes
      
      Log.info("Current episodes:\r\n #{episodes.inspect}")

      episodes.each do |episode|

        term = search_term_for(episode)
        puts term
        Log.info("Searching for: #{term}")
        results = @search_client.search(term)

        if results.length > 0
          Log.info("Search results:\r\n #{results[0].inspect}")
          add_to_download_queue results[0]
          mark_episode_as_downloaded episode
        else
          Log.info("No results for #{episode.summary}.")
          @notifier.notify("#{episode.summary} could not be found.", "")
        end
      end
    end

    private

    def add_to_download_queue(search_result)
      @torrent_client.add search_result.magnet_link
    end

    def mark_episode_as_downloaded(episode)
      @download_marker.mark(episode)
    end

    def current_episodes
      @shows_provider.shows_for(CurrentTime.get, 1)
      .select { |e|
        !@download_marker.marked?(e) && 
        e.airtime + (@hours_after_air_time / 24.0) <= CurrentTime.get
      }
    end

    def search_term_for(episode)
      show_for_term = episode.show.tr('^A-Za-z0-9 .', '')
      "#{show_for_term} S#{episode.season}E#{episode.number} #{@search_term_suffix}"
    end

  end

end
