# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.

class Utility
  def self.msg(array)
    message = ""
    array.each do |text|
      message += text + "\n" 
    end
    return message
  end
end