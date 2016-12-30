# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.
require_relative 'attribute.rb'
require_relative 'field.rb'
require_relative 'agent.rb'

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
  
  def self.del_Attr(name)
    self.loadAttr
    Attribute.remove(name)
    self.saveAttr
  end
  
  def self.loadClass(className)
    Kernel.const_get(className).load
  end
  
  def self.saveClass(className)
    Kernel.const_get(className).save
  end
  
  def self.dispClass(className)
    Kernel.const_get(className).disp
  end
  
  def self.addObject(className,name,args)
    Kernel.const_get(className).load
    obj = Kernel.const_get(className).new(name,args)
    Kernel.const_get(className).save
    return obj
  end
  
  def self.delObject(className,name)
    Kernel.const_get(className).load
    Kernel.const_get(className).remove(name)
    Kernel.const_get(className).forceSave
  end
  
  def self.num_attr(className)
    return Kernel.const_get(className).num_attr
  end
  
  def self.attributes(className)
    return Kernel.const_get(className).attributes
  end
  
  def self.getList(className)
    return Kernel.const_get(className).getList
  end
  
  def self.find(className,name)
    return Kernel.const_get(className).find(name)
  end
end