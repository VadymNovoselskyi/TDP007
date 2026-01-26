require 'rexml/streamlistener'
require 'rexml/document'

file = File.new("Imperium-Imperial-Knights_Library.xml")

$units = Hash.new()

class MyListener
    include REXML::StreamListener
    def initialize()
        @path = []
        @current_unit = ""
    end

    def tag_start(name, attrs)
        @path.append(name)
        
        if (@path == ["catalogue", "entryLinks", "entryLink"])
            handle_entryLink(name, attrs)
        end

        if (@path == ["catalogue", "sharedSelectionEntries", "selectionEntry"])
            @current_unit = attrs["name"] 
        end

        if (@path == ["catalogue", "sharedSelectionEntries", "selectionEntry", "costs", "cost"]) 
            handle_cost(name, attrs) 
        end
    end

    def handle_entryLink(name, attrs) 
        
        if (attrs.has_key?("hidden"))
            return
        end
        $units[attrs["name"]] = 0
    end

    def handle_cost(name, attrs)
        if (attrs["name"] != "pts")
            return
        end
        $units[@current_unit] = attrs["value"]
    end

    def tag_end(name)
        @path.pop()
    end
end

listener = MyListener.new

REXML::Document.parse_stream(file, listener)

#puts $units
file = File.new("Imperium-Imperial-Knights_Library.xml")

dom = REXML::Document.new (file)

units2 = Hash.new()

dom.elements.each("/catalogue/entryLinks/entryLink[not(@hidden)]") { | item | units2[item.attributes.get_attribute("name").value] = 0 }

dom.elements.each("/catalogue/sharedSelectionEntries/selectionEntry") do | entry |
    unit_name = entry.attributes.get_attribute("name").value
    entry.elements.each("costs/cost[@name='pts']") {| item | units2[unit_name] = item.attributes.get_attribute("value").value}
    
end

puts units2