require './Uppgift1'
require 'test/unit'

class TestUppgift1 < Test::Unit::TestCase
    def setup
        @text = getTextFromTag("football.txt")
        @teams = getTeamInfo(@text)
    end

    def test_getTeams
        # Checks that we get wanted names.
        assert_equal(20, getTeams(@text).length)
        assert_equal("Arsenal", getTeams(@text)[0])
        assert_equal("Leicester", getTeams(@text)[19])
    end

    def test_getNumbers
        # Checks that we get wanted data.
        assert_equal(20, getTeamNumbers(@text).length)
        assert_equal([79, 36], getTeamNumbers(@text)[0])
        assert_equal([30, 64], getTeamNumbers(@text)[19])
    end

    def test_TeamInfo
        # Checks that the team has their correct data.
        assert_equal(20, @teams.length)
        assert_equal(["Arsenal", 79, 36], @teams[0])
        assert_equal(["Leicester", 30, 64], @teams[19])
    end

    def test_sortTeams
        # Checks the sort function.
        assert_equal("Aston_Villa", sortByDifference(@teams)[0][0])
    end
end