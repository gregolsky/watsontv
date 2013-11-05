
require 'test/unit'
require 'watsontv/library'
require 'date'
require 'stringio'
require 'digest/md5'

class LibraryTests < Test::Unit::TestCase

  class Mimic
    def add_attrs(attrs)
      attrs.each do |var, value|
        (class << self ; self ; end).class_eval { attr_accessor var }
        instance_variable_set "@#{var}", value
      end
    end
  end

  def test_contains
    e = Mimic.new
    e.add_attrs({ 'show' => 'Most Stupid Show  ever', 'season' => '04', 'number' => '02' })
    
    library = WatsOnTv::Library.new([ "Most.stupid.show.ever.s04e02.hdtv.mkv", "asdf s01e01[hd].mp4"])
    assert library.contains?(e)
  end

end
