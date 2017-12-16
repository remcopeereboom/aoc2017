################################################################################
# Reads a series of dance steps from files passed to standard input and then   #
# prints out the resulting position of all programs after executing the steps  #
# a billion times.                                                             #
#                                                                              #
# To run: ruby puzzle2.rb input                                                #
################################################################################

# ProgramDance
#
# Describes the state of a dance of programs.
class ProgramDance
  # Returns a dance after excuting repetions of moves read from istream.
  def self.from(istream, repetitions = 1_000_000_000)
    moves = parse(istream)
    repetitions %= cycle_length(moves)

    dance = ProgramDance.new('a'..'p')
    repetitions.times { execute_moves(moves, dance) }
    dance
  end

  # Parses an istream and returns list of dance moves
  def self.parse(istream)
    moves = istream.readlines(',')
    moves.map do |m|
      case m
      when /s(\d+)/
        [:spin, [$1.to_i]]
      when %r{x(\d+)\/(\d+)}
        [:exchange, [$1.to_i, $2.to_i]]
      when %r{p([a-p])\/([a-p])}
        [:partner, [$1, $2]]
      end
    end
  end
  private_class_method :parse

  # Returns the length of the shortest cycle after which executing dance moves
  # repeats the state of the dance.
  def self.cycle_length(moves)
    dance = ProgramDance.new('a'..'p')
    seen_states = []

    until seen_states.include?(h = dance.programs.hash)
      seen_states << h
      execute_moves(moves, dance)
    end

    seen_states.length
  end
  private_class_method :cycle_length

  # Performes the list of moves on the dance.
  def self.execute_moves(moves, dance)
    moves.each { |m, steps| dance.send(m, *steps) }
  end
  private_class_method :execute_moves

  attr_reader :programs

  def initialize(range = 'a'..'p')
    @programs = Array range
  end

  # Perform a spin of size x.
  def spin(x)
    @programs.rotate!(-x)
  end

  # Perform an exchange of the programs at i and j.
  def exchange(i, j)
    @programs[i], @programs[j] = @programs[j], @programs[i]
  end

  # Perform a partnering of the programs a and b.
  def partner(a, b)
    i = @programs.find_index(a)
    j = @programs.find_index(b)

    exchange(i, j)
  end

  # Returns the position of the programs.
  def to_s
    @programs.join
  end
end

puts ProgramDance.from(ARGF)
