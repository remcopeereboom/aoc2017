###############################################################################
# This program works on a hexagonal grid. It takes a comma-separated list of  #
# move directions from standard input and prints the number of steps from the #
# origin after taking all moves.                                              #
#                                                                             #
# To run: ruby puzzle1 input                                                  #
###############################################################################

# A coordinate on a hexagonal grid, given in terms of it's distance along the
# radial axes of some origin.
#
# The system chosen here has the positive x-direction pointing south-east,
# the positive y-direction pointing due north, and the positive z-direction
# pointing south-west.
class CubeCoord
  # Returns the origin as a cube coordinate.
  def self.origin
    CubeCoord.new(0, 0, 0)
  end

  attr_reader :x, :y, :z

  # Initializes a new cube coordinates with the given radial axes.
  def initialize(x, y, z)
    fail ArgumentError "Cube coordinates must sum to 0." unless x + y + z == 0

    @x = x
    @y = y
    @z = z
  end

  # Adds to cube coordinates to return a new one.
  def +(vector)
    CubeCoord.new(@x + vector.x, @y + vector.y, @z + vector.z)
  end

  # Translates a point in a given direction. Mutates self.
  # @param direction [CubeCoord]
  def translate!(direction)
    @x += direction.x
    @y += direction.y
    @z += direction.z
  end

  # Returns the distance to another cube coordinate.
  def distance(other = CubeCoord.origin)
    ((@x - other.x).abs + (@y - other.y).abs + (@z - other.z).abs) / 2
  end
end

DIRECTION_TO_CUBE_COORD  = {
  n:   CubeCoord.new(0, 1, -1),
  ne:  CubeCoord.new(1, 0, -1),
  se:  CubeCoord.new(1, -1, 0),
  s:   CubeCoord.new(0, -1, 1),
  sw:  CubeCoord.new(-1, 0, 1),
  nw:  CubeCoord.new(-1, 1, 0)
}

def directions_from(istream)
  return enum_for(:directions_from, istream) unless block_given?

  while direction = istream.gets(',')
    yield direction.chomp[0..-2].to_sym
  end
end

def distance_after_journey(istream)
  directions_from(istream)
    .lazy.map { |d| DIRECTION_TO_CUBE_COORD[d] }
    .inject(CubeCoord.origin) { |pos, d| pos + d }
    .distance
end

puts distance_after_journey(ARGF)
