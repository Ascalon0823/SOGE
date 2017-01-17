# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.
require_relative 'attribute.rb'
require_relative 'field.rb'
require_relative 'agent.rb'
require_relative 'battle.rb'
require_relative  'formula.rb'

class Engine

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
  
  def self.test_creation
    Field.init
    Field.load
    field= Field.find("TestField")

    Agent.init
    Agent.load
    teams = [[Agent.find("TestGuy")],[Agent.find("TestGuyB")]]
    Battle.new(field,teams)
  end
end