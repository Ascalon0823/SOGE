# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.
require 'gtk3'
require_relative 'engine.rb'
require_relative 'utility.rb'

#main window for handling attribute
class Gui < Gtk::Window
  def initialize
    window = Gtk::Window.new("S.O.G.E")
    window.set_size_request(300, 768)
    window.set_border_width(1)
    
    table_main = Gtk::Table.new(5,1,true)
    window.add(table_main)
    b_attr = Gtk::Button.new(:label => "Attributes")
    b_attr.signal_connect "clicked" do |_widget|
      AttributeWindow.new    
    end
    table_main.attach(b_attr,0,1,0,1)
    
    b_field = Gtk::Button.new(:label => "Fields")
    b_field.signal_connect "clicked" do |_widget|
      FieldWindow.new    
    end
    table_main.attach(b_field,0,1,1,2)
    
    b_quit = Gtk::Button.new(:label=>"Quit")
    b_quit.signal_connect "clicked" do |_widget|
      Gtk.main_quit
    end
    table_main.attach(b_quit,0,1,4,5)
    window.signal_connect("delete-event") { |_widget| Gtk.main_quit }
    window.show_all
    Gtk.main
  end
  class AttributeWindow < Gtk::Window
    def initialize
      window = Gtk::Window.new("Attribute")
      window.set_size_request(1366, 768)
      window.set_border_width(1)

      table_attr = Gtk::Table.new(3,5,true)
      window.add(table_attr)
      #Text Field#
      textView = Gtk::TextView.new
      table_attr.attach(textView,0,5,0,2)
      
      b_attrLoad = Gtk::Button.new(:label => "Load Attributes")
      b_attrLoad.signal_connect "clicked" do |_widget|
        textView.buffer.text= "Loading...\n" + Engine.loadAttr    
      end
      table_attr.attach(b_attrLoad,0,1,2,3)
      
      b_attrSave = Gtk::Button.new(:label => "Save Attributes")
      b_attrSave.signal_connect "clicked" do |_widget|
        textView.buffer.text= "Saving...\n" + Engine.saveAttr
      end
      table_attr.attach(b_attrSave,1,2,2,3)
      
      b_attrDisplay = Gtk::Button.new(:label => "Display Attributes")
      b_attrDisplay.signal_connect "clicked" do |_widget|
        textView.buffer.text= "Displaying...\n" + Utility.msg(Engine.dispAttr)
      end
      table_attr.attach(b_attrDisplay,2,3,2,3)
      
      b_attrAdd = Gtk::Button.new(:label => "Add new attributes")
      b_attrAdd.signal_connect "clicked" do |_widget|
        AddAttrWindow.new
      end
      table_attr.attach(b_attrAdd,3,4,2,3)
      
      b_attrDel = Gtk::Button.new(:label => "Delete attributes")
      b_attrDel.signal_connect "clicked" do |_widget|
        DeleteAttrWindow.new
      end
      table_attr.attach(b_attrDel,4,5,2,3) 
      
      window.signal_connect("delete-event") { |_widget| window.hide() }
      window.show_all
    end
  end
  #Sub window to add attribute
  class AddAttrWindow < Gtk::Window
    def initialize
      window = Gtk::Window.new("Add new attribute")
      window.set_size_request(400, 300)
      window.set_border_width(1)

      table_attr_add = Gtk::Table.new(4,3,true)
      window.add(table_attr_add)

      label_entry_name = Gtk::Label.new("Attribute Name")
      entry_name = Gtk::Entry.new
      table_attr_add.attach(entry_name,1,3,0,1)
      table_attr_add.attach(label_entry_name,0,1,0,1)

      label_entry_type = Gtk::Label.new("Attribute Type")
      entry_type = Gtk::Entry.new
      table_attr_add.attach(entry_type,1,3,1,2)
      table_attr_add.attach(label_entry_type,0,1,1,2)

      label_entry_value = Gtk::Label.new("Attribute Default Value")
      entry_value = Gtk::Entry.new
      table_attr_add.attach(entry_value,1,3,2,3)
      table_attr_add.attach(label_entry_value,0,1,2,3)

      b_cancel = Gtk::Button.new(:label => "Cancel")
      table_attr_add.attach(b_cancel,1,2,3,4)
      b_cancel.signal_connect "clicked" do |_widget|
         window.hide()
      end

      b_add = Gtk::Button.new(:label => "Add")
      table_attr_add.attach(b_add,2,3,3,4)
      b_add.signal_connect "clicked" do |_widget|
        name = entry_name.text
        type = entry_type.text
        value = entry_value.text
        if(name==""||type==""||value=="")
          DialogWindow.new("Error","Entry cannot be empty")
        else
          Engine.add_Attr(name,type,value)
          window.hide()
        end
      end
      window.signal_connect("delete-event") { |_widget| window.hide() }
      window.show_all
    end
  end

  #Sub window to delete attribute
  class DeleteAttrWindow < Gtk::Window
    def initialize
      window = Gtk::Window.new("Delete Attribute")
      window.set_size_request(400,300)
      window.set_border_width(1)
      table_attr_del = Gtk::Table.new(2,3,true)
      window.add(table_attr_del)

      Engine.loadAttr
      attrs = Attribute.getList.keys
      cbox_attr = Gtk::ComboBoxText.new
      attrs.each{ |attr|
        cbox_attr.append_text attr
      }
      table_attr_del.attach(cbox_attr, 0,1,0,1)

      text_attr_detail = Gtk::TextView.new
      table_attr_del.attach(text_attr_detail,1,3,0,1)

      b_cancel = Gtk::Button.new(:label => "Cancel")
      b_cancel.signal_connect "clicked" do |_widget|
        window.hide()
      end
      table_attr_del.attach(b_cancel,0,1,1,2)

      b_del = Gtk::Button.new(:label => "Delete")
      b_del.signal_connect "clicked" do |_widget|
        Engine.del_Attr(cbox_attr.active_iter[0])
        window.hide()
        DialogWindow.new("Delete Attribute","%s has been deleted" % [cbox_attr.active_iter[0]])
      end
      table_attr_del.attach(b_del,2,3,1,2)
      b_del.sensitive=false
      cbox_attr.signal_connect "changed" do 
        if(cbox_attr.active_iter[0]!="")
          b_del.sensitive =true
          text_attr_detail.buffer.text = Attribute.find(cbox_attr.active_iter[0]).detailText
        else
          b_del.sensitive=false
        end
      end
      window.signal_connect("delete-event") { |_widget| window.hide() }
      window.show_all
    end
  end
  #Common Dialog window
  class DialogWindow < Gtk::Window
    def initialize(title,message)
      window = Gtk::Window.new(title)
      window.set_size_request(150, 100)
      window.set_border_width(1)
      table_dialog = Gtk::Table.new(2,3,true)
      window.add(table_dialog)
      label_dialog = Gtk::Label.new(message)
      table_dialog.attach(label_dialog,0,3,0,1)

      b_dialog = Gtk::Button.new(:label => "OK")
      table_dialog.attach(b_dialog,1,2,1,2)
      b_dialog.signal_connect "clicked" do |_widget|
        window.hide()
      end

      window.signal_connect("delete-event") { |_widget| window.hide() }
      window.show_all
    end
  end
  class FieldWindow < Gtk::Window
    def initialize
      window = Gtk::Window.new("Field")
      window.set_size_request(1366, 768)
      window.set_border_width(1)

      table_attr = Gtk::Table.new(3,5,true)
      window.add(table_attr)
      #Text Field#
      textView = Gtk::TextView.new
      table_attr.attach(textView,0,5,0,2)

      b_fieldLoad = Gtk::Button.new(:label => "Load Fields")
      b_fieldLoad.signal_connect "clicked" do |_widget|
        textView.buffer.text= "Loading...\n" + Engine.loadField    
      end
      table_attr.attach(b_fieldLoad,0,1,2,3)

      b_fieldSave = Gtk::Button.new(:label => "Save Fields")
      b_fieldSave.signal_connect "clicked" do |_widget|
        textView.buffer.text= "Saving...\n" + Engine.saveField
      end
      table_attr.attach(b_fieldSave,1,2,2,3)

      b_fieldDisplay = Gtk::Button.new(:label => "Display Fields")
      b_fieldDisplay.signal_connect "clicked" do |_widget|
        textView.buffer.text= "Displaying...\n" + Utility.msg(Engine.dispFields)
      end
      table_attr.attach(b_fieldDisplay,2,3,2,3)

      b_fieldAdd = Gtk::Button.new(:label => "Add Field ")
      b_fieldAdd.signal_connect "clicked" do |_widget|
        AddFieldWindow.new
      end
      table_attr.attach(b_fieldAdd,3,4,2,3)

      b_fieldDel = Gtk::Button.new(:label => "Delete Field")
      b_fieldDel.signal_connect "clicked" do |_widget|
        DeleteFieldWindow.new
      end
      table_attr.attach(b_fieldDel,4,5,2,3) 

      window.signal_connect("delete-event") { |_widget| window.hide }
      window.show_all
    end
  end

  class AddFieldWindow < Gtk::Window
     def initialize
      num_attr = Field.num_attr + 1 #extra one for name
      window = Gtk::Window.new("Add new field")
      height = 100*(num_attr%10)+100
      width = 300*(num_attr/10+1)
      window.set_size_request(height,width)
      window.set_border_width(1)

      table_field_add = Gtk::Table.new(height/100,width/100,true)
      window.add(table_attr_add)

      label_entry_name = Gtk::Label.new("Field Name")
      entry_name = Gtk::Entry.new
      table_field_add.attach(entry_name,1,3,0,1)
      table_field_add.attach(label_entry_name,0,1,0,1)
      entries=[]
      counter=0
      Field.attributes.each{|key,value|
          counter+=1
          label_entry_key = Gtk::Label.new(key)
          entry_key = Gtk::Entry.new
          table_field_add.attach(entry_key,counter/10*3+1,counter/10*3+3,counter%10,counter%10+1)
          table_field_add.attach(label_entry_key,counter/10*3,counter/10*3+1,counter%10,counter%10+1)
          entries<<entry_key
      }

      b_cancel = Gtk::Button.new(:label => "Cancel")
      table_field_add.attach(b_cancel,0,1,height/100-1,height/100)
      b_cancel.signal_connect "clicked" do |_widget|
         window.hide()
      end

      b_add = Gtk::Button.new(:label => "Add")
      table_field_add.attach(b_add,width/100-1,width/100,height/100-1,height/100)
      args=[]
      b_add.signal_connect "clicked" do |_widget|
        name = entry_name.text
        entries.each{|entry|
          args<<entry.text
        }

        if(name==""||args.any? { |element| element ==""})
          DialogWindow.new("Error","Entry cannot be empty")
        else
          Engine.add_Field(name, args)
          window.hide()
        end
      end
      window.signal_connect("delete-event") { |_widget| window.hide() }
      window.show_all
    end
  end

   class DeleteFieldWindow < Gtk::Window
    def initialize
      window = Gtk::Window.new("Delete Attribute")
      window.set_size_request(400,300)
      window.set_border_width(1)
      table_field_del = Gtk::Table.new(2,3,true)
      window.add(table_field_del)

      Engine.loadField
      fields = Field.getList.keys
      cbox_field = Gtk::ComboBoxText.new
      fields.each{ |field|
        cbox_field.append_text field
      }
      table_field_del.attach(cbox_field, 0,1,0,1)

      text_field_detail = Gtk::TextView.new
      table_field_del.attach(text_field_detail,1,3,0,1)

      b_cancel = Gtk::Button.new(:label => "Cancel")
      b_cancel.signal_connect "clicked" do |_widget|
        window.hide()
      end
      table_field_del.attach(b_cancel,0,1,1,2)

      b_del = Gtk::Button.new(:label => "Delete")
      b_del.signal_connect "clicked" do |_widget|
        Engine.del_Field(cbox_field.active_iter[0])
        window.hide()
        DialogWindow.new("Delete Field","%s has been deleted" % [cbox_field.active_iter[0]])
      end
      table_field_del.attach(b_del,2,3,1,2)
      b_del.sensitive=false
      cbox_field.signal_connect "changed" do 
        if(cbox_field.active_iter[0]!="")
          b_del.sensitive =true
          text_field_detail.buffer.text = Field.find(cbox_field.active_iter[0]).detailText
        else
          b_del.sensitive=false
        end
      end
      window.signal_connect("delete-event") { |_widget| window.hide() }
      window.show_all
    end
  end
end
