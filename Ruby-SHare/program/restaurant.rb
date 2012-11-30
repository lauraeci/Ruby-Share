class Restaurant
  attr_reader :menu_file, :menu_items, :menu_choices, :restaurant_ids
  
  def initialize menu_file, menu_choices
    @menu_file = menu_file
    @menu_choices = menu_choices
    @restaurant_ids = []
    self.read_menu
    all_options, is_choice_found, is_combo_item = self.find_options
    
    if all_options.nil?
      puts nil
      return nil
    else
      cheapest_option, restaurant = self.show_best_option all_options
      
      @menu_choices.each_with_index {|choice, index|
        is_combo_item[index]
        if is_choice_found[index] == @menu_choices.length
          puts restaurant.to_s + ',' + cheapest_option.to_s
          return restaurant.to_s, cheapest_option.to_s
        end
      }
      puts nil
      return nil
    end
    
  end
  
  def read_menu
    
    if (@menu_file.nil?)
      raise "Menu file was not found!"
    end
    
    menu = File.open(@menu_file).readlines
    @menu_items = Hash.new
    menu.each {|item| 
      menu_item = item.split(",")
      
      if (@menu_items[menu_item[0].to_i].nil?)
        @menu_items[menu_item[0].to_i] = []
      end
      if (!@restaurant_ids.include? menu_item[0].to_i)
        @restaurant_ids << menu_item[0].to_i
      end
      items = []
      
      for i in 2...menu_item.length
        items << menu_item[i].strip
      end
      
      @menu_items[menu_item[0].to_i] << {"price" => menu_item[1].strip.to_f, "items" => items}
      
    }
    #puts @menu_items[2]["price"]
    puts @menu_items.inspect
  end
  
  def find_options
    puts @restaurant_ids.inspect
    options = []
    is_choice_found_count = []
    is_combo_item = []
    
    @menu_choices.each_with_index {|choice, index|
      if (is_choice_found_count[index].nil?)
        is_choice_found_count[index] = 0
      end
      
      if (is_combo_item[index].nil?)
        is_combo_item[index] = 0
      end
      
      @restaurant_ids.each{|id|
        
        @menu_items[id].each {|item|
          
          if (options[id].nil?)
            options[id] = 0.0
          end
          
          if (item["items"].find{|anItem| choice == anItem})
            
            
            if (is_combo_item[index] != index)
              puts 'Is Not combo: ' + id.to_s + ": " + choice + ":" + item["price"].to_s
              cost = options[id]
              cost += item["price"]
              options[id] = cost
               puts is_combo_item[index]
              is_combo_item[index] = 0
             
            else
              
              puts 'Is Combo: ' +  id.to_s + ": " + choice + ":" + item["price"].to_s
            end
            is_choice_found_count[index] += 1 
            is_combo_item[index] = index
            puts index
         
            
          end
        }
      }     
    }
    puts 'options: ' + options.inspect
    puts 'count: ' + is_choice_found_count.inspect
    return options, is_choice_found_count, is_combo_item
  end
  
  def show_best_option options
    cheapest_option = Float::MAX
    restaurant = -1
    options.each_with_index {|option, index| 
      if (!option.nil? and option < cheapest_option)
        cheapest_option = option 
        restaurant = index
      end
    }
    return cheapest_option, restaurant
  end
  
end

menu_file = ARGV[0]
ARGV.shift
menu_choices = ARGV

familiar_faces_restaurants = Restaurant.new(menu_file, menu_choices)