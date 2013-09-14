
require 'test/unit'
require 'watsontv/marker'
require 'date'
require 'stringio'
require 'digest/md5'

class MarkerTests < Test::Unit::TestCase

  class T
    attr_reader :summary

    def initialize(s)
      @summary = s
    end
  end

  def test_marking
    io = StringIO.new()
    marker = WatsOnTv::DownloadMarker.new
    marker.load(io)
    marker.mark(T.new("x"))
    marker.mark(T.new("z"))
    assert marker.marked?(T.new("x"))
    assert !marker.marked?(T.new("y"))

    saveio = StringIO.new()
    marker.save(saveio)
    saveio.seek(0)
    saved = saveio.readlines.map { |x| x.strip }
    assert saved.length == 2
    assert saved[0] == Digest::MD5.base64digest('x')
    assert saved[1] == Digest::MD5.base64digest('z')
  end

end
