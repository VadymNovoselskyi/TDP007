require './new-rdparse.rb'
class Calc

  def initialize
    @calcParser = Parser.new("calculator") do
      memory = {}
      # Ignore whitespace
      token(/\s+/)
      # Strings tokenized as strings
      token(/\btrue\b/) { "true" }
      token(/\bfalse\b/) { "false" }
      token(/\(/) { "(" }
      token(/\)/) { ")" }
      token(/\band\b/) { "and" }
      token(/\bor\b/) { "or" }
      token(/\bnot\b/) { "not" }
      token(/\bset\b/) { "set" }
      token(/[a-z_@$][a-zA-Z_]*\w*\b/) { |t| t }
      
      start :VALID do
        match(:ASSIGN) { |a| a }
        match(:EXPR)  { |e| e }
      end

      rule :ASSIGN do
        match('(', 'set', :VAR, :EXPR, ')') { |_,_,v, e,_| memory[v] = e }
      end

      rule :EXPR do
        match('(', 'or', :EXPR, :EXPR, ')') { |_,_,e1,e2,_| e1 or e2 }
        match('(', 'and', :EXPR, :EXPR, ')') { |_,_,e1,e2,_| e1 and e2 }
        match('(', 'not', :EXPR, ')') { |_,_,e,_| not e }
        match(:TERM) { |t| t }
      end

      #ruby-doc.org/core-3.1.0/Hash.html
      rule :TERM do
        match(:VAR) do |v|
          if v == "true"
            true
          elsif v == "false"
            false
          else
            memory.fetch(v)
          end
        end
      end
      
      rule :VAR do
        match(/[a-z_@$][a-zA-Z_]*\w*\b/) { |v| v } # Returnerar variabelnamnet
      end
    end
  end
  
  def done(str)
    ["quit", "exit", "bye", "done", ""].include?(str.chomp)
  end

  # Only for unit testing
  def calcParse(str)
    return @calcParser.parse(str)
  end
  
  # Read input with history
  require "readline"

  def interact
    # Read input with history
    str = Readline.readline('> ', true)
    if done(str) then
      puts "Bye!"
    else
      # Use exception handling
      begin
        result = @calcParser.parse(str)
        puts "=> #{result}"
      rescue => e
        puts "Error: #{e.message}"
      end
      interact
    end
  end
end

if __FILE__ == $0
  calc = Calc.new
  calc.interact
end
