
require 'test/unit'
require 'watsontv/filter'

require_relative 'mimic'

class LibraryTests < Test::Unit::TestCase

  def test_filter_by_size
    e = TestUtils::Mimic.new({ 'runtime' => 60 })
    t = TestUtils::Mimic.new({ 'name' => 'x', 'size' => '100 MiB' })
    
    assert !(WatsOnTv::SearchResultsFilter.filter(e, t))
  end

end
