################################################################################
# Reads a series of dance steps from files passed to standard input and then   #
# prints out the resulting position of all programs.                           #
#                                                                              #
# To run: ruby puzzle1.rb input                                                #
################################################################################

class ProgramDance
  def self.from(istream)
    dance = ProgramDance.new('a'..'p')

    while s = istream.gets(',')
      case s
      when /s(\d+)/
        dance.spin($1.to_i)
      when /x(\d+)\/(\d+)/
        dance.exchange($1.to_i, $2.to_i)
      when /p([a-p])\/([a-p])/
        dance.partner($1, $2)
      else
        # Do nothing
      end
    end

    dance
  end

  def initialize(range = 'a'..'p')
    @programs = Array range
  end

  def spin(x)
    @programs.rotate!(-x)

    self
  end

  def exchange(a, b)
    @programs[a], @programs[b] = @programs[b], @programs[a]

    self
  end

  def partner(a, b)
    i = @programs.find_index(a)
    j = @programs.find_index(b)

    exchange(i, j)

    self
  end

  def to_s
    @programs.join
  end
end

puts ProgramDance.from(ARGF)
