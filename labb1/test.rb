require 'test/unit'
require './main'

class TestLevel < Test::Unit::TestCase
  def setup
    @level = Level.new()
  end

  def test_get_object
    assert_equal("#", @level.get_object(0, 5))
    assert_equal("@", @level.get_object(@level.instance_variable_get(:@player_x), @level.instance_variable_get(:@player_y))) 
  end

  def test_set_object
    @level.set_object(1, 1, "X")
    assert_equal("X", @level.get_object(1, 1))
  end

  def test_move_player_into_wall
    initial_x = @level.instance_variable_get(:@player_x)
    initial_y = @level.instance_variable_get(:@player_y)
    @level.move_player(1, 0)  # Right in to a wall
    @level.move_player(-1, 0) # Left in to a wall
    @level.move_player(0, 1)  # Down in to a wall
    assert_equal(initial_x, @level.instance_variable_get(:@player_x))
    assert_equal(initial_y, @level.instance_variable_get(:@player_y))
  end

    def test_move_player_into_empty_space
    initial_x = @level.instance_variable_get(:@player_x)
    initial_y = @level.instance_variable_get(:@player_y)
    @level.move_player(0, -1)
    assert_equal(initial_x, @level.instance_variable_get(:@player_x))
    assert_equal(initial_y - 1, @level.instance_variable_get(:@player_y))
  end
end