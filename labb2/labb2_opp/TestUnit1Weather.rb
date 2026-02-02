require './Uppgift1.rb'
require 'test/unit'

class TestUppgift1b < Test::Unit::TestCase
    def setup
        @text = getTextFromTag("weather.txt")
        @data = getWeatherInfo(@text)
    end

    def test_getTextFromTag
        # Checks that we only get data inside the pre tags.
        assert_not_match("<pre>", @test)
        assert_not_match("</pre>", @test)
    end

    def test_getWeatherInfo
        # Checks that the days have their correct data.
        assert_equal(30, @data.length)
        assert_equal([1, 88, 59], @data[0])
        assert_equal([14, 61, 59], @data[13])
        assert_equal([30, 90, 45], @data[29])
    end

    def test_sortByDifference
        # Checks the sort function.
        assert_equal(14, sortByDifference(@data)[0][0])
    end
end
