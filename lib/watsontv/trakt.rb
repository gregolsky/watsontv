
require 'json'
require 'date'
require 'net/http'

module WatsOnTv

  class TraktClient

    def initialize(api_key, user)
      @api_key = api_key
      @user = user
    end

    def shows_for(date, days_count = 1)
      uri = calendar_uri(date, days_count)
      jsonString = Net::HTTP.get(uri)
      json = JSON.parse(jsonString)
      JsonMapper.map_calendar json
    end

    private

    def calendar_uri(start_date, days_count)
      dateString = start_date.strftime('%Y%m%d')
      URI.parse "http://api.trakt.tv/user/calendar/shows.json/#{@api_key}/#{@user}/#{dateString}/#{days_count}"
    end

  end

  class EpisodeEvent

    attr_reader :show, :title, :airtime

    def initialize(show, title, season, number, airtime)
      @show, @title, @season, @number, @airtime = show, title, season, number, airtime
    end

    def summary
      "#{@show} S#{season}E#{number} \"#{@title}\""
    end

    def season
      @season.to_s.rjust(2, '0')
    end

    def number
      @number.to_s.rjust(2, '0') 
    end

  end

  class JsonMapper

    def self.map_calendar(json)
      json
      .map { |date_data| self.map_date date_data }
      .flatten
    end

    def self.map_date(date_data)
      date_data['episodes'].map { |data| 
        self.map_episode data 
      }
    end

    def self.map_episode(data)
      episode = data['episode']
      show = data['show']
      number, season = episode['number'], episode['season']
      title, showTitle = episode['title'], show['title']
      air_time_utc = DateTime.parse(episode['first_aired_iso']).new_offset(0)
      EpisodeEvent.new(showTitle, title, season, number, air_time_utc)
    end

  end

end
