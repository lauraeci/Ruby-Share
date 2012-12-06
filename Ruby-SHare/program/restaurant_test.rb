require 'rspec'
require './restaurant.rb'

describe Restaurant do 

  before do
    # @restaurant = Restaurant.new
  end
  
  it "should work for menu 1 " do 
   #menus1.csv ham_sandwich burrito
   #2, 11.5
   answer = Restaurant.new 'menu1.csv', ["ham_sandwich", "burrito"]
   answer.to_s.should == "2, 11.5"
  end

  it "should work for menu 2" do
    answer = Restaurant.new 'menus2.csv', ["ham_sandwich", "burrito"]
    answer.to_s.should == nil
  end 	

  it "should give us what we expect for menus3.csv" do
    @restaurant = Restaurant.new 'menus3.csv',["milkshake", "fish_sandwich"]
    @restaurant.to_s.should == "6, 11.0"
  end

  it "should give us the right order when the order is a little more complex than our examples " do
    @restaurant = Restaurant.new 'menus3.csv',["milkshake", "fish_sandwich", "blue_berry_muffin"]
    @restaurant.to_s.should == "6, 11.0"
  end

end
