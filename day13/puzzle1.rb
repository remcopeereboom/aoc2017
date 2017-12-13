###############################################################################
# Finds the total severity of a ride with 0 delay passing through scanners    #
#                                                                             #
# To run: ruby puzzle1.rb input                                               #
###############################################################################

class Scanner
  attr_reader :position, :range

  def initialize(range)
    @range = range
    @position = 0
    @direction = :down
  end

  def step
    if @direction == :down
      move_down
    else
      move_up
    end
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

  attr_reader :total_severity

  def initialize(scanners)
    @scanners = scanners
    @current_depth = 0
    @max_depth = @scanners.keys.max
    @total_severity = 0

    ride
  end

  private

  def ride
    while @current_depth <= @max_depth
      @total_severity += severity
      step
    end
  end

  def step
    @scanners.each_value(&:step)
    @current_depth += 1
  end

  def detected?
    @scanners[@current_depth] && 0 == @scanners[@current_depth].position
  end

  def severity
    return 0 unless detected?

    @current_depth * @scanners[@current_depth].range
  end
end

ride = Ride.from(ARGF)
p ride.total_severity
