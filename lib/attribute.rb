# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.

class Attribute
  @@ha_attrs = Hash.new
  
  def initialize(name, type, defValue)
    @name = name
    @type = type
    @defValue = Integer(defValue) rescue defValue
    @@ha_attrs[name]=self
  end
  
  def getName
    @name
  end
  def getType
    @type
  end
  def getValue
    @defValue
  end
  def self.getList
    return @@ha_attrs
  end
  
  def self.print
    textBuffer = []
    if(self.empty?)
      textBuffer << "No attributes"
    else
      @@ha_attrs.each{|key,attr|

        text =  "Attribute name = %s, type = %s, default value = %s" % [attr.getName,attr.getType,attr.getValue]
        puts text
        textBuffer << text
      }
    end
    return textBuffer
  end
  
  def self.find(key)
    return @@ha_attrs[key]
  end
  
  def self.clearList
    @@ha_attrs.clear
  end
  def self.empty?
    return @@ha_attrs.empty?
  end
  
  def detail
    return [@name,@type,@defValue]
  end
  def detailText
    return "Attribute name = %s\ntype = %s\ndefault value = %s\n" % [@name,@type,@defValue]
  end
  
  def self.remove(name)
    @@ha_attrs.delete(name)
  end
  
  def self.save
    if(self.empty?)
      return "No attributes saved since the hash list is empty"
    else
      f = File.open("world_descripter/attributes.wd","w")
      count=0
      self.getList.each { |name,attr|
          count+=1
          line = "%s %s %s \n" % [attr.getName,attr.getType,attr.getValue]
          f.write(line)
      }
      f.close
      return "%s attributes saved" % [count]
    end
  end

  def self.load
    self.clearList
    f = File.open("world_descripter/attributes.wd","r")
    count = 0
    f.each_line do |line|
        details = line.split
        self.new(details[0],details[1],details[2])
        count+=1
    end
    f.close
    return "%s attributes loaded" % [count]
  end
  
  def self.disp
    return self.print
  end
end