require 'io/console'


class Level 
  def initialize()
    @map = [[]]
    @player_x = 0
    @player_y = 0
    load_map("sokoban_levels.txt")
  end

  def load_map(filename)
    file = File.new(filename)
    y_index = 0
    file.read().each_char do | char | 
      if (char == "\n") 
        y_index += 1
        @map.push([])
        next 
      end
      if (char == "@")
        @player_x = @map[y_index].length
        @player_y = y_index
      end
      @map[y_index].append(char)
    end
  end

  def print_map() 
    for row in @map do
      for char in row do
        print(char)
      end
      puts
    end
  end

  def get_object(x, y)
    return @map[y][x]
  end

  def set_object(x, y, icon)
    @map[y][x] = icon
  end


  def move_player(dx, dy)
    target_x = @player_x + dx
    target_y = @player_y + dy
    object = get_object(target_x, target_y)

    if (object == "#") 
      return
    end
    if (object == "o" || object == "*") 
      moved_box = move_box(target_x, target_y, dx, dy)
      if (!moved_box)
        return
      end

      object = get_object(target_x, target_y)
    end
    
    current_player_icon = get_object(@player_x, @player_y)
    set_object(@player_x, @player_y, current_player_icon == "+" ? "." : " ")
    set_object(target_x, target_y, object == "." ? "+" : "@")

    @player_x += dx
    @player_y += dy
  end

  def move_box(x, y, dx, dy)
    object = get_object(x + dx, y + dy)
    if (object == "#" || object == "o") 
      return false
    end

    current_box_icon = get_object(x, y)
    set_object(x, y, current_box_icon == "*" ? "." : " ")
    set_object(x + dx, y + dy, object == "." ? "*" : "o")
    return true
  end

  def is_complete()
    for row in @map do
      for char in row do
        if (char == "o")
          return false
        end
      end
    end
    return true
  end

end


# Taken from:
# https://stackoverflow.com/a/14527475
def get_char
  state = `stty -g`
  `stty raw -echo -icanon isig`
  
  STDIN.getc.chr
ensure
  `stty #{state}`
end

if __FILE__ == $0
  main()
end

def main()
  level = Level.new()

  while !level.is_complete()
    system("clear")
    level.print_map()

    puts("\n\nDo your move (wasd): ")
    input = get_char()

    case input.chomp
    when "w" then level.move_player(0, -1)
    when "a" then level.move_player(-1, 0)
    when "s" then level.move_player(0, 1)
    when "d" then level.move_player(1, 0)
    end
  end
  level.print_map()

end