###############################################################################
# Takes a , separated list of integers and returns the knot hash.             #
#                                                                             #
# To run: ruby puzzle1.rb input                                               #
###############################################################################

class CircularArray
  # Initializes a new circular array
  def initialize(enumerable)
    @a = enumerable.to_a
    @size = @a.size
  end

  # Read into the array, where i is a circular index.
  def [](i)
    @a[i % @size]
  end

  # Write into the array, where i is a circular index.
  def []=(i, val)
    @a[i % @size] = val
  end

  # Reverse the subarray [start, start + length]
  def reverse!(start, length)
    length = length - 1
    (0..length / 2).each do |i|
      left = self[start + i]
      right = self[start + length - i]

      self[start + i] = right
      self[start + length - i] = left
    end

    self
  end
end

# Computes the 256 knot hash for a given list of lenghts.
def knot_hash(lengths)
  pos = 0
  skip = 0

  a = CircularArray.new(Array(0..255))
  lengths.each do |l|
    a.reverse!(pos, l)
    pos += l
    pos += skip
    skip += 1
  end

  a[0] * a[1]
end

lengths = ARGF.gets.split(',').map(&:to_i)
puts knot_hash(lengths)
