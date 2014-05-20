
require 'test/unit'
require 'watsontv/torrent'
require 'watsontv/cli'

class TorrentClientUnitTests < Test::Unit::TestCase
  
  def test_command_formatting
    cmd = "transmission-remote"
    opt = {
      "-a" => "magic://jhkjgk",
      "--move" => "/j/k/l"
    }

    formatted = CommandLine::CommandFormatter.format_command(cmd, opt)
    assert_equal('''transmission-remote -a "magic://jhkjgk" --move "/j/k/l"''', formatted)
  end

  def test_list_output_parsing

    result = TorrentClient::ListOutputParser.parse(File.open('test/transmission_list_output.txt').read)

    assert_equal(1, result.length, result.inspect)
  end
  
end
