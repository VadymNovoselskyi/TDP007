# Gets the text inside the pre tags from the selected file.
# Returns a string with all the text between the pre tags.
def getTextFromTag(filename)
    fileData = File.read(filename)
    #pattern = /(?<=<pre>)(.|\n)*?(?=<\/pre>)/ #get text inside <pre> holders
    pattern = /<pre>\n(.*?)<\/pre>/m
    text = pattern.match(fileData)
    return text[1]
end

# Help function used to get the specific information needed.
# Gets a specific regex pattern from the call function.
def getTextFromPattern(text, pattern)
    result = text.scan(pattern)
    return result
end

# Help functions to get specific information.
# Gets the team names.
# https://ruby-doc.org/3.4.1/Array.html#method-i-flatten
def getTeams(text)
    teamNamePattern = /\d+\.+\s+([A-Za-z_]+)/
    #puts the names in the same list instead of creatign a 2d array
    teams = getTextFromPattern(text, teamNamePattern).flatten
    return teams
end
# Gets the numbers A and F for each team.
# https://ruby-doc.org/3.4.1/Array.html
def getTeamNumbers(text)
    numbersPattern = /(\d*)\s+-\s (\d*)/m
    # Transforms the numbers from string to int.
    numbers = getTextFromPattern(text, numbersPattern).map {|row| row.map {|num| num.to_i}}
    return numbers
end
# Parses text into a list: [teamname F (goals made), A (goals let in)].
def getTeamInfo(text)
    teams = getTeams(text)
    numbers = getTeamNumbers(text)
    # Assumens that teams and numbers have the same list-lenght.
    info = teams.each_with_index.map do |teamName, i| 
        [teamName] + numbers[i]
    end
    return info
end
# Sorts the teams by difference of F and A.
def sortByDifference(teams)
    sorted = teams.sort_by {|data| (data[1] - data[2]).abs}
    return sorted
end
#--- part 2 ---
# Methods for weather.
def getWeatherInfo(text)
    weatherPattern = /^\s*(\d+)\s+(\d+)\*?\s+(\d+)/ 
    data = getTextFromPattern(text, weatherPattern).map {|row| row.map {|num| num.to_i}}
    return data
end
def main()
    # Footbal information.
    footballText = getTextFromTag("football.txt")
    teamsData = getTeamInfo(footballText)
    teams = sortByDifference(teamsData)
    # Gets the name of the team which has the least difference between F and A.
    teamResult = teams[0][0]
    puts "The team with the least score-difference is: #{teamResult}."
    puts"\n "
    
    # Weather information.
    weatherText = getTextFromTag("weather.txt")
    weatherData = getWeatherInfo(weatherText)
    weather = sortByDifference(weatherData)

    # Gets the day with the least temperature difference.
    mostStableDay = weather[0][0]
    puts "The day with the least temperature difference is day: #{mostStableDay}."
end

if __FILE__ == $0
    main()
end
