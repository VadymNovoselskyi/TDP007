
require 'rexml/streamlistener'
require 'rexml/document'
require 'test/unit'
require './uppg2'

class TestMyListener < Test::Unit::TestCase
  def setup()
    @listener = MyListener.new()
    $units = Hash.new()
  end

  def test_tags()
    @listener.tag_start("catalogue", Hash.new())
    @listener.tag_start("entryLinks", Hash.new())
    @listener.tag_start("entryLink", Hash.new())
    assert_equal(["catalogue", "entryLinks", "entryLink"], @listener.instance_variable_get("@path"))

    @listener.tag_end("entryLink")
    @listener.tag_end("entryLinks")
    @listener.tag_end("catalogue")
    assert_equal([], @listener.instance_variable_get("@path"))
  end
end

class TestStreamParser < Test::Unit::TestCase
end

class TestDomParser < Test::Unit::TestCase
end

