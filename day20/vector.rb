class Vector
  attr_reader :x, :y, :z

  def initialize(x, y, z)
    @x = x
    @y = y
    @z = z
  end

  def +(other)
    Vector.new(@x + other.x, @y + other.y, @z + other.z)
  end

  def -(other)
    Vector.new(@x - other.x, @y - other.y, @z - other.z)
  end

  def *(other)
    Vector.new(@x * other, @y * other, @z * other)
  end

  def ==(other)
    return false unless other.is_a? Vector
    @x == other.x && @y == other.y && @z == other.z
  end

  def inspect
    to_s
  end

  def to_s
    "<#{@x},#{@y},#{@z}>"
  end

  def to_a
    [@x, @y, @z]
  end

  def manhattan
    @x.abs + @y.abs + @z.abs
  end
end
