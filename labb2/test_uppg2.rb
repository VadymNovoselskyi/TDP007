
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
  
  def test_current_unit()
    @listener.tag_start("catalogue", Hash.new())
    @listener.tag_start("sharedSelectionEntries", Hash.new())
    @listener.tag_start("selectionEntry", {"name" => "test"})
    assert_equal(["catalogue", "sharedSelectionEntries", "selectionEntry"], @listener.instance_variable_get("@path"))
    assert_equal("test", @listener.instance_variable_get("@current_unit"))  
    
    @listener.tag_end("selectionEntry")
    @listener.tag_start("selectionEntry", {"name" => "test123"})
    assert_equal("test123", @listener.instance_variable_get("@current_unit"))  
  end
  
  def test_handle_entryLink()
    @listener.handle_entryLink({"hidden" => true, "name" => "test_name1"})
    @listener.handle_entryLink({"hidden" => false, "name" => "test_name2"})
    @listener.handle_entryLink({"name" => "test_name3"})
    assert_false($units.has_key?("test_name1"))  
    assert_false($units.has_key?("test_name2"))  
    assert_true($units.has_key?("test_name3"))  
    assert_equal(0, $units["test_name3"])
  end

  def test_handle_cost()
    @listener.instance_variable_set("@current_unit", "test_unit")
    @listener.handle_entryLink({"name" => "test_unit"}) 
    assert_equal(0, $units["test_unit"])
    
    @listener.handle_cost({"name" => "not_pts", "value" => 100}) 
    assert_equal(0, $units["test_unit"])
    @listener.handle_cost({"name" => "pts", "value" => 999}) 
    assert_equal(999, $units["test_unit"])
  end
end
class TestParsers < Test::Unit::TestCase
  def setup()
  @parse_res = {
    "Acastus Knight Asterius"=>"765",
    "Acastus Knight Porphyrion"=>"700",
    "Armiger Helverin"=>"140",
    "Armiger Moirax"=>"150",
    "Armiger Warglaive"=>"140",
    "Canis Rex"=>"415",
    "Cerastus Knight Acheron"=>"395",
    "Cerastus Knight Atrapos"=>"405",
    "Cerastus Knight Castigator"=>"395",
    "Cerastus Knight Lancer"=>"395",
    "Knight Castellan"=>"410",
    "Knight Crusader"=>"385",
    "Knight Defender"=>"415",
    "Knight Errant"=>"365",
    "Knight Gallant"=>"365",
    "Knight Paladin"=>"375",
    "Knight Preceptor"=>"365",
    "Knight Valiant"=>"410",
    "Knight Warden"=>"375",
    "Questoris Knight Magaera"=>"385",
    "Questoris Knight Styrix"=>"385"
  }
  end


  def test_stream_parser()
    assert_equal(@parse_res, stream_parser())
  end
  
  def test_dom_parser()
    assert_equal(@parse_res, dom_parser())
  end
  
  def test_both_parsers()
    assert_equal(stream_parser(), dom_parser())
  end
end
