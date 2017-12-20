################################################################################
# Reads a list of particles from successive lines of input and then prints out #
# the number of the particles remaining at t = INFINITY when all particles     #
# that collide at any point are immediately removed.                           #
#                                                                              #
# To run: ruby puzzle2.rb input                                                #
################################################################################

require_relative 'system'

def particles_from(istream)
  istream
    .each_line
    .map { |l| Particle.from(l) }
end

particles = particles_from(ARGF)

system = System.new(particles)
system.remove_all_future_colliders
puts system.size

