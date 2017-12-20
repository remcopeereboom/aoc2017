################################################################################
# Reads a list of particles from successive lines of input and then prints out #
# the line number of the particle that at t=INFINITY will be nearest to the    #
# origin.                                                                      #
#                                                                              #
# To run: ruby puzzle1.rb input                                                #
################################################################################

require_relative 'particle'

def particles_from(istream)
  istream
    .each_line
    .with_index
    .map { |l, i| [i, Particle.from(l)] }
end

def min_a(particles)
  particles.map { |_i, p| p.a.manhattan }.min
end

def min_v(particles)
  particles.map { |_i, p| p.v.manhattan }.min
end

def min_p(particles)
  particles.map { |_i, p| p.p.manhattan }.min
end

particles = particles_from(ARGF)

a_min = min_a(particles)
particles.reject! { |_i, p| p.a.manhattan != a_min }

v_min = min_v(particles)
particles.reject! { |_i, p| p.v.manhattan != v_min }

p_min = min_p(particles)
particles.reject! { |_i, p| p.p.manhattan != p_min }

puts particles.first.first
