def get_lowest(data, &transform_fn)
    val = data.min() { | a, b | transform_fn.call(a) <=> transform_fn.call(b) }
    return val
end

def sort_by(data, &transform_fn)
    sorted = data.sort() { | a, b | transform_fn.call(b) <=> transform_fn.call(a) }
    return sorted
end

def get_football_hash(filename = "football.txt")
    file = File.new(filename)
    text = file.read()
    content = text.split("<pre>")[1]

    hash = Hash.new()
    content.split("\n").each do | line | 
        entries =  line.split(/\W+/)
        if (entries.length != 10) 
            puts "Failed to parse the line: ", line
            next
        end
            
        hash[entries[2]] = entries[3..-1].collect { |e| e.to_i}
    end

    return hash
end
    
def get_lowest_football_team(hash)
    return get_lowest(hash) { | a | (a[1][4]- a[1][5]).abs() }
end

def sort_by_goals(hash)
    sorted = sort_by(hash) { | a |  a[1][4]- a[1][5] }
    puts "Teams sorted by goal diff: "
    sorted.each { | entry | print entry[0] + "; diff: " + (entry[1][4] - entry[1][5]).to_s + "\n" }
end

def get_weather_data(filename = "weather.txt")
    file = File.new(filename)
    text = file.read()
    content = text.split("<pre>")[1]

    data = []
    content.split("\n").each do | line | 
        entry = []
        if (line.length < 84 || !(line[2..5].match(/\d/))) 
            next 
        end
        entry << line[2..5].gsub(/\s/, "")
        entry << line[6..11].gsub(/\s/, "").to_i()
        entry << line[12..17].gsub(/\s/, "").to_i()
        entry << line[18..25].gsub(/\s/, "")
        entry << line[26..29].gsub(/\s/, "")
        entry << line[30..40].gsub(/\s/, "")
        entry << line[41..45].gsub(/\s/, "")
        entry << line[46..53].gsub(/\s/, "")
        entry << line[54..57].gsub(/\s/, "")
        entry << line[58..62].gsub(/\s/, "")
        entry << line[63..67].gsub(/\s/, "")
        entry << line[68..70].gsub(/\s/, "")
        entry << line[71..75].gsub(/\s/, "")
        entry << line[76..79].gsub(/\s/, "")
        entry << line[80..82].gsub(/\s/, "")
        entry << line[83..-1].gsub(/\s/, "")

        # print(entry, "\n")
        data << entry            
    end

    return data
end

def get_lowest_temp_diff(data)
    return get_lowest(data) { | a | a[1]- a[2] }
end

def sort_by_temp_diff(data)
    sorted = sort_by(data) { | a | a[1]- a[2] }
    puts "Days sorted by min-max temp diff: "
    sorted.each { | entry | print entry[0] + "; diff: " + (entry[1]- entry[2]).to_s + "\n" }
end


if __FILE__ == $0
  hash = get_football_hash()
  lowest_team = get_lowest_football_team(hash)
  puts "The team with the lowest diff is:", lowest_team[0]
  sort_by_goals(hash)
  data = get_weather_data()
  lowest_diff = get_lowest_temp_diff(data)
  print "The day with the lowest temp diif is: ", lowest_diff[0], "\n"
  sort_by_temp_diff(data)
end