
module WatsOnTv

  class CurrentTime
  
    @@get_date = lambda { DateTime.now }

    def self.get
      @@get_date.call
    end

    def self.setup(get_date)
      @@get_date = get_date
    end

  end

end
