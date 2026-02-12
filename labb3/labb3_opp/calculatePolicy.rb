#todo säkra inför felanvänding?
class Person
    def initialize(car, zip, li, sex, age)
        # Ensure car is stored as a lowercase string for consistent comparisons later
        @car = car.to_s.downcase
        # Keep zipCode as a string so we can easily check the starting digits
        @zipCode = zip.to_s 
        @licenceLifeTime = li
        @sex = sex
        @age = age

        @points = 0
    end
    # Used to calculate the points for the special cases 
    def calculatePoints()
        #rules for male and having a license undr 3 years
        if @sex == "M" && @licenceLifeTime < 3
            @points = @points * 0.9
        end
        #rules for zipcodes starting with 58 and owning a volvo
        if @zipCode.start_with?("58") && @car== "volvo"
            @points = @points * 1.2
        end
    end
    # Method is used to check that the arguments are correct by checking the lenght and information
    def validateArgs(args, currentValue)
        if args.length != 2
            puts "Warning: Wrong number of parameters"
            return
        end
        #checks for correct score 
        uppdatePoints(args, currentValue)
    end
    def uppdatePoints(args, currentValue)
        expectedValue, points = args
        addPoints(points) if matchValues(currentValue, expectedValue)
    end

    # Help function to check for correct values
    def matchValues(value, expectedData)
        #used to check age and license life time score
        #https://docs.ruby-lang.org/en/3.1/Range.html === used to check if a value exist between two numbers, works with both ints and floats
        if expectedData.is_a?(Range) 
            expectedData === value.to_f
        #used to check car brands and zip code
        elsif expectedData.is_a?(String)
            expectedData.to_s.downcase == value.to_s.downcase
        end
    end

    #help function to add score
    def addPoints(points)
        @points += points
    end
    #help function to test points
    def getPoints()
        @points
    end

    def evaluatePolicy(file)
        @points = 0 #resets points
        instance_eval(File.read(file))
        calculatePoints()
        return @points
    end

    def car(*args)
        validateArgs(args, @car)
    end

    def zipCode(*args)
        validateArgs(args, @zipCode)
    end

    def licenceLifeTime(*args)
        validateArgs(args, @licenceLifeTime)
    end

    def sex(*args)
        validateArgs(args, @sex)
    end

    def age(*args)
       validateArgs(args, @age)
    end
end

# car,zipcode,licenselifetime, sex, age
if __FILE__ == $0
    kalle=Person.new("Volvo","58435",2,"M",32)
    puts "kalles points: #{kalle.evaluatePolicy("policy.rb")}"
    puts  kalle
end
