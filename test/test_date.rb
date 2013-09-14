
require 'test/unit'
require 'watsontv/date'

class DateTests < Test::Unit::TestCase

  def test_date
    assert_not_nil WatsOnTv::CurrentTime.get
  end

end
