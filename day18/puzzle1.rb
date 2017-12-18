################################################################################
# Takes a list of assembly instructions from the command line and runs them.   #
# Prints out the first time an rcv instructions is encountered.                #
#                                                                              #
# To run: ruby puzzle1.rb input                                                #
################################################################################

class Program
  INT = '\-?\d+'
  private_constant :INT

  REG = '[a-z]'
  private_constant :REG

  attr_reader :instructions, :registers, :ic

  def initialize(instructions)
    @instructions = instructions.dup
    @registers = Array('a'..'z').zip(Array.new(26, 0)).to_h
    @ic = 0 # Instruction counter
    @last_snd = 0
  end

  def run
    while instruction = @instructions[@ic]
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

      # rcv
      when /rcv (#{INT})/
        return @last_snd unless $1.to_i == 0
      when /rcv (#{REG})/
        return @last_snd unless @registers[$1] == 0

      # set
      when /set (#{REG}) (#{INT})/
        @registers[$1] = $2.to_i
      when /set (#{REG}) (#{REG})/
        @registers[$1] = @registers[$2]

      # snd
      when /snd (#{INT})/
        @last_snd = $1.to_i
      when /snd (#{REG})/
        @last_snd = @registers[$1]

      end

      @ic += 1
    end
  end
end

program = Program.new(ARGF.readlines)
puts program.run
