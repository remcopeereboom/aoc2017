###############################################################################
# Runs an instruction set and prints out the largest value in the registry    #
# after program completion.                                                   #
#                                                                             #
# To run: ruby puzzle1.rb input                                               #
###############################################################################

module Parser
  REGISTER = '\w+'
  NUMBER = '-?\d+'
  OPCODE = '(inc|dec)'
  COMPARATOR = '(>|<|>=|<=|==|!=)'
  COMMAND = "(?<reg>#{REGISTER}) (?<opp>#{OPCODE}) (?<num>#{NUMBER})"
  CONDITION = "(?<reg>#{REGISTER}) (?<cmp>#{COMPARATOR}) (?<num>#{NUMBER})"
  INSTRUCTION = "(?<cmd>#{COMMAND}) if (?<cnd>#{CONDITION})"

  CMD_MATCHER = Regexp.new(COMMAND)
  CND_MATCHER = Regexp.new(CONDITION)
  INST_MATCHER = Regexp.new(INSTRUCTION)

  def self.parse_instruction(instruction)
    INST_MATCHER.match(instruction).values_at(:cmd, :cnd)
  end

  def self.parse_command(command)
    CMD_MATCHER.match(command).values_at(:reg, :opp, :num)
  end

  def self.parse_condition(condition)
    CND_MATCHER.match(condition).values_at(:reg, :cmp, :num)
  end
end

class Register
  def initialize
    @register = {}
  end

  def get(r)
    @register[r] || 0
  end

  def set(r, val)
    @register[r] = val
  end

  def each_value(&block)
    @register.each_value(&block)
  end

  def to_s
    @register.to_s
  end

  def to_h
    @register.to_h
  end
end

class Emulator
  attr_reader :register

  def initialize
    @register = Register.new
  end

  def run(instructions)
    instructions.each { |i| interpret i.chomp }
  end

  private

  def interpret(instruction)
    cmd, cnd = Parser.parse_instruction(instruction)
    run_cmd(cmd) if eval_cnd(cnd)
  end

  def run_cmd(cmd)
    reg, opp, num = Parser.parse_command(cmd)

    case opp
    when 'inc'
      @register.set(reg, @register.get(reg) + num.to_i)
    when 'dec'
      @register.set(reg, @register.get(reg) - num.to_i)
    else
      fail ArgumentError, "Not a valid opcode (#{opp})"
    end
  end

  def eval_cnd(cnd)
    reg, cmp, num = Parser.parse_condition(cnd)

    case cmp
    when '<'
      @register.get(reg) <  num.to_i
    when '<='
      @register.get(reg) <= num.to_i
    when '=='
      @register.get(reg) == num.to_i
    when '>='
      @register.get(reg) >= num.to_i
    when '>'
      @register.get(reg) >  num.to_i
    when '!='
      @register.get(reg) != num.to_i
    else
      fail ArgumentError, "Not a valid comparator (#{cmp})"
    end
  end
end

e = Emulator.new
e.run(ARGF.each_line)

puts "The state of the register is: #{e.register}"
puts "The largest value in the register is: #{e.register.each_value.max}"
