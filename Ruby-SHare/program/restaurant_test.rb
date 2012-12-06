require 'rspec'
require './restaurant.rb'

describe Restaurant do 
  
  it "TEST 1: should work for menu 1 " do 
   #menus1.csv ham_sandwich burrito
   #2, 11.5
   answer = Restaurant.new 'menu1.csv', ["ham_sandwich", "burrito"]
   answer.to_s.should == ["2", "11.5"]
  end

  it "TEST 2: should work for menu 2" do
    answer = Restaurant.new 'menus2.csv', ["ham_sandwich", "burrito"]
    answer.to_s.should == nil
  end 	

  it "TEST 3: should give us what we expect for menus3.csv" do
    answer = Restaurant.new 'menus3.csv',["milkshake", "fish_sandwich"]
    answer.to_s.should == ["6", "11.0"]
  end

  it "TEST 4: should give us the right order when the order 2 items from the same combo " do
    answer = Restaurant.new 'menus3.csv',["milkshake", "fish_sandwich", "blue_berry_muffin"]
    answer.to_s.should == ["6", "11.0"]
  end
  
  it "TEST 5: should give us the right order when the order is 2 items requiring 2 combos -- didn't get this case implemented " do
    answer = Restaurant.new 'menus3.csv',["fish_sandwich", "blue_berry_muffin", "chocolate_milk","fish_sandwich", "blue_berry_muffin", "chocolate_milk"]
    answer.to_s.should == ["6", "12.0"]
  end

end
