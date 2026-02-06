require './uppgift1'
require 'test/unit'

class TestPolicy < Test::Unit::TestCase
  def setup()
    @person = Person.new("Volvo","58435",2,"M",32)
  end

  def test_evaluate_policy()
    person2 = Person.new("BMW","58937",88,"W",35)
    person3 = Person.new("Open","58647",2,"W",18)

    assert_equal(15.66, @person.evaluate_policy("policy.rb"))
    assert_equal(24.5, person2.evaluate_policy("policy.rb"))
    assert_equal(10.5, person3.evaluate_policy("policy.rb"))
  end

  def test_method_missing()
    @person.car_BMW(1)
    assert_equal(0, @person.instance_eval("@points"))

    @person.car_Volvo(10)
    assert_equal(10, @person.instance_eval("@points"))

    @person.car_VoLvO(10)
    assert_equal(20, @person.instance_eval("@points"))

    @person.code_58435(10)
    assert_equal(30, @person.instance_eval("@points"))

    @person.age_18_20(10)
    assert_equal(30, @person.instance_eval("@points"))
    @person.age_30_39(10)
    assert_equal(40, @person.instance_eval("@points"))
  end

  def test_handle_range()
    @person.instance_eval("@test_attr=10")
    @person.handle_range("test_attr", "1_9", 1)
    assert_equal(0, @person.instance_eval("@points"))

    @person.handle_range("test_attr", "1_10", 10)
    assert_equal(10, @person.instance_eval("@points"))
    
    @person.handle_range("test_attr", "5_55", 100)
    assert_equal(110, @person.instance_eval("@points"))

    @person.handle_range("test_attr", "10_99", 1000)
    assert_equal(1110, @person.instance_eval("@points"))
    
    @person.handle_range("test_attr", "99_1000", 10000)
    assert_equal(1110, @person.instance_eval("@points"))
  end
end