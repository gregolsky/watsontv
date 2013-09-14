
require 'test/unit'
require 'watsontv/piratebay'

class PirateBayApiUnitTests < Test::Unit::TestCase
  
  def test_client_multiple_results
    cli = PirateBay::Client.new
    result = cli.search('haven s04e01 720p')
    assert result != nil
    assert result.length > 0

    item = result[0]
    assert item.size != nil and item.size.length > 0
    assert item.uploaded_by != nil and item.uploaded_by.length > 0
    assert !(item.name.include? "<")
  end

end
