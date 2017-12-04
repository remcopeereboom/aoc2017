################################################################################
# Takes a number of lines of words and returns the number of lines that do not #
# contain anagrams (of other words on that line).                              #
#                                                                              #
# To run: ruby puzzle2.rb input                                                #
################################################################################

# Are a and b anagrams?
def anagram?(a, b)
  return false unless a.length == b.length
  a.chars.sort == b.chars.sort
end

# Are any 2 of the words in the list anagrams?
def contains_anagrams?(words)
  (0...words.length).any? do |i|
    (i + 1...words.length).any? do |j|
      anagram?(words[i], words[j])
    end
  end
end

puts ARGF.each_line
         .map { |line| line.split }
         .count { |words| !contains_anagrams?(words) }
