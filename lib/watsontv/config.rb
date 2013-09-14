
module WatsOnTv

  class Config

    CFG_FILE = "~/.watsontv"

    MARK_FILE = "~/.watsontv_marked"

    def self.cfg_path
      File.expand_path(CFG_FILE)
    end

    def self.mark_path
      File.expand_path(MARK_FILE)
    end 

    def self.create
        cfg = {
            'tv program export file' => '~/.today_on_tv',
            'mark file' => MARK_FILE,
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
        create
      end
    end

  end



end
