################################################################################
# Takes a number of lines of words and returns the number of lines that        #
# contain only unique words (unique on that line).                             #
#                                                                              #
# To run: ruby puzzle1.rb input                                                #
################################################################################

# Are all words in the list unique?
def all_uniq?(words)
  words.length == words.uniq.length
end

puts ARGF.each_line
         .map { |line| line.split }
         .count { |words| all_uniq?(words) }
