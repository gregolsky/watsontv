
require 'test/unit'
require 'watsontv/trakt'
require 'date'

class TraktClientTests < Test::Unit::TestCase

  def test_get_todays_episodes
    c = WatsOnTv::TraktClient.new("1c1079c847bbf1df4fcbf794d9324959", 'gregorl')
    episodes = c.shows_for(DateTime.parse('2013-09-14'))
    assert episodes.length == 1
    e = episodes[0]
    assert e.show == "Haven"
    assert e.number == '01'
    assert e.season == '04'
    assert DateTime.parse('2013-09-13T22:00:00-04:00').new_offset(0) == e.airtime
    assert e.airtime.hour == 2
  end

  def test_get_old_episodes
    c = WatsOnTv::TraktClient.new("1c1079c847bbf1df4fcbf794d9324959", 'gregorl')
    episodes = c.shows_for(DateTime.parse('2013-12-24'))
    assert episodes.length == 1
  end

end
