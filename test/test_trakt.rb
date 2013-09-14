
require 'test/unit'
require 'watsontv/trakt'
require 'date'

class TraktClientTests < Test::Unit::TestCase

  def test_get_todays_episodes
    c = WatsOnTv::TraktClient.new("1c1079c847bbf1df4fcbf794d9324959", 'gregorl')
    episodes = c.shows_for(DateTime.parse('2013-09-13') - 1, 2)
    assert episodes.length == 1
    e = episodes[0]
    assert e.show == "Haven"
    assert e.number == 1
    assert e.season == 4
  end

end
