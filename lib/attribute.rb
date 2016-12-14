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
end