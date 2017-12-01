########################################################
# Find the sum of all digits that match the next digit.#
# To run: ruby puzzle1.rb input                        #
########################################################

def match_next?(string, i)
  j = (i + 1) % string.length
  string[i] == string[j]
end

def quantize(s)
  (0...s.length)
   .select { |i| match_next?(s, i) }
   .sum { |i| s[i].to_i }
end

puts quantize(ARGF.gets.chomp)
