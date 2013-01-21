require 'rspec'
require './undo_redo_command_system.rb'

describe Client do 
  
  it "TEST 1: should create a file, delete the file and then recreate it " do 
 
   File.delete("myfile.txt")
   Client.new
   answer = File.exists?("myfile.txt")
   answer.should == true
  end

end