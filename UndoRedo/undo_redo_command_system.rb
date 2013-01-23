 #
 # undo_redo_command_system.rb
 #
 #  Created on: January 21, 2013
 #      Author: marshalll
 #
 # Solution uses a variation of the Gang of Four Command Pattern
 # on Page 233.
 #
 # Programming problem:
 # UNDO REDO
 # Build a simple undo/redo system in any object-oriented programming
 # language. It should meet these criteria:
 # - An unlimited number of operations can be performed, undone and redone
 # - The system is generic and can easily be extended with new kinds of
 # actions
 # - The code is production quality
 # - The undo/redo functionality is demonstrated in a simple console
 # application
 # - It doesn't use heavily platform-specific code
 #/
 
# An interface for executing an operation
# used as a base class for new commands in the system
class Command
  
  def execute 
  end
  
  def unexecute
  end
  
  def usage 
  end
  
  def set_args
  end
  
  def description
  end
  
end

# Invoker
# Runs the commands registered in register_commands
# To add a new command, add this command and its constructor to the commands_list hash
class Invoker
  attr_reader :cmd_stack
  attr_reader :redo_stack
  attr_reader :commands_list
  
  def register_commands()
    @commands_list["new_file"] = "CreateFileCommand.new"
    # example: 
    # @commands_list["spend_money"] = "SpendMoneyCommand.new"
  end
  
  # getCommands
  # @returns: list of registered commands in a hash
  def getCommands
    return @commands_list
  end

  def initialize
    if (@cmd_stack.nil?)
      @cmd_stack = Array.new
    end
    
    if (@redo_stack.nil?)
      @redo_stack = Array.new
    end
    @commands_list = Hash.new
    self.register_commands()
  end
  
  def usage(current_cmd)
    return current_cmd.usage() 
  end
  
  def doCommand (current_cmd, args)
    new_cmd = eval(@commands_list[current_cmd])
    new_cmd.set_args(args)
    @cmd_stack.push(new_cmd)
    new_cmd.execute()
    @redo_stack.clear()
  end
  
  def undoCommand ()
    if @cmd_stack.size == 0
      puts "Nothing to undo."
      return
    end
    
    commandToUndo = @cmd_stack.pop()
    commandToUndo.unexecute()
    
    @redo_stack.push(commandToUndo)
  end
  
  def redoCommand() 
    if @redo_stack.size == 0
      puts "Nothing to redo."
      return
    end
    
    commandToRedo = @redo_stack.pop()
    commandToRedo.execute()
    
    # Add back to the command stack to enable undo after redo
    @cmd_stack.push(commandToRedo)
  end
  
end

# CreateFileCommand
# a new Command, i.e.PasteComand, OpenCommand
# implements execution by invoking the corresponding operations
# implements unexecute by invoking the corresponding operations 
class CreateFileCommand < Command
  
  def usage
    return "new_file <path> <contents>"
  end
  
  def description
    puts self.class.name.to_s + " : " + @path.to_s
  end
  
  def execute
    f = File.open(@path, "w")
    f.write(@contents)
    f.close
    puts "Created #{@path}!"
  end
  
  def unexecute 
    File.delete(@path)
    puts "Deleted #{@path}!"
  end
  
  # set_args
  # @params: args
  # precondition: args[0] is the command name
  def set_args(args)
    if args.size < 3
      raise "Insufficient arguments! Expected: " + self.usage()
    end
    @path = args[1]
    @contents = ""
    for index in 2 ... args.size 
      @contents += args[index].to_s + " "
    end
  end
  
end

class Factory

  def initialize()
      @commandInvoker = Invoker.new
  end
  
  def getInvoker()
    return @commandInvoker
  end
  
end

# ConsoleApplication
# A simple Command Line Application
# which allows the user to type registered commands 
# and undo or redo them.  
class ConsoleApplication
  
  def initialize()
      @commandFactory = Factory.new
  end
  
  def quit? 
    # See if a 'Q' has been typed yet
    while cmd = STDIN.readline()
      
      # read a multitoken command, i.e. new_file "myfile.txt", "This is a new File"
      commands = cmd.split()
      # puts @commandFactory.inspect
    
      if @commandFactory.getInvoker().getCommands().include?(commands[0])
        @commandFactory.getInvoker().doCommand(commands[0], commands)        
      end
      
      if cmd.chomp.downcase == 'redo'
         @commandFactory.getInvoker().redoCommand()
      end
      
      if cmd.chomp.downcase == 'undo'
         @commandFactory.getInvoker().undoCommand()
      end
      
      if cmd.chomp.downcase == '-h'
        puts "Available commands:"
        
        @commandFactory.getInvoker().getCommands().each_pair do |k,v|
          puts eval(v).usage()
        end
        puts "undo - undo a command"
        puts "redo - redo a command"
      end
      return true if cmd.chomp.downcase == 'q'
    end
    # No 'Q' found
    false
  end
  
  def main
    puts "Enter a command, redo, undo or -h for help, Q to quit"
    loop do
      break if quit?
      sleep 5
    end
  end
  
end

console = ConsoleApplication.new
console.main
