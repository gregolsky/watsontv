
require 'json'
require 'date'
require 'net/http'

module WatsOnTv

  class ClientError < StandardError
    
    def initialize(uri, http_code, http_response)
      @request_uri = uri
      @http_code, @http_response = http_code, http_response
    end
    
    def to_s
      "Error during request for #{@request_uri}\r\n\r\nStatus: #{@http_code}\r\nResponse: #{@http_response}"
    end
    
  end

  class TraktClient

    def initialize(api_key, user)
      @api_key = api_key
      @user = user
    end

    def shows_for(date, days_count = 1)
      uri = calendar_uri(date, days_count)
      http = Net::HTTP.new(uri.host, uri.port)
      request = Net::HTTP::Get.new(uri.request_uri)
      response = http.request(request)
      
      if response.code.to_i != 200
        raise ClientError.new(uri, response.code, response.body)
      end
      
      json = JSON.parse(response.body)
      JsonMapper.map_calendar json
    end

    private

    def calendar_uri(start_date, days_count)
      dateString = start_date.strftime('%Y%m%d')
      URI.parse "http://api.trakt.tv/user/calendar/shows.json/#{@api_key}/#{@user}/#{dateString}/#{days_count}"
    end

  end

  class EpisodeEvent

    attr_reader :show, :title, :airtime, :runtime

    def initialize(show, title, season, number, airtime, runtime)
      @show, @title, @season, @number, @airtime, @runtime = show, title, season, number, airtime, runtime
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
      .map { |timeframe| self.map_date timeframe }
      .flatten
    end

    def self.map_date(timeframe)
      timeframe['episodes'].map { |data| 
        self.map_episode data 
      }
    end

    def self.map_episode(data)
      episode = data['episode']
      show = data['show']
      number, season = episode['number'], episode['season']
      title, showTitle = episode['title'], show['title']
      air_time_utc = DateTime.parse(episode['first_aired_iso']).new_offset(0)
      runtime = show['runtime'].to_i
      EpisodeEvent.new(showTitle, title, season, number, air_time_utc, runtime)
    end

  end

end
