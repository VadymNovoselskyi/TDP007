class Person
    def initialize(car, code, experience, gender, age)
        @car = car.downcase()
        @code = code
        @experience = experience
        @gender = gender.downcase()
        @age = age
        @points = 0
    end
    def evaluate_policy(filename)
        self.instance_eval(File.read(filename))

        if (@gender == "m" && @experience < 3)
            @points *= 0.9
        end

        if(@car == "volvo" && @code.start_with?("58"))
            @points *= 1.2
        end

        return @points
    end

    def method_missing(name, *args)
        attr, val = name.to_s.split("_", 2)
        # puts "attr: #{attr}, args: #{args}, val #{val}"

        if(val.include?("_"))
            handle_range(attr, val, args[0])
            return
        end
        attr_value = instance_eval("@#{attr}")
        if (attr_value == val.downcase()) 
            @points += args[0]
        end
    end

    def handle_range(attr, str_range, points)
        # puts "attr: #{attr}, str_range: #{str_range}, points #{points}"
        start, finish = str_range.split("_").map(&:to_i)
        attr_value = instance_eval("@#{attr}")

        if (start <= attr_value && finish >= attr_value) 
            @points += points
        end
    end

end

kalle=Person.new("Volvo","58435",2,"M",32)
puts kalle.evaluate_policy("policy.rb")
