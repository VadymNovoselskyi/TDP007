require './sokoban'
require 'test/unit'

# TODO! Setup conflicts with local changes to global $board which makes some tests fail.

class TestSokoban < Test::Unit::TestCase
  def setup
    $board = [
      ['#', '#', '#', '#'],
      ['#', '@', ' ', '#'],
      ['#', 'o', '.', '#'],
      ['#', '#', '#', '#']
    ]
  end

  def test_get_and_set_char
    assert_equal('@', get_char([1, 1]))
    assert_equal('o', get_char([2, 1]))
    set_char([1, 1], 'X')
    assert_equal('X', get_char([1, 1]))
  end

  def test_get_loc
    assert_equal([1, 1], get_loc)
  end

  def test_can_move
    assert_equal(true, can_move([2, 1], [3, 1])) # To empty
    assert_equal(false, can_move([0, 1], [-1, 1])) # To wall

    # Make space for box to move
    $board[1][3] = ' '
    assert_equal(true, can_move([2, 1], [3, 1])) # Box to empty
  end

  def test_move_player
    move([1, 0])
    assert_equal('@', get_char([1, 2]))
    assert_equal(' ', get_char([1, 1]))
  end

  def test_move_box
    $board[1][3] = ' '
    move([0, 1])
    assert_equal('@', get_char([2, 1]))
    assert_equal('o', get_char([3, 1]))
  end

  def test_win_check
    assert_equal(false, win_check)

    # Put box on goal
    $board[2][1] = '*'
    assert_equal(true, win_check)
  end
end
