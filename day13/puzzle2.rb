################################################################################
# Finds the minimum delay for passing through scanners with a total severity   #
# of 0.                                                                        #
#                                                                              #
# To run: ruby puzzle1.rb input                                                #
################################################################################

class Scanner
  attr_reader :position, :range

  def initialize(range)
    @range = range
    @position = 0
    @sp = 0
    @direction = :down
    @sd = :down
  end

  def step
    if @direction == :down
      move_down
    else
      move_up
    end
  end

  def store
    @sp = @position
    @sd = @direction
  end

  def reset
    @position = @sp
    @direction = @sd
  end

  def to_s
    (0...@range).map { |i| i == @position ? '[S]' : '[ ]' }.join(' ')
  end

  private

  def move_down
    if @position == @range - 1
      @position -= 1
      @direction = :up
    else
      @position += 1
    end
  end

  def move_up
    if @position == 0
      @position += 1
      @direction = :down
    else
      @position -= 1
    end
  end
end

class Ride
  def self.from(istream)
    scanners = {}

    istream.each_line do |l|
      /\A(?<depth>\d+): (?<range>\d+)\z/ =~ l.chomp
      scanners[depth.to_i] = Scanner.new(range.to_i)
    end

    Ride.new(scanners)
  end

  def initialize(scanners)
    @scanners = scanners
    @max_depth = @scanners.keys.max
  end

  def min_delay
    delay = 0

    loop do
      return delay unless detected_run?

      delay += 1

      @scanners.each_value(&:reset)
      step
      @scanners.each_value(&:store)
    end
  end

  def detected_run?
    (0..@max_depth).any? do |depth|
      d = detected?(depth)
      step
      d
    end
  end

  def detected?(depth)
    @scanners[depth]&.position == 0
  end

  def step
    @scanners.each_value(&:step)
  end
end

ride = Ride.from(ARGF)
puts ride.min_delay
