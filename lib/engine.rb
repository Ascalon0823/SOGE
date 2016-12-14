# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.
require_relative 'attribute.rb'

class Engine
  def self.saveAttr
    if(Attribute.empty?)
      return "No attributes saved since the hash list is empty"
    else
      f = File.open("world_descripter/attributes.wd","w")
      count=0
      Attribute.getList.each { |name,attr|
          count+=1
          line = "%s %s %s \n" % [attr.getName,attr.getType,attr.getValue]
          f.write(line)
      }
      f.close
      return "%s attributes saved" % [count]
    end
  end

  def self.loadAttr
    Attribute.clearList
    f = File.open("world_descripter/attributes.wd","r")
    count = 0
    f.each_line do |line|
        details = line.split
        Attribute.new(details[0],details[1],details[2])
        count+=1
    end
    f.close
    return "%s attributes loaded" % [count]
  end
  
  def self.dispAttr
    return Attribute.print
  end
  
  def self.add_Attr(name,type,value)
    self.loadAttr
    Attribute.new(name, type, value)
    self.saveAttr
  end

end