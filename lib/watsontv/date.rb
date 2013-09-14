
module WatsOnTv

  class CurrentTime
  
    @@get_date = lambda { DateTime.now }

    def self.get
      @@get_date.call
    end

  end

end
