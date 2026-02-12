require './calculatePolicy.rb'
require 'test/unit'

class TestCalculatePolicy < Test::Unit::TestCase
    def setup
        @kalle = Person.new("Volvo","58435",2,"M",32)
        @person = Person.new("Volvo","58435",2,"M",32)
        @ludvig = Person.new("Fiat", "60455", 2, "M", 23)
        @noResult = Person.new("a","000",100,"U",120)
        @points = Person.new("a","000",100,"U",120)
    end

    def test_evaluatePolicy()
        assert_equal(15.66, @kalle.evaluatePolicy("policy.rb"))
        assert_equal(15.66, @kalle.evaluatePolicy("policy.rb"))
        assert_equal(9.9, @ludvig.evaluatePolicy("policy.rb"))
        assert_equal(0, @noResult.evaluatePolicy("policy.rb"))
    end

    def test_return_value()
        # tests that the right score is added
        assert_equal(5, @kalle.car("Volvo", 5))
        assert_equal(9, @ludvig.zipCode("60455", 9))
    end

    def test_matchValues_range
        assert(@person.matchValues(5, 1..10))
        assert_equal(false, @person.matchValues(15, 1..10))
        assert_equal(false, @person.matchValues(0.99, 1..10))
        assert_equal(false, @person.matchValues(10.0001, 1..10))
        assert(@person.matchValues(7.5, 5..10))
    end
    def test_validateArgs_wrong_args_count
        assert_nil(@person.validateArgs([1], 5))
        assert_nil(@person.validateArgs([1,2,3], 5))
    end

    def test_matchValues_string
        assert(@person.matchValues("Volvo", "Volvo"))
        assert(@person.matchValues("volvo", "VOLVO"))
        assert_equal(false, @person.matchValues("Volvo", "Fiat"))
        assert(@person.matchValues("58435", "58435"))
        assert_equal(false, @person.matchValues("58435", "60455"))
    end

    def test_uppdatePoints_valid
        currentValue = "volvo"
        args = ["volvo", 10]

        @person.uppdatePoints(args, currentValue)
        assert_equal(10, @person.getPoints())
        currentValue = "VolvO"
        args = ["volvo", -10]

        @person.uppdatePoints(args, currentValue)
        assert_equal(0, @person.getPoints())
    end
    def test_uppdatePoints_not_valid
        currentValue = "bmw"
        args = ["volvo", 10]

        @person.uppdatePoints(args, currentValue)
        assert_equal(0, @person.getPoints())
    end
    def test_uppdatePoints_range_valid
        currentValue = 2.5
        args = [2..3, 5]

        @person.uppdatePoints(args, currentValue)
        assert_equal(5, @person.instance_variable_get(:@points))
    end

    def test_addPoints()
        assert_equal(5, @points.addPoints(5))
        assert_equal(10, @points.addPoints(5))
        assert_equal(5, @points.addPoints(-5))
    end
    
end
