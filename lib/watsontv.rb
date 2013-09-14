
require 'watsontv/config'
require 'watsontv/download'
require 'watsontv/marker'
require 'watsontv/piratebay'
require 'watsontv/torrent'
require 'watsontv/trakt'
require 'watsontv/notify'

module WatsOnTv

  class Program

    def run
      cfg = Config.load
      download_marker = build_download_marker(cfg)
      manager = build_manager(cfg, download_marker)
      manager.manage
      save_markers(cfg, download_marker)
    end

    def build_download_marker(cfg)
      download_marker = DownloadMarker.new

      file = File.expand_path(cfg['mark file'])

      if !File.exists?(file)
        return download_marker
      end

      File.open(file, 'r') do |f|
        download_marker.load(f)
      end

      download_marker
    end

    def save_markers(cfg, marker)
      File.open(File.expand_path(cfg['mark file']), 'w') do |f|
        marker.save(f)
      end
    end

    def build_manager(cfg, marker)
      shows_provider = TraktClient.new(cfg['trakt']['api key'], cfg['trakt']['user'])
      search_client = PirateBay::Client.new
      torrent_client = TorrentClient::TransmissionDaemon.new(cfg['transmission']['host'], cfg['transmission']['port'])
      smtp_cfg = cfg['smtp']
      notifier = SmtpNotifier.new smtp_cfg['host'], smtp_cfg['port'].to_i, smtp_cfg['username'], smtp_cfg['password'], cfg['notification email']
      
      DownloadManager.new(cfg, shows_provider, marker, search_client, torrent_client, notifier)
    end


  end

end

