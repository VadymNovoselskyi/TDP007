require 'rexml/document'

# Checks if the storage is missing a hidden variable by using count, if its 0 then it does not exist.
def getSelectedNames(document)
    names = {}
    document.each_element("/catalogue/entryLinks/*[count(@hidden)=0]") do |entry|
        names[entry.attributes["name"]] = nil
    end
    return names
end
# Finds the price for each unit by going through the name list and searching for its price in xml.
def getUnitsPrice(document, names)


  # Loop through every selectionEntry in the xml file.
  document.elements.each('//selectionEntry') do |entry|
  name = entry.attributes['name']
  next unless names.include?(name)
# Find the <cost> inside <costs> with name="pts".
  entry.elements.each('costs/cost') do |cost|
    if cost.attributes['name'] == 'pts'
      names[name] = cost.attributes['value'].to_i
      end
    end
  end
  return names
end

def printUnits(units)
  units.each do |k, v|
      puts("Unit: #{k}\nValue: #{v.to_i} \n")
  end
end

def main()
    src = File.open("Imperium-Imperial-Knights_Library.xml")
    doc = REXML::Document.new(src)
    names = getSelectedNames(doc.root)
    unitInfo = getUnitsPrice(doc.root, names)
    printUnits(unitInfo)
end

if __FILE__ == $0
    main()
end
