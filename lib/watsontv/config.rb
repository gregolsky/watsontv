
require 'watsontv/date'
require 'yaml'
require 'date'

module WatsOnTv

  class Config

    CFG_FILE = "~/.watsontv"

    def self.cfg_path
      File.expand_path(CFG_FILE)
    end

    def self.create
        cfg = {
            'tv program export file' => '~/.today_on_tv',
            'download directory' => File.expand_path('~/Download'),
            'hours after air time' => 4,
            'search term suffix' => '720p',
            'smtp' => { 'host' => '', 'port' => '', 'username' => '', 'password' => '' },
            'trakt' => { 'api key' => '', 'user' => '' },
            'transmission' => { 'host' => '', 'port' => '' },
            'notification email' => ''
        }
        
        File.open(self.cfg_path, 'w') { |f| f.write(YAML.dump(cfg)) }
        puts 'Setup your #{self.cfg_path} file and run again.'
        exit 0
    end

    def self.load
      path = self.cfg_path
      if File.exists? path
        cfg = YAML.load_file(path)
      else
        cfg = create
      end

      if ARGV.length > 0
        date = DateTime.parse(ARGV[0])
        if date.nil?
          raise ArgumentError.new('Date not recognized')
        end

        get_date = lambda { date }
        CurrentTime.setup(get_date)
      end

      cfg
    end

  end
end
