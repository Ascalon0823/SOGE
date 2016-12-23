# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.
require_relative 'attribute.rb'
require_relative 'field.rb'

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
  
  
  def self.saveField
    
    if(Field.empty?)
      return "No fields are saved since the hash list is empty"
    else
      f = File.open("world_descripter/fields.wd","w")
      count=0
      Field.getList.each { |name,field|
          count+=1
          line = "%s " % [name]
          field.detail.each{|attr|
            line+="%s " % [attr]
          }
          line+="\n"
          f.write(line)
      }
      f.close
      return "%s fields saved" % [count]
    end
  end
  
  def self.loadField
    Field.clearList
    if(Attribute.empty?)
      self.loadAttr
    end
    Field.init
    f = File.open("world_descripter/fields.wd","r")
    count = 0
    f.each_line do |line|
        details = line.split
        name = details[0]
        args = details.slice(1, details.size-1)
        Field.new(name,args)
        count+=1
    end
    f.close
    return "%s fields loaded" % [count]
  end
  
  def self.dispFields
    return Field.print
  end
  
   def self.add_Field(name,args)
    self.loadField
    Field.new(name, args)
    self.saveField
  end
  
  def self.del_Field(name)
    self.loadField
    Field.remove(name)
    self.saveField
  end
  
end