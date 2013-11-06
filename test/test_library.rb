
require 'test/unit'
require 'watsontv/library'
require 'date'
require 'stringio'
require 'digest/md5'

require_relative 'mimic'

class LibraryTests < Test::Unit::TestCase

  def test_contains
    e = TestUtils::Mimic.new({ 'show' => 'Most Stupid Show  ever', 'season' => '04', 'number' => '02' })
    
    library = WatsOnTv::Library.new([ "Most.stupid.show.ever.s04e02.hdtv.mkv", "asdf s01e01[hd].mp4"])
    assert library.contains?(e)
  end

end
