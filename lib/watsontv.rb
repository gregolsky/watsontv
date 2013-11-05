
require 'watsontv/config'
require 'watsontv/download'
require 'watsontv/library'
require 'watsontv/piratebay'
require 'watsontv/torrent'
require 'watsontv/trakt'
require 'watsontv/notify'

module WatsOnTv

  class Program

    def run
      cfg = Config.load
      manager = build_manager(cfg)
      manager.manage
    end

    def build_manager(cfg)
      shows_provider = TraktClient.new(cfg['trakt']['api key'], cfg['trakt']['user'])
      search_client = PirateBay::Client.new
      torrent_client = TorrentClient::TransmissionDaemon.new(cfg['transmission']['host'], cfg['transmission']['port'])
      smtp_cfg = cfg['smtp']
      notifier = SmtpNotifier.new smtp_cfg['host'], smtp_cfg['port'].to_i, smtp_cfg['username'], smtp_cfg['password'], cfg['notification email']
      library = LibraryLoader.load(cfg['download directory'])
      
      DownloadManager.new(cfg, shows_provider, library, search_client, torrent_client, notifier)
    end


  end

end

