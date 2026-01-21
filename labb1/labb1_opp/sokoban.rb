# Reads file and creates array of arrays of chars from file
def make_board(filename)
  File.open filename do |f|
    f.each do |line|
      l = []
      line.each_char do |char|
        l << char
      end
      $board << l
    end
  end
  $board
end

# Prints board
def display_board
  for line in $board do
    for char in line do
      print char
    end
  end
end

# Returns location of player object
def get_loc
  y = 0
  for line in $board do
    x = 0
    for char in line do
      return [x, y] if ['@', '+'].include?(char)

      x += 1
    end
    y += 1
  end
end

# Returns char on certain coordinates
def get_char((x, y))
  $board[y][x]
end

# Replaces char with new one at coordinates
def set_char((x, y), char)
  $board[y][x] = char
end

# Checks if its posible to move, both player and box
def can_move(new_loc, next_loc)
  char = get_char(new_loc)
  return false if char == '#'

  return true if [' ', '.'].include?(char)

  if ['o', '*'].include?(get_char(new_loc))
    next_char = get_char(next_loc)

    return true if [' ', '.'].include?(next_char)
  end

  false
end

# Moves a box. Called from move_player
def move_box(_new_loc, next_loc)
  if get_char(next_loc) == '.'
    set_char(next_loc, '*')
  elsif get_char(next_loc) == ' '
    set_char(next_loc, 'o')
  end
end

# Moves the player object and leaves correct char behind. Calls move_box
def move_player(loc, new_loc, next_loc, _player, after_char)
  next_char = get_char(new_loc)

  if next_char == '.'
    set_char(loc, after_char)
    set_char(new_loc, '+')

  elsif next_char == 'o'
    move_box(new_loc, next_loc)
    set_char(loc, after_char)
    set_char(new_loc, '@')

  elsif next_char == '*'
    move_box(new_loc, next_loc)
    set_char(loc, after_char)
    set_char(new_loc, '+')

  else # next_char == " "
    set_char(loc, after_char)
    set_char(new_loc, '@')
  end
end

# Calls can_move for check and initiates move
def move(dir)
  loc = get_loc
  new_loc = [dir[0] + loc[0], dir[1] + loc[1]]
  next_loc = [dir[0] + new_loc[0], dir[1] + new_loc[1]]

  return unless can_move(new_loc, next_loc)

  player = get_char(loc)
  after_char = if player == '+'
                 '.'
               else # if player == "@"
                 ' '
               end

  move_player(loc, new_loc, next_loc, player, after_char)
end

# Checks if the game is completed
def win_check
  for line in $board do
    for char in line do
      return false if char == 'o'
    end
  end
  puts
  puts 'VICTORY!!'
  true
end

# Function gotten from stackoverflow: https://stackoverflow.com/a/14527475
# Gets a character without pressing enter
def get_input
  state = `stty -g`
  `stty raw -echo -icanon isig`

  STDIN.getc.chr
ensure
  `stty #{state}`
end

if __FILE__ == $0
  # Prepairs game: clears terminal and creates the board
  system('clear')
  $board = []
  make_board('level1.txt')
  display_board

  # Gameloop
  until win_check
    input = get_input
    case input.chomp
    when 'w'
      dir = [0, -1]
      move(dir)
    when 'a'
      dir = [-1, 0]
      move(dir)
    when 's'
      dir = [0, 1]
      move(dir)
    when 'd'
      dir = [1, 0]
      move(dir)
    end
    system('clear')
    display_board
  end
end
