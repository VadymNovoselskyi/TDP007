#!/usr/bin/env ruby
require 'logger'

# ----------------------------------------------------------------------------
#  Bidirectional constraint network for arithmetic constraints
# ----------------------------------------------------------------------------

# In the example above, our constraint network was unidirectional.
# That is, changes could not propagate from the output wire to the
# input wires. However, to model equation systems such as the
# correlation betwen the two units of measurement Celsius and
# Fahrenheit, we need to propagate changes from either end to the
# other.

module PrettyPrint

  # To make printouts of connector objects easier, we define the
  # inspect method so that it returns the value of to_s. This method
  # is used by Ruby when we display objects in irb. By defining this
  # method in a module, we can include it in several classes that are
  # not related by inheritance.

  def inspect
    "#<#{self.class}: #{to_s}>"
  end

end

# This is the base class for Adder and Multiplier.

class ArithmeticConstraint

  include PrettyPrint

  attr_accessor :a,:b,:out
  attr_reader :logger,:op,:inverse_op

  def initialize(a, b, out, log_level=Logger::DEBUG)
    @logger=Logger.new(STDOUT)
    @logger.level = log_level
    @a,@b,@out=[a,b,out]
    [a,b,out].each { |x| x.add_constraint(self) }
  end
  
  def to_s
    "#{a} #{op} #{b} == #{out}"
  end
  
  def new_value(connector)
    @logger.debug("[ArithmeticConstraint:new_value] connector: #{connector}")
    if [a,b].include?(connector) and a.has_value? and b.has_value? and (not out.has_value?) then 
      # Inputs changed, so update output to be the sum of the inputs
      # "send" means that we send a message, op in this case, to an
      # object.
      @logger.debug("[ArithmeticConstraint:new_value] #{self} : inputs have value; output doesn't")
      val=a.value.send(op, b.value)
      @logger.debug("[ArithmeticConstraint:new_value] #{self} : #{out} updated")
      out.assign(val, self)
      
    elsif ![a,b].include?(connector) && !(a.has_value? && b.has_value?) && out.has_value? then 
      # Inputs changed, so update output to be the sum of the inputs
      # "send" means that we send a message, op in this case, to an
      # object.
      @logger.debug("[ArithmeticConstraint:new_value] #{self} : an input doesn't have value; output does")

      if a.has_value? then
        val=out.value.send(inverse_op, a.value)
        @logger.debug("[ArithmeticConstraint:new_value] #{self} : #{b} updated")
        b.assign(val, self)
      else b.has_value?
        val=out.value.send(inverse_op, b.value)
        @logger.debug("[ArithmeticConstraint:new_value] #{self} : #{a} updated")
        a.assign(val, self)
      end
    end
    self
  end
  
  # A connector lost its value, so propagate this information to all
  # others
  def lost_value(connector)
    ([a,b,out]-[connector]).each { |connector| connector.forget_value(self) }
  end
  
end

class Adder < ArithmeticConstraint
  
  def initialize(*args)
    super(*args)
    @op,@inverse_op=[:+,:-]
  end
end

class Multiplier < ArithmeticConstraint

  def initialize(*args)
    super(*args)
    @op,@inverse_op=[:*,:/]
  end
end

class ContradictionException < Exception
end

# This is the bidirectional connector which may be part of a constraint network.

class Connector
    
  include PrettyPrint

  attr_accessor :name,:value

  def initialize(name, value=false, log_level=Logger::DEBUG)
    self.name=name
    @has_value=(not value.eql?(false))
    @value=value
    @informant=false
    @constraints=[]
    @logger=Logger.new(STDOUT)
    @logger.level = log_level
  end

  def add_constraint(c)
    @constraints << c
  end
    
  # Values may not be set if the connector already has a value, unless
  # the old value is retracted.
  def forget_value(retractor)
    if @informant==retractor then
      @has_value=false
      @value=false
      @informant=false
      @logger.debug("[Connector:forget_value] #{self} lost value")
      others=(@constraints-[retractor])
      @logger.debug("[Connector:forget_value] Notifying #{others}") unless others == []
      others.each { |c| c.lost_value(self) }
      "ok"
    else
      @logger.debug("[Connector:forget_value] #{self} ignored request to forget from #{retractor}")
    end
  end

  def has_value?
    @has_value
  end
  
  # The user may use this procedure to set values
  def user_assign(value)
    forget_value("user")
    assign value,"user"
  end
  
  def assign(v,setter)
      if not has_value? then
        @logger.debug("[Connector:assign] #{name} got new value: #{v} from #{setter}")
        @value=v
        @has_value=true
        @informant=setter
        (@constraints-[setter]).each { |c| c.new_value(self) }
        "ok"
      else
        if value != v then
          raise ContradictionException.new("#{name} already has value #{value}.\nCannot assign #{name} to #{v}")
      end
    end
  end
  
  def to_s
    name
  end

end

class ConstantConnector < Connector
  
  def initialize(name, value, log_level = Logger::DEBUG)
    super(name, value, log_level)
    if not has_value?
      @logger.warn "Constant #{name} has no value!"
    end
  end
  
  def value=(val)
    raise ContradictionException.new("Cannot assign a constant a value!")
  end
end
  
# This is a simple test of the constraint network

def test_adder
  a = Connector.new("a")
  b = Connector.new("b")
  c = Connector.new("c")
  Adder.new(a, b, c)
  a.user_assign(10)
  b.user_assign(5)
  @logger.debug("c = "+c.value.to_s)
  a.forget_value "user"
  c.user_assign(20)
  # a should now be 15
  @logger.debug("a = "+a.value.to_s)
end

# ----------------------------------------------------------------------------
#  Assignment
# ----------------------------------------------------------------------------

# Uppgift 1 inf�r fj�rde seminariet inneb�r tv� saker:
# - F�rst ska ni skriva enhetstester f�r Adder och Multiplier. Det �r inte
#   helt s�kert att de funkar som de ska. Om ni med era tester uppt�cker
#   fel ska ni dessutom korrigera Adder och Multiplier.
# - Med hj�lp av Adder och Multiplier m.m. ska ni sedan bygga ett n�tverk som
#   kan omvandla temperaturer mellan Celsius och Fahrenheit. (Om ni vill
#   f�r ni ta en annan ekvation som �r ungef�r lika komplicerad.)

# Ett tips �r att skapa en funktion celsius2fahrenheit som returnerar
# tv� Connectors. Dessa tv� motsvarar Celsius respektive Fahrenheit och 
# kan anv�ndas f�r att mata in temperatur i den ena eller andra skalan.

def celsius2fahrenheit(log_level=Logger::DEBUG)
  value_5 = ConstantConnector.new("5", 5, log_level)
  value_9 = ConstantConnector.new("9", 9, log_level)
  value_minus32 = ConstantConnector.new("-32", -32, log_level)

  celsius = Connector.new("celsius", false, log_level)
  celsius_x9 = Connector.new("celsius*9", false, log_level)
  Multiplier.new(celsius, value_9, celsius_x9, log_level)
  
  farenheit = Connector.new("farenheit", false, log_level)
  farenheit_minus32 = Connector.new("farenheit-32", false, log_level)
  Adder.new(farenheit, value_minus32, farenheit_minus32, log_level)
  
  Multiplier.new(farenheit_minus32, value_5, celsius_x9, log_level)
  return [celsius, farenheit]
end

def test_celsius2fahrenheit(log_level=Logger::DEBUG)
  c,f = celsius2fahrenheit(log_level)

  c.user_assign(100)
  puts f.value
  
  # f.user_assign(212)
  # puts c.value
end

if __FILE__ == $0 then
  test_celsius2fahrenheit()
end
