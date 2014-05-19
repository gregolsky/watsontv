require 'transmission-rpc'

module TorrentClient
  class TransmissionDaemon
    
    def initialize(host, port)
      Transmission::configure do |cfg|
        cfg.ip = host
        cfg.port = port  
      end
    end
    
    def add(magnet, options)
      puts magnet, options
      Transmission::RPC::Torrent.add({
        :filename => magnet,
        :download_dir => options[:download_directory]
      })
    end
    
    def list
      Transmission.torrents
    end
    
  end
end
