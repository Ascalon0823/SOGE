# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.

require_relative "agent.rb"
require_relative "field.rb"
require_relative "formula.rb"

class Battle
  
  def initialize(field,teams)
    x = Integer(field.getAttr("Size_x"))
    y = Integer(field.getAttr("Size_y"))
    @battlefield = Hash.new()
    x_coord = 0
    y_coord = 0
    x.times do
      y.times do
        @battlefield[[x_coord,y_coord]] = 'E' #Initialize a empty field
        y_coord+=1
      end
      x_coord+=1
    end
    BattleAgent.init
    Formula.init
    teams.each_index { |x|
      teams[x].each { |agent|
        BattleAgent.new(agent,x)
      }
    }
    BattleAgent.print
  end
  
  class BattleAgent
    @@ha_battle_agents = Hash.new()
    @@ha_battle_agent_attrs = Hash.new()
    
    def self.init
      @@ha_battle_agents.clear
      @@ha_battle_agent_attrs.clear
      if(Attribute.empty?)
        Engine.loadAttr
      end
      Attribute.getList.each{|key,attr|
        if(attr.getType=="BattleAgent")
          @@ha_battle_agent_attrs[key]=attr.getValue
        end
      }
    end
    
    def initialize(agent,team)
      @ha_attrs = Hash.new
      @@ha_battle_agent_attrs.each{|key,value|
        @ha_attrs[key]=value
      }
      @name = agent.name
      @ha_attrs.each{|key,value|
        @ha_attrs[key]=Formula.calculate(agent,key) rescue value
      }
      @@ha_battle_agents[@name]=self
      @ha_attrs["Team"] = team
    end
    def self.print
     @@ha_battle_agents.each{|name,agent|
        puts "%s" % [name] + "\n" + agent.inspect + "\n"
      }
    end
  end
end