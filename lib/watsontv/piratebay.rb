
require 'open-uri'
require 'nokogiri'

module PirateBay

  class Client

    @@url = 'http://thepiratebay.org'

    def search(term, page = 0)
      encoded_term = URI::Parser.new.escape(term)
      search_url = "#{@@url}/search/#{encoded_term}/#{page}/7/0"
      io = open(search_url)
      web_page = WebPage.new(search_url, io)
      ResultsMapper.map(web_page)
    rescue StandardError => e
      raise ClientError.new(web_page, e)
    end
    


  end
  
  class ClientError < StandardError
    
    attr_reader :page, :error
    
    def initialize(page, error)
      @page = page
      @error = error
    end
    
    def to_s
      "#{@error.to_s}\r\n\r\nHTML:\r\n#{@page.to_s}"
    end
    
  end

  class Torrent

    attr_reader :name, :magnet_link, :desc, :seed_count, :leech_count, :size, :uploaded_by

    def initialize(name, magnet_link, size, seed_count, leech_count, uploaded_by)
      @name = name
      @magnet_link = magnet_link
      @seed_count = seed_count
      @leech_count = leech_count
      @size = size
      @uploaded_by = uploaded_by
    end

    def Torrent.from_table_row(row)
      name = row.at('a.detLink').inner_html.chomp
      magnet_link = row.at('a[href^=magnet]')['href'].chomp
      
      desc, uploaded_by = row.at('font.detDesc').children.map do |ch|
        if WebPageNode.is_text?(ch)
          ch.to_s
        else
          ch.children.first.to_s
        end
      end
      
      parsedDesc = desc.scan(/Size ([0-9.]*.[A-Za-z]*),/)
      if not parsedDesc.nil? and not parsedDesc[0].nil?
        size = parsedDesc[0][0]
      end
      
      seed_count = row.search('td')[2].inner_html.chomp.to_i
      leech_count = row.search('td')[3].inner_html.chomp.to_i

      Torrent.new(name, magnet_link, size, seed_count, leech_count, uploaded_by)
    end
    
  end
  
  class ResultsMapper
  
    def self.map(page)
      page.search('table#searchResult tr')
        .map { |r| self.map_result_row(r) }
        .select { |t| t != nil }
    end
    
    def self.map_result_row(row)
      Torrent.from_table_row(row) unless row.at('a.detLink') == nil
    end
  
  end

  class WebPageNode
  
    def initialize(node)
      @node = node
    end

    def search(selector)
      @node.css(selector)
    end
    
    def WebPageNode.is_text?(node)
      node.is_a? Nokogiri::XML::Text
    end
    
    def to_s
      @node.to_s
    end
  end

  class WebPage < WebPageNode
    def initialize(url, content)
      doc = Nokogiri::HTML(content)
      super(doc)
      @url = url
    end
  end
  
  

end
