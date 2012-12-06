class Restaurant
  attr_reader :menu_file, :menu_items, :menu_choices, :restaurant_ids
  
  def initialize menu_file, menu_choices
    @menu_file = menu_file
    @menu_choices = menu_choices
    @restaurant_ids = []
    self.read_menu
    all_options, is_choice_found = self.find_options
    
    @answer = nil
    if all_options.nil?
      puts nil
      return @answer
    else
      cheapest_option, restaurant = self.show_best_option all_options
      
      # check all the choices are found at that restaurant
      if is_choice_found[restaurant] == (@menu_choices.length)
        puts restaurant.to_s + ',' + cheapest_option.to_s
        @answer = restaurant.to_s, cheapest_option.to_s
      end
         
    end
    
    return @answer
  end
  
  ##
  #nicely display the answer
  ##
  def to_s
    @answer
  end
  
  ## read_menu:
  #   
  #   parse the menu cvs file @menu_file 
  #   
  #   @postcondition: @menu_items contains a list of items as a hash with restaurant as the key
  #   for each restaurant.
  ##
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
      
      item_type = "items"
      combo_number = 0
      
      if (menu_item.length > 3)
        item_type = "combo"
        combo_number += 1
      end
      
      for i in 2...menu_item.length
        items << menu_item[i].strip
      end
      
      @menu_items[menu_item[0].to_i] << {"price" => menu_item[1].strip.to_f, item_type => items, "combo_number"=> combo_number}
      
    }
    
  end
  
  ## 
  #  find_options:
  #  find the restaurant options for the @menu_choices
  # 
  #  @return 
  #    options:  options is a list of the price of the order from each restaurant
  #    is_choice_found_count: list of the count of items for each restaurant
  #  
    def find_options
      
      options = []
      is_choice_found_count = []
      purchased_items = []
      
      @menu_choices.each_with_index {|choice, index|
        
        if (purchased_items[index].nil?)
          purchased_items[index] = []
        end
        
        @restaurant_ids.each{|restaurant_id|
          
          if (is_choice_found_count[restaurant_id].nil?)
            is_choice_found_count[restaurant_id] = 0
          end
          
          @menu_items[restaurant_id].each {|item|
            
            if (options[restaurant_id].nil?)
              options[restaurant_id] = 0.0
            end
            
            # Is the choice a regular item?
            if (!item["items"].nil? and item["items"].include? choice)
              
              cost = options[restaurant_id]
              cost += item["price"]
              options[restaurant_id] = cost
              is_choice_found_count[restaurant_id] += 1 
              
              # Is the choice a combo item?
            elsif (!item["combo"].nil?)
              
              if (item["combo"].include? choice)
                
                if !purchased_items.include? choice
                  
                  purchased_items[index] << item["combo"]
                  purchased_items = purchased_items.flatten
                  cost = options[restaurant_id]
                  cost += item["price"]
                  options[restaurant_id] = cost
                  
                end
                
                is_choice_found_count[restaurant_id] += 1 
                
              end
              
            end
            
            
          }
        }     
      }
      
      
      return options, is_choice_found_count
    end
    
    ##
    # show_best_option
    # @return:
    # cheapest_option: price of items from the cheapest restaurant option
    # restaurant: the id from the cheapest restaurant
    ##
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
  
  # menu_file = ARGV[0]
  # ARGV.shift
  # menu_choices = ARGV
  
  # familiar_faces_restaurants = Restaurant.new(menu_file, menu_choices)