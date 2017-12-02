##############################################################################
# Takes a bunch of rows of space separated integes, then computes the        #
# difference of the max and min of each row ans sums these.                  #
#                                                                            #
# To run: ruby puzzle1.rb input                                              #
##############################################################################

sum = 0
ARGF.each_line do |l|
  row = l.split.map(&:to_i)
  sum += row.max - row.min
end

puts sum
