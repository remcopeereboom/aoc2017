#######################################################################
# Find the sum of all digits that match the digit half a string away. #
# To run: ruby puzzle2.rb input                                       #
#######################################################################

def match?(string, i)
  j = (i + (string.length / 2)) % string.length
  string[i] == string[j]
end

def quantize(s)
  (0...s.length)
   .select { |i| match?(s, i) }
   .sum { |i| s[i].to_i }
end

puts quantize(ARGF.gets.chomp)
