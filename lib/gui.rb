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
      crudWindow("Attribute")
    end
    table_main.attach(b_attr,0,1,0,1)
    
    b_field = Gtk::Button.new(:label => "Fields")
    b_field.signal_connect "clicked" do |_widget|
      crudWindow("Field")   
    end
    table_main.attach(b_field,0,1,1,2)
    
    b_agent = Gtk::Button.new(:label => "Agents")
    b_agent.signal_connect "clicked" do |_widget|
      crudWindow("Agent")
    end
    table_main.attach(b_agent,0,1,2,3)
    
    b_battle = Gtk::Button.new(:label => "Battle")
    b_battle.signal_connect "clicked" do |_widget|
      Engine.test_creation
    end
    table_main.attach(b_battle,0,1,3,4)
    
    b_quit = Gtk::Button.new(:label=>"Quit")
    b_quit.signal_connect "clicked" do |_widget|
      Gtk.main_quit
    end
    table_main.attach(b_quit,0,1,4,5)
    window.signal_connect("delete-event") { |_widget| Gtk.main_quit }
    window.show_all
    Gtk.main
  end
  #CRUD UI of an object
  def crudWindow(className)
    window = Gtk::Window.new("className")
    window.set_size_request(1366, 768)
    window.set_border_width(1)

    table = Gtk::Table.new(3,5,true)
    window.add(table)
    #Text Field#
    textView = Gtk::TextView.new
    table.attach(textView,0,5,0,2)

    b_Load = Gtk::Button.new(:label => "Load %s" % className)
    b_Load.signal_connect "clicked" do |_widget|
      textView.buffer.text= "Loading...\n" + Engine.loadClass(className)    
    end
    table.attach(b_Load,0,1,2,3)

    b_Save = Gtk::Button.new(:label => "Save %s" % className)
    b_Save.signal_connect "clicked" do |_widget|
      textView.buffer.text= "Saving...\n" + Engine.saveClass(className)
    end
    table.attach(b_Save,1,2,2,3)

    b_Display = Gtk::Button.new(:label => "Display %s" % className)
    b_Display.signal_connect "clicked" do |_widget|
      textView.buffer.text= "Displaying...\n" + Utility.msg(Engine.dispClass(className))
    end
    table.attach(b_Display,2,3,2,3)

    b_Add = Gtk::Button.new(:label => "Add new %s" % className)
    b_Add.signal_connect "clicked" do |_widget|
      addWindow(className)
    end
    table.attach(b_Add,3,4,2,3)

    b_Del = Gtk::Button.new(:label => "Delete %s" % className)
    b_Del.signal_connect "clicked" do |_widget|
      deleteWindow(className)
    end
    table.attach(b_Del,4,5,2,3) 

    window.signal_connect("delete-event") { |_widget| window.hide() }
    window.show_all
  end
  #UI for adding an object
  def addWindow(className)
    num_attr = Engine.num_attr(className) + 1 #extra one for name
    window = Gtk::Window.new("Add new %s" % className)
    height = 100*(num_attr%10)+100
    width = 300*(num_attr/10+1)
    window.set_size_request(height,width)
    window.set_border_width(1)

    table_add = Gtk::Table.new(height/100,width/100,true)
    window.add(table_add)

    label_entry_name = Gtk::Label.new("%s Name" % className)
    entry_name = Gtk::Entry.new
    table_add.attach(entry_name,1,3,0,1)
    table_add.attach(label_entry_name,0,1,0,1)
    entries=[]
    counter=0
    Engine.attributes(className).each{|key,value|
        counter+=1
        label_entry_key = Gtk::Label.new(key)
        entry_key = Gtk::Entry.new
        table_add.attach(entry_key,counter/10*3+1,counter/10*3+3,counter%10,counter%10+1)
        table_add.attach(label_entry_key,counter/10*3,counter/10*3+1,counter%10,counter%10+1)
        entries<<entry_key
    }

    b_cancel = Gtk::Button.new(:label => "Cancel")
    table_add.attach(b_cancel,0,1,height/100-1,height/100)
    b_cancel.signal_connect "clicked" do |_widget|
       window.hide()
    end

    b_add = Gtk::Button.new(:label => "Add")
    table_add.attach(b_add,width/100-1,width/100,height/100-1,height/100)
    args=[]
    b_add.signal_connect "clicked" do |_widget|
      name = entry_name.text
      entries.each{|entry|
        args<<entry.text
      }

      if(name==""||args.any? { |element| element ==""})
        DialogWindow.new("Error","Entry cannot be empty")
      else
        obj = Engine.addObject(className,name, args)
        DialogWindow.new("Add %s" % className,"%s has been added" % obj.detailText)
        window.hide()
      end
    end
    window.signal_connect("delete-event") { |_widget| window.hide() }
    window.show_all
  end
  #UI for deleting an object
  def deleteWindow(className)
    window = Gtk::Window.new("Delete %s" % className)
      window.set_size_request(400,300)
      window.set_border_width(1)
      table_del = Gtk::Table.new(2,3,true)
      window.add(table_del)

      Engine.loadClass(className)
      objects = Engine.getList(className).keys
      cbox_objects = Gtk::ComboBoxText.new
      objects.each{ |obj|
        cbox_objects.append_text obj
      }
      table_del.attach(cbox_objects, 0,1,0,1)

      text_detail = Gtk::TextView.new
      table_del.attach(text_detail,1,3,0,1)

      b_cancel = Gtk::Button.new(:label => "Cancel")
      b_cancel.signal_connect "clicked" do |_widget|
        window.hide()
      end
      table_del.attach(b_cancel,0,1,1,2)

      b_del = Gtk::Button.new(:label => "Delete")
      b_del.signal_connect "clicked" do |_widget|
        Engine.delObject(className,cbox_objects.active_iter[0])
        window.hide()
        DialogWindow.new("Delete %s" % className,"%s has been deleted" % [cbox_objects.active_iter[0]])
      end
      
      table_del.attach(b_del,2,3,1,2)
      b_del.sensitive=false
      cbox_objects.signal_connect "changed" do 
        if(cbox_objects.active_iter[0]!="")
          b_del.sensitive =true
          text_detail.buffer.text = Engine.find(className,cbox_objects.active_iter[0]).detailText
        else
          b_del.sensitive=false
        end
      end
      window.signal_connect("delete-event") { |_widget| window.hide() }
      window.show_all
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
end
