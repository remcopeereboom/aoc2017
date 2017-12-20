require_relative 'vector'

class Particle
  NUMBER = '(-?\d+)'
  VECTOR = "<#{NUMBER},#{NUMBER},#{NUMBER}>"
  private_constant :VECTOR

  def self.from(string)
    p = position_from(string)
    v = velocity_from(string)
    a = acceleration_from(string)

    Particle.new(p, v, a)
  end

  def self.position_from(string)
    px, py, pz = string.match(/p=#{VECTOR}/)[1..3].map(&:to_i)
    Vector.new(px, py, pz)
  end
  private_class_method :position_from

  def self.velocity_from(string)
    vx, vy, vz = string.match(/v=#{VECTOR}/)[1..3].map(&:to_i)
    Vector.new(vx, vy, vz)
  end
  private_class_method :velocity_from

  def self.acceleration_from(string)
    ax, ay, az = string.match(/a=#{VECTOR}/)[1..3].map(&:to_i)
    Vector.new(ax, ay, az)
  end
  private_class_method :acceleration_from

  attr_reader :p, :v, :a

  def initialize(p, v, a)
    @p = p
    @v = v
    @a = a
  end

  def step
    @v += a
    @p += v
  end

  def to_s
    "p=#{@p}, v=#{@v}, a=#{@a}"
  end
end
