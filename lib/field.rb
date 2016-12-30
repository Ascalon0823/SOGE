# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.
require_relative "attribute.rb"
require_relative "engine.rb"
class Field
  
  @@ha_field_attrs =Hash.new
  @@ha_fields = Hash.new
  
  def self.init
    @@ha_field_attrs.clear
    @@ha_fields.clear
    if(Attribute.empty?)
      Engine.loadAttr
    end
    Attribute.getList.each{|key,attr|
      if(attr.getType=="Field")
        @@ha_field_attrs[key]=attr.getValue
      end
    }
  end
  
  def self.num_attr
    Field.init
    return @@ha_field_attrs.size
  end
  def self.attributes
    return @@ha_field_attrs
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
    @@ha_fields.delete(name)
  end
  
  def self.find(name)
    return @@ha_fields[name]
  end
  
  
  def self.save
    
    if(self.empty?)
      return "No fields are saved since the hash list is empty"
    else
      f = File.open("world_descripter/fields.wd","w")
      count=0
      self.getList.each { |name,field|
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
  
  def self.forceSave
    f = File.open("world_descripter/fields.wd","w")
    count=0
    self.getList.each { |name,field|
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
  
  def self.load
    self.clearList
    if(Attribute.empty?)
      Attribute.load
    end
    self.init
    f = File.open("world_descripter/fields.wd","r")
    count = 0
    f.each_line do |line|
        details = line.split
        name = details[0]
        args = details.slice(1, details.size-1)
        self.new(name,args)
        count+=1
    end
    f.close
    return "%s fields loaded" % [count]
  end
  def self.disp
    return self.print
  end
end