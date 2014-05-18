require 'transmission-rpc'

module TorrentClient
  class TransmissionDaemon
    
    def initialize(host, port)
      Transmission::configure do |cfg|
        cfg.ip = host
        cfg.port = port  
      end
    end
    
    def add(download_info)
      Transmission::RPC::Torrent.add({
        :filename => download_info[:magnet],
        :download_dir => download_info[:download_directory]
      });
    end
    
    def list
      Transmission.torrents
    end
    
  end
end
