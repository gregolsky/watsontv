
require 'test/unit'

class LibraryTests < Test::Unit::TestCase

  def test_string_plus_array

    begin
      err = StandardError.new('asdfasdf')
      raise err
    rescue StandardError => e
      a = 'asdfasd' + (e.backtrace * '\r\n')
    end

  end

end
