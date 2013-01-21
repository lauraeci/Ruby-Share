require 'thread'

# An interface for executing an operation
class Command
  attr_reader :state
  
  def execute 
  end
  
  def unexecute
  end
  
  def usage
    
  end
  
  def set_args
    
  end
end

class Invoker
  attr_reader :cmd_queue
  attr_reader :redo_queue
  
  def initialize
    if (@cmd_queue.nil?)
      # uses Ruby's Thread safe queue
      @cmd_queue = Queue.new
      
    end
    
    if (@redo_queue.nil?)
      @redo_queue = Queue.new
    end
  end
  
  def usage(current_cmd)
    return current_cmd.usage() 
  end
  
  def doCommand (current_cmd, args)
    @cmd_queue.push(current_cmd)
    current_cmd.set_args(args)
    current_cmd.execute()
    @redo_queue.clear()
  end
  
  def undoCommand ()
    puts "Undo size #{@cmd_queue.size}"
    if @cmd_queue.size == 0
      puts "Nothing to undo."
      return
    end
    commandToUndo = @cmd_queue.pop()
    puts "Undo size #{@cmd_queue.size}"
    commandToUndo.unexecute()
    @redo_queue.push(commandToUndo)
  end
  
  def redoCommand()
    puts "Redo size #{@redo_queue.size}"
    if @redo_queue.size == 0
      puts "Nothing to redo."
      return
    end
    commandToRedo = @redo_queue.pop()
    puts "Redo size #{@redo_queue.size}"
    commandToRedo.execute()
    
    # Add back to the command queue to enable undo after redo
    @cmd_queue.push(commandToRedo)
  end
  
end

# a new Command, i.e.PasteComand, OpenCommand
# implements execution by invoking the corresponding operations
# on a receiver
# implements unexecute by 
class CreateFileCommand < Command
  
  def usage
    return "new_file <path> <contents>"
  end
  
  def execute
    f = File.open(@path, "w")
    f.write(@contents)
    f.close
    puts "Created #{@path}!"
  end
  
  def unexecute
    begin 
      File.delete(@path)
      puts "Deleted #{@path}!"
    rescue Errno::ENOENT
      puts "An error occurred, not file to delete #{@path}!"
    end
  end
  
  def set_args(args)
    
    puts args.size
    if args.size < 3
      raise "Insufficient arguments! Expected: " + self.usage()
    end
    @path = args[1]
    @contents = ""
    for index in 2 ... args.size 
      @contents += args[index].to_s
    end
  end
end

class ConsoleApplication
  
  def initialize()
    @commands_list = Hash.new
    @commandInvoker = Invoker.new
  end
  
  def register_commands  
    new_file_cmd = CreateFileCommand.new
    puts new_file_cmd.usage()
    @commands_list["new_file"] = new_file_cmd
  end
  
  def quit? 
    # See if a 'Q' has been typed yet
    while cmd = STDIN.readline()
      
      # read a multitoken command, i.e. new_file "myfile.txt", "This is a new File"
      commands = cmd.split()
      
      if @commands_list.include?(commands[0])
        @commandInvoker.doCommand(@commands_list[commands[0]], commands)        
      end
      
      if cmd.chomp.downcase == 'redo'
        @commandInvoker.redoCommand()
      end
      
      if cmd.chomp.downcase == 'undo'
        @commandInvoker.undoCommand()
      end
      
      if cmd.chomp.downcase == '-h'
        puts "Available commands:"
        @commands_list.each_pair do |k,v| 
          puts v.usage()
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
console.register_commands
console.main
#client = Client.new
