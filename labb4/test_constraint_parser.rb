require './constraint-parser'
require 'logger'
require 'test/unit'
change_log_level(Logger::INFO)

class TestConstraintParser < Test::Unit::TestCase
  def setup()
    @parser = ConstraintParser.new()
  end

  def test_single_var()
    a = @parser.parse("a = 5")
    assert_equal(5, a[0].value)

    a = @parser.parse("a = 5 + 3")
    assert_equal(8, a[0].value)

    a = @parser.parse("a = 5 - 3")
    assert_equal(2, a[0].value)

    a = @parser.parse("a = 5 * 3")
    assert_equal(15, a[0].value)

    a = @parser.parse("a = 5 / 3")
    assert_equal(5/3, a[0].value)

    a = @parser.parse("a = 2 + 2 * 2")
    assert_equal(6, a[0].value)

    a = @parser.parse("a = (2 + 2) * 2")
    assert_equal(8, a[0].value)

    a = @parser.parse("a = (2 + 2) / (2 * 2)")
    assert_equal(1, a[0].value)
  end
  
  def test_double_vars() 
    a, b = @parser.parse("a = b")
    a.user_assign(5)
    assert_equal(5, a.value)
    assert_equal(5, b.value)

    a, b = @parser.parse("a = b + 5")
    a.user_assign(5)
    assert_equal(5, a.value)
    assert_equal(0, b.value)

    a, b = @parser.parse("a = b + 5")
    b.user_assign(5)
    assert_equal(10, a.value)
    assert_equal(5, b.value)

    a, b = @parser.parse("a = b * 5")
    a.user_assign(5)
    assert_equal(5, a.value)
    assert_equal(1, b.value)

    a, b = @parser.parse("a = b * 5")
    b.user_assign(5)
    assert_equal(25, a.value)
    assert_equal(5, b.value)

    a, b = @parser.parse("a * 10 = b * 5")
    a.user_assign(5)
    assert_equal(5, a.value)
    assert_equal(10, b.value)

    a, b = @parser.parse("a * 10 = b * 5")
    b.user_assign(10)
    assert_equal(5, a.value)
    assert_equal(10, b.value)

    c,f = @parser.parse "9 * c = 5 * (f - 32)"

    assert_false(c.value)
    assert_false(f.value)
  
    f.user_assign(0)
    assert_equal(-18, c.value)
    assert_equal(0, f.value)
    
    f.user_assign(100)
    assert_equal(37, c.value)
    assert_equal(100, f.value)
  end

  def test_multiple_vars()
    a, b, c = @parser.parse("a * b = c * 5")
    b.user_assign(5)
    c.user_assign(10)
    assert_equal(10, a.value)
    assert_equal(5, b.value)
    assert_equal(10, c.value)

    a, b, c = @parser.parse("a + b = 50 + c")
    b.user_assign(10)
    c.user_assign(15)
    assert_equal(55, a.value)
    assert_equal(10, b.value)
    assert_equal(15, c.value)

    a, b, c = @parser.parse("a + b + c = 50")
    b.user_assign(10)
    c.user_assign(15)
    assert_equal(25, a.value)
    assert_equal(10, b.value)
    assert_equal(15, c.value)
  end
end
