require './Uppgift2DOM'
require 'test/unit'

class TestUppgift2DOM < Test::Unit::TestCase
    def setup
        @src = File.open("Imperium-Imperial-Knights_Library.xml")
        @doc = REXML::Document.new(@src)
        @names = getSelectedNames(@doc)
    end
    # Tests the method by checking the first, middle and last name from the hash.
    def test_get_names()
        # Checks if the unit is found.
        assert(@names.key?("Canis Rex"))
        assert(@names.key?("Knight Gallant"))
        assert(@names.key?("Knight Valiant"))
        # Checks that no price has been added.
        @names.each do |name, price|
            assert_equal(nil, @names[name])
        end
    end
    def test_get_unit_price()
        # Checks the price of the first, middle and last unit.
        getUnitsPrice(@doc, @names)
        assert_equal(415, @names["Canis Rex"])
        assert_equal(365, @names["Knight Gallant"])
        assert_equal(410, @names["Knight Valiant"])
    end
    def test_found_all_prices()
        # Checks that all characters has a price.
        getUnitsPrice(@doc, @names)
        @names.each do |name, price|
            assert_not_nil(price, "#{name} is missing a price")
        end
    end

    
end