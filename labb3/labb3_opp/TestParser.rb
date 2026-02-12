require './rdparse'
require 'test/unit'

class TestCalc < Test::Unit::TestCase
    def setup
        @calc1 = Calc.new
    end

    def test_or
        assert_equal(true, @calc1.calcParse("( or true false)"))
        assert_equal(true, @calc1.calcParse("( or false true)"))
        assert_equal(false, @calc1.calcParse("( or false false)"))
        assert_equal(true, @calc1.calcParse("( or true true)"))
    end

    def test_and
        assert_equal(true, @calc1.calcParse("( and true true)"))
        assert_equal(false, @calc1.calcParse("( and true false)"))
        assert_equal(false, @calc1.calcParse("( and false false)"))
    end

    def test_not
        assert_equal(true, @calc1.calcParse("( not false )"))
        assert_equal(false, @calc1.calcParse("( not true )"))
    end

    def test_nested
        assert_equal(true, @calc1.calcParse("( or true ( and false ( or true false)))"))
        assert_equal(false, @calc1.calcParse("( and false ( or true false))"))
        assert_equal(true, @calc1.calcParse("( not ( and false ( or false false)))"))
        assert_equal(true, @calc1.calcParse("( or ( not false) ( and true false))"))
    end

    def test_set 
        assert_equal(true, @calc1.calcParse("(set x true)"))
        assert_equal(false, @calc1.calcParse("(set @x false)"))
        assert_equal(true, @calc1.calcParse("(set $x true)"))
        assert_equal(true, @calc1.calcParse("(set _ true)"))
    end

    def test_return_bolean
        assert_boolean(@calc1.calcParse("(set x true)"))
        assert_boolean(@calc1.calcParse("(and false true)"))
        assert_boolean(@calc1.calcParse("(or false true)"))
        assert_boolean(@calc1.calcParse("true"))
    end

    #https://ruby-doc.org/stdlib-3.0.2/libdoc/test-unit/rdoc/Test/Unit/Assertions.html#method-i-assert_raise
    def test_set_invalid_names
        assert_raise(Parser::ParseError) { @calc1.calcParse("(set X true)") }
        assert_raise(Parser::ParseError) { @calc1.calcParse("(set Abc false)") }

        assert_raise(Parser::ParseError) { @calc1.calcParse("(set 1x true)") }
        assert_raise(Parser::ParseError) { @calc1.calcParse("(set 42var false)") }

        assert_raise(Parser::ParseError) { @calc1.calcParse("(set %foo true)") }
        assert_raise(Parser::ParseError) { @calc1.calcParse("(set -bar false)") }
    end

    def test_invalid_syntax
        assert_raise(Parser::ParseError) { @calc1.calcParse("(set  true)") }
        assert_raise(Parser::ParseError) { @calc1.calcParse("(and  true)") }
        assert_raise(Parser::ParseError) { @calc1.calcParse("(or  true)") }
        assert_raise(Parser::ParseError) { @calc1.calcParse(" true)") }

        assert_raise(KeyError) { @calc1.calcParse("(set  abc_def yes)") }
        assert_raise(KeyError) { @calc1.calcParse(" tru e") }
        assert_raise(KeyError) { @calc1.calcParse(" fals") }
    end
end
