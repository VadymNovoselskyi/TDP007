require 'rexml/document'
require 'rexml/streamlistener'

class MyListener
    include REXML::StreamListener

    def initialize
        # Stores names and prices.
        @unit_price = {}
        # Stores the path to current locations.
        @stack = []
        # Stores the unit name and is used to update its price.
        @unit = ""
    end

    def tag_start(tagname, attrs)
        # Adds the unit names in the hash.
        if tagname == "entryLink" && @stack == ["catalogue", "entryLinks"] && !attrs.key?('hidden')
            @unit_price[attrs["name"]] = nil # Temporary set to nil, used later to check if every unit has a price.
        end
        # Stores the unit names to get thier price.
        if tagname == "selectionEntry" && @stack == ["catalogue", "sharedSelectionEntries"] && @unit_price.key?(attrs["name"])
            @unit = attrs["name"]
        end
        # Stores the unit price for the correct unit.
        if tagname == "cost" && attrs["name"] == "pts" && @unit != "" && @stack == ["catalogue", "sharedSelectionEntries", "selectionEntry", "costs"]
            @unit_price[@unit] = attrs["value"].to_i
            @unit = ""
        end
        @stack.push(tagname)
    end

    def tag_end(tagname)
        @stack.pop()
    end
    
    # Help function to check if the info is correct.
    def get_unit_info()
      return @unit_price
    end

    def print_unit_price()
        @unit_price.each do |k, v|
            puts("Unit: #{k} \nValue: #{v}")
        end
    end
end

def main()
    listener = MyListener.new
    src = File.new("Imperium-Imperial-Knights_Library.xml")
    REXML::Document.parse_stream(src, listener)
    listener.print_unit_price()
end

if __FILE__ == $0
    main()
end
