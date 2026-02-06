require './uppgift2'
require 'test/unit'

class TestParser < Test::Unit::TestCase
  def setup()
    @parser = LangParser.new()
  end

  def test_assign()
    assert_equal(false, @parser.langParser.parse("(set a false)"))
    assert_equal(false, @parser.langParser.parse("a"))
    
    assert_equal(true, @parser.langParser.parse("(set b true)"))
    assert_equal(true, @parser.langParser.parse("b"))
    
    assert_equal(false, @parser.langParser.parse("(set c a)"))
    assert_equal(true, @parser.langParser.parse("(set d b)"))
    
    assert_equal(true, @parser.langParser.parse("(set a true)"))
    assert_equal(true, @parser.langParser.parse("a"))
  end

  def test_or()
    assert_equal(true, @parser.langParser.parse("(or true true)"))
    assert_equal(true, @parser.langParser.parse("(or true false)"))
    assert_equal(true, @parser.langParser.parse("(or false true)"))
    assert_equal(false, @parser.langParser.parse("(or false false)"))
    
    @parser.langParser.parse("(set a true)")
    @parser.langParser.parse("(set b false)")
    assert_equal(true, @parser.langParser.parse("(or a a)"))
    assert_equal(true, @parser.langParser.parse("(or a b)"))
    assert_equal(true, @parser.langParser.parse("(or b a)"))
    assert_equal(false, @parser.langParser.parse("(or b b)"))
  end

  def test_and()
    assert_equal(true, @parser.langParser.parse("(and true true)"))
    assert_equal(false, @parser.langParser.parse("(and true false)"))
    assert_equal(false, @parser.langParser.parse("(and false true)"))
    assert_equal(false, @parser.langParser.parse("(and false false)"))
    
    @parser.langParser.parse("(set a true)")
    @parser.langParser.parse("(set b false)")
    assert_equal(true, @parser.langParser.parse("(and a a)"))
    assert_equal(false, @parser.langParser.parse("(and a b)"))
    assert_equal(false, @parser.langParser.parse("(and b a)"))
    assert_equal(false, @parser.langParser.parse("(and b b)"))
  end  

  def test_not()
    assert_equal(false, @parser.langParser.parse("(not true)"))
    assert_equal(true, @parser.langParser.parse("(not false)"))
    
    @parser.langParser.parse("(set a true)")
    @parser.langParser.parse("(set b false)")
    assert_equal(false, @parser.langParser.parse("(not a)"))
    assert_equal(true, @parser.langParser.parse("(not b)"))
  end  

  def test_mix()
    assert_equal(false, @parser.langParser.parse("(and true (not true))"))
    assert_equal(true, @parser.langParser.parse("(and true (not false))"))
    assert_equal(false, @parser.langParser.parse("(or false (not true))"))
    assert_equal(true, @parser.langParser.parse("(or false (not false))"))

    assert_equal(false, @parser.langParser.parse("(and (or true false) (or false false))"))
    assert_equal(false, @parser.langParser.parse("(and (or true false) (not true))"))
    assert_equal(true, @parser.langParser.parse("(and (or true false) (not false))"))
    assert_equal(false, @parser.langParser.parse("(or (and true false) (not true))"))
    assert_equal(true, @parser.langParser.parse("(or (and true false) (not false))"))
  end

  def test_errors()
    assert_raise(Parser::ParseError) { @parser.langParser.parse("set a false") }
    assert_raise(SyntaxError) { @parser.langParser.parse("(set a false") }
    assert_raise(Parser::ParseError) { @parser.langParser.parse("or true false)") }
  end
end