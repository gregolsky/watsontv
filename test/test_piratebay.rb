
require 'test/unit'
require 'watsontv/piratebay'

class PirateBayApiUnitTests < Test::Unit::TestCase
  
  def _client_multiple_results
    cli = PirateBay::Client.new
    result = cli.search('ubuntu')
    assert result != nil
    assert result.length > 0

    item = result[0]
    assert item.size != nil and item.size.length > 0
    assert item.uploaded_by != nil and item.uploaded_by.length > 0
    assert !(item.name.include? "<")
  end
  
  def test_results_mapping
    assert File.exists?('./test/file_still_uploading.html')
    page = PirateBay::WebPage.new('http://test', open('./test/file_still_uploading.html'))
    results = PirateBay::ResultsMapper.map(page)
    assert results.length > 0
  end

end
