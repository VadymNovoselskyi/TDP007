require 'test/unit'
require './main'

class TestPlayerMovement < Test::Unit::TestCase
  
  def test_move_player_into_wall()
    level = Level.new("sokoban_test_level_1.txt")

    initial_x = level.instance_variable_get(:@player_x)
    initial_y = level.instance_variable_get(:@player_y)
    
    level.move_player(1, 0)  # Right in to a wall
    assert_equal(initial_x, level.instance_variable_get(:@player_x))
    assert_equal(initial_y, level.instance_variable_get(:@player_y))
    
    level.move_player(-1, 0) # Left in to a wall
    assert_equal(initial_y, level.instance_variable_get(:@player_y))
    assert_equal(initial_x, level.instance_variable_get(:@player_x))
    
    level.move_player(0, 1)  # Down in to a wall
    assert_equal(initial_y, level.instance_variable_get(:@player_y))
    assert_equal(initial_x, level.instance_variable_get(:@player_x))
    
    level.move_player(0, -1)  # Up in to a wall
    assert_equal(initial_y, level.instance_variable_get(:@player_y))
    assert_equal(initial_x, level.instance_variable_get(:@player_x))
  end
  
  def test_move_player_into_empty_space()
    level = Level.new("sokoban_test_level_2.txt")
    initial_x = level.instance_variable_get(:@player_x)
    initial_y = level.instance_variable_get(:@player_y)
    
    
    level.move_player(0, -1)
    assert_equal(initial_x, level.instance_variable_get(:@player_x))
    assert_equal(initial_y - 1, level.instance_variable_get(:@player_y))
    
    level.move_player(0, 1)
    assert_equal(initial_x, level.instance_variable_get(:@player_x))
    assert_equal(initial_y, level.instance_variable_get(:@player_y))
    
    level.move_player(1, 0)
    assert_equal(initial_x + 1, level.instance_variable_get(:@player_x))
    assert_equal(initial_y, level.instance_variable_get(:@player_y))
    
    level.move_player(-1, 0)
    assert_equal(initial_x, level.instance_variable_get(:@player_x))
    assert_equal(initial_y, level.instance_variable_get(:@player_y))
  end

  def test_box_movement()
  level = Level.new("sokoban_test_level_4.txt")  
  initial_x = level.instance_variable_get(:@player_x)
  initial_y = level.instance_variable_get(:@player_y)
  
  # Player moves in to a box that cant be moved
  level.move_player(0, -1)
  assert_equal(initial_x, level.instance_variable_get(:@player_x))
  assert_equal(initial_y, level.instance_variable_get(:@player_y))
  assert_equal("o", level.get_object(initial_x, initial_y - 1))
  
  # Player moves in to a box that moves on to a storage
  level.move_player(0, 1)
  
  assert_equal(initial_x, level.instance_variable_get(:@player_x))
  assert_equal(initial_y + 1, level.instance_variable_get(:@player_y))
  assert_equal("*", level.get_object(initial_x, initial_y + 2))
  
  end

end

class TestMapHelpers < Test::Unit::TestCase
  def test_get_object()
    level = Level.new("sokoban_level.txt")
    assert_equal("#", level.get_object(0, 5))
    assert_equal("@", level.get_object(level.instance_variable_get(:@player_x), level.instance_variable_get(:@player_y))) 
  end
  
  def test_set_object()
    level = Level.new("sokoban_level.txt")
    level.set_object(1, 1, "X")
    assert_equal("X", level.get_object(1, 1))
  end

  def test_load_level()
    level = Level.new("sokoban_test_level_1.txt")
    correct_level = [["#", "#", "#"], ["#", "@", "#"], ["#", "#", "#"]]
    assert_equal(correct_level, level.instance_variable_get(:@map))
  end

  def test_is_complete()
    level = Level.new("sokoban_test_level_1.txt")
    assert_true(level.is_complete())
    
    level = Level.new("sokoban_level.txt")
    assert_false(level.is_complete())
    
    level = Level.new("sokoban_test_level_3.txt")
    assert_true(level.is_complete())
  end
end

