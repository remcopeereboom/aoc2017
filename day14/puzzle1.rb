################################################################################
# Takes a hash describing a disk and then returns the number of squares in the #
# disk that are in use.                                                        #
#                                                                              #
# Dependencies:                                                                #
#   -knot_hash.rb                                                              #
#   -disk.rb                                                                   #
#                                                                              #
# To run: ruby puzzle1.rb input                                                #
################################################################################

require_relative 'knot_hash'
require_relative 'disk'

key_string = ARGF.gets.chomp
disk = Disk.from_hash(key_string)
puts disk.used
