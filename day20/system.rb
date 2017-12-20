require_relative 'particle'

class System
  attr_reader :particles

  def initialize(particles)
    @particles = particles
  end

  def remove_all_future_colliders
    until converged?
      marked = find_collisions
      marked.each_with_index { |m, i| particles[i] = nil if m }
      @particles.compact!
      @particles.each(&:step)
    end
  end

  def size
    @particles.size
  end

  private

  def converged?
    converged_x? && converged_y? && converged_z?
  end

  def converged_x?
    @particles
      .sort { |a, b| a.p.x <=> b.p.x }
      .each_cons(2)
      .all? { |a, b| a.v.x <= b.v.x && a.a.x <= b.a.x }
  end

  def converged_y?
    @particles
      .sort { |a, b| a.p.y <=> b.p.y }
      .each_cons(2)
      .all? { |a, b| a.v.y <= b.v.y && a.a.y <= b.a.y }
  end

  def converged_z?
    @particles
      .sort { |a, b| a.p.z <=> b.p.z }
      .each_cons(2)
      .all? { |a, b| a.v.z <= b.v.z && a.a.z <= b.a.z }
  end

  def find_collisions
    marked = Array.new(@particles.length, false)

    (0...@particles.length - 1).each do |i|
      ((i + 1)...@particles.length).each do |j|
        if @particles[i].p == @particles[j].p
          marked[i] = marked[j] = true
        end
      end
    end

    marked
  end
end
