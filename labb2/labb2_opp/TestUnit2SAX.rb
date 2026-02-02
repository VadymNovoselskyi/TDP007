require './Uppgift2SAX'
require 'test/unit'

class TestUppgift2SAX < Test::Unit::TestCase
    def setup
        @listener = MyListener.new
        @src = File.new("Imperium-Imperial-Knights_Library.xml")
        REXML::Document.parse_stream(@src, @listener)
        @units = @listener.get_unit_info() 
    end

    def test_get_names
        #tests existing units
        assert(@units.key?("Canis Rex"))
        assert(@units.key?("Knight Gallant"))
        assert(@units.key?("Knight Valiant"))
        #test none existing character (characters with hidden attribue)
        assert_nil(@units["Acastus Knight Asterius"])
    end

    def test_size
        assert_equal(11, @units.length)
    end

    def test_price
        #tests that units has the right price
        assert_equal(415, @units["Canis Rex"])
        assert_equal(365, @units["Knight Gallant"])
        assert_equal(410, @units["Knight Valiant"])
        #tests that all selected units has a price
        @units.each do |name, price|
            assert_not_nil(price, "#{name} is missing a price")
        end
    end
end