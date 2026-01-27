require 'rexml/streamlistener'
require 'rexml/document'

class MyListener
    include REXML::StreamListener
    def initialize()
        @path = []
        @current_unit = ""
    end

    def tag_start(name, attrs)
        @path.append(name)
        
        if (@path == ["catalogue", "entryLinks", "entryLink"])
            handle_entryLink(attrs)
        end

        if (@path == ["catalogue", "sharedSelectionEntries", "selectionEntry"])
            @current_unit = attrs["name"] 
        end

        if (@path == ["catalogue", "sharedSelectionEntries", "selectionEntry", "costs", "cost"]) 
            handle_cost(attrs) 
        end
    end

    def handle_entryLink(attrs) 
        
        if (attrs.has_key?("hidden"))
            return
        end
        $units[attrs["name"]] = 0
    end

    def handle_cost(attrs)
        if (attrs["name"] != "pts")
            return
        end
        $units[@current_unit] = attrs["value"]
    end

    def tag_end(name)
        @path.pop()
    end
end

def stream_parser()
    file = File.new("Imperium-Imperial-Knights_Library.xml")
    $units = Hash.new()
    
    listener = MyListener.new()
    REXML::Document.parse_stream(file, listener)
    return $units

end

def dom_parser()
    file = File.new("Imperium-Imperial-Knights_Library.xml")
    
    dom = REXML::Document.new (file)
    
    units = Hash.new()
    
    dom.elements.each("/catalogue/entryLinks/entryLink[not(@hidden)]") { | item | units[item.attributes.get_attribute("name").value] = 0 }
    
    dom.elements.each("/catalogue/sharedSelectionEntries/selectionEntry") do | entry |
        unit_name = entry.attributes.get_attribute("name").value
        entry.elements.each("costs/cost[@name='pts']") {| item | units[unit_name] = item.attributes.get_attribute("value").value}
    end
    return units
end


if __FILE__ == $0
    stream_units = stream_parser()
    puts "Stream parsed units: ", stream_units
    dom_units = dom_parser()
    puts "DOM parsed units: ", dom_units
end