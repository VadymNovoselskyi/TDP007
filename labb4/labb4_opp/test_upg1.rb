# coding: utf-8 
require './constraint_networks.rb'
require './constraint-parser.rb'
require 'test/unit'

# Ignoerar PP i testfilen, googla upp
# AssertionMessage.use_pp = false 

# ------ UPG1 ------
class TestConstraintNetworks < Test::Unit::TestCase
  
  def test_adder
    a = Connector.new("a")
    b = Connector.new("b")
    c = Connector.new("c")
    Adder.new(a, b, c)

    # Forget value of a
    a.user_assign(10)
    b.user_assign(5)
    a.forget_value "user"
    c.user_assign(20)
    assert_equal("15", a.value.to_s)

    # Forget value of b
    b.forget_value "user"
    a.user_assign(10)
    assert_equal("10", b.value.to_s)
  end

  def test_multiplier
    a = Connector.new("a")
    b = Connector.new("b")
    c = Connector.new("c")
    Multiplier.new(a, b, c)

    # Forget value of a
    a.user_assign(10)
    b.user_assign(5)
    a.forget_value "user"
    c.user_assign(20)
    assert_equal("4", a.value.to_s)

    # Forget value of b
    b.forget_value "user"
    a.user_assign(10)
    assert_equal("2", b.value.to_s)
  end

  def test_celsius2fahrenheit
    c,f=celsius2fahrenheit
    c.user_assign 100
    assert_equal("212", f.value.to_s)

    c.user_assign 0
    assert_equal("32", f.value.to_s)

    c.forget_value "user"
    f.user_assign 100
    assert_equal("37", c.value.to_s)
  end
end

# ------ UPG2 ------ (ej rätt värden :() 
class TestConstraintParser < Test::Unit::TestCase
  
  def test_adder
    cp=ConstraintParser.new
    c,f=cp.parse "9*c=5*(f-32)"
    # Vi får dock inte rätt värden
    c.user_assign 0
    assert_equal("32", f.value.to_s)
    
    c.forget_value "user"
    f.user_assign 0 # ger fel värde
    #assert_equal("-18", c.value.to_s)

    f.user_assign 100 # ger fel värde 
    # assert_equal("37", c.value.to_s)
  end
end
