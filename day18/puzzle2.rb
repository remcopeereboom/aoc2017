################################################################################
# Takes a list of assembly instructions from the command line. Creates a pair  #
# of programs that snd and rcv values from one another.                        #
# Prints out the number of times porgram 1 has snd instructions to program 0.  #
#                                                                              #
# To run: ruby puzzle2.rb input                                                #
################################################################################

class System
  # Initializes a new system of two programs.
  def initialize(instructions)
    @programs = [
      Program.new(self, 0, instructions),
      Program.new(self, 1, instructions)
    ]

    @queues = @programs.map { [] }
    @send_to_0 = 0
  end

  # Adds an item to the send queue for program with the given id.
  def send(id, value)
    @send_to_0 += 1 if id == 0
    @queues[id].unshift value
  end

  # Returns any item waiting on the receive queue for program with the given id.
  def receive(id)
    @queues[id].pop
  end

  def run
    i = 0
    loop do
      return @send_to_0 if @programs.all?(&:waiting?) && @queues.all?(&:empty?)

      @programs[0].tick
      @programs[1].tick

      i += 1
    end
  end
end

class Program
  INT  = '\-?\d+'
  private_constant :INT

  REG = '[a-z]'
  private_constant :REG

  attr_reader :parent, :id, :instructions, :registers, :ic

  # Initialize a new program with the parent sytstem, the given id, and the
  # given instructions to execute.
  def initialize(parent, id, instructions)
    @parent = parent
    @id = id
    @target = (id == 0 ? 1 : 0)

    @registers = Array('a'..'z').zip(Array.new(26, 0)).to_h
    @registers['p'] = id

    @instructions = instructions.dup
    @ic = 0 # Instruction counter

    @waiting = false
    @receiver = nil
  end

  # Is the program waiting for input.
  def waiting?
    @waiting
  end

  # Advance the program by a single tick.
  def tick
    if waiting?
      receive
    else
      run(@instructions[@ic])
      @ic += 1
    end
  end

  private

  # Retrieves an instruction from the instruction queue.
  def receive
    return unless x = @parent.receive(id)
    @registers[@receiver] = x
    @waiting = false
  end

  # Run a single instruction.
  def run(instruction)
    case instruction

    # add
    when /add (#{REG}) (#{INT})/
      @registers[$1] += $2.to_i
    when /add (#{REG}) (#{REG})/
      @registers[$1] += @registers[$2]

    # jgz
    when /jgz (#{REG}) (#{INT})/
      @ic += $2.to_i - 1 unless @registers[$1] <= 0
    when /jgz (#{INT}) (#{INT})/
      @ic += $2.to_i - 1 unless $1.to_i <= 0
    when /jgz (#{REG}) (#{REG})/
      @ic += @registers[$2] - 1 unless @registers[$1] <= 0

    # mod
    when /mod (#{REG}) (#{INT})/
      @registers[$1] %= $2.to_i
    when /mod (#{REG}) (#{REG})/
      @registers[$1] %= @registers[$2]

    # mul
    when /mul (#{REG}) (#{INT})/
      @registers[$1] *= $2.to_i
    when /mul (#{REG}) (#{REG})/
      @registers[$1] *= @registers[$2]

    # set
    when /set (#{REG}) (#{INT})/
      @registers[$1] = $2.to_i
    when /set (#{REG}) (#{REG})/
      @registers[$1] = @registers[$2]

    # snd
    when /snd (#{INT})/
      @parent.send(@target, $1.to_i)
    when /snd (#{REG})/
      @parent.send(@target, @registers[$1])

    # rcv
    when /rcv (#{REG})/
      @waiting = true
      @receiver = $1
    when /rcv (#{INT})/
      @waiting = true
      @receiver = $1
    end
  end
end

system = System.new(ARGF.readlines)
puts system.run
