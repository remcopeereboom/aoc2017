################################################################################
# Takes a hash describing a disk and then returns the number of regions in the #
# disk that are in use.                                                        #
#                                                                              #
# Dependencies:                                                                #
#   -knot_hash.rb                                                              #
#   -disk.rb                                                                   #
#   -graph.rb                                                                  #
#   -connected_components.rb                                                   #
#                                                                              #
# To run: ruby puzzle1.rb input                                                #
################################################################################

require_relative 'knot_hash'
require_relative 'disk'
require_relative 'graph'
require_relative 'connected_components'

key_string = ARGF.gets.chomp
disk = Disk.from_hash(key_string)
puts disk.nr_of_regions
