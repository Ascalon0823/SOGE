# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.

class Formula
  @@formulas = Hash.new
  def self.init
    @@formulas.clear
        f = File.open("world_descripter/formulas.wd","r")
        f.each_line do |line|
            details = line.split
            @@formulas[details.shift] = details
        end
        f.close
  end
  
  def self.calculate(object,attr) #The attrs required for calculate attr must be a subset of attrs of object`s type 
        calculation = @@formulas[attr]
        operands= calculation.values_at(* calculation.each_index.select { |i| i.even?  })
        elements= calculation.values_at(* calculation.each_index.select { |i| i.odd?  })
        result = 0
        operands.each_with_index { |operand,index| 
            element = elements[index]
            element = Integer(element) rescue element
            if(element.is_a? String)
                element = Integer(object.getAttr(element))
            end
            result = operate(result,operand,element)#Dangerous Implementation!
        }
        return result
    end
    

    def self.operate(result,operand,element)
        case operand
        when "P"
            result = result + element
        when "T"
            result = result * element
        when "D"
            result = result / element
        when "M"
            result = result - element
        else
        end
    end
end