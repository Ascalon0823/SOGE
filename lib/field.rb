# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.
require_relative "attribute.rb"

class Field
  
  @@ha_field_attrs =Hash.new
  @@ha_fields = Hash.new
  
  def self.init
    @@ha_field_attrs.clear
    @@ha_fields.clear
    
    Attribute.getList.each{|key,attr|
      if(attr.getType=="Field")
        @@ha_field_attrs[key]=attr.getValue
      end
    }
  end
  
  def initialize(name,args)
    @ha_attrs = Hash.new
    @@ha_field_attrs.each{|key,value|
      @ha_attrs[key]=value
    }
    @name = name
    keys = @ha_attrs.keys
    args.each_index {|x|
      @ha_attrs[keys[x]]=args[x]
    }
    @@ha_fields[name]=self
  end
  
  def setAttr(attr,value)
    @ha_attrs[attr] = value
  end
  
  def getAttr(attr)
    return @ha_attrs[attr]
  end
  
  def name
    return @name
  end
  
  def rename(newname)
    @name = newname
  end
  
  def self.empty?
    return @@ha_fields.empty?
  end
  
  def self.getList
    return @@ha_fields
  end
  
  def detail
    arr=[]
    @ha_attrs.each{|attr,value|
      arr<<value
    }
    return arr
  end
  
  def self.clearList
    @@ha_fields.clear
  end
  
  def detailText
    line = ""
    line+="%s " % self.name
    @ha_attrs.each{|attr,value|
      line+="%s: %s " % [attr,value]
    }
    line += "\n"
    return line
  end
  
  def self.print
    textBuffer = []
    if(self.empty?)
      textBuffer << "No fields"
    else
      @@ha_fields.each{|name,field|

        text =  field.detailText
        puts text
        textBuffer << text
      }
    end
    return textBuffer
  end
  
  def self.remove(name)
    @@ha_field.delete(name)
  end
end