###############################################################################
# Takes string and returns the 256 knot hash.                                 #
#                                                                             #
# To run: ruby puzzle2.rb input                                               #
###############################################################################

class CircularArray
  attr_reader :size, :a

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

module KnotHash
  MAGIC_BYTES = [17, 31, 73, 47, 23]
  private_constant :MAGIC_BYTES

  # Computes the 256 knot hash for a given string
  def self.hash(string)
    bytes = string.codepoints
    bytes += MAGIC_BYTES

    sh = sparse_hash(bytes)
    dh = dense_hash(sh)

    to_hex_string(dh)
  end

  # Computes a sparse 256 knot hash.
  def self.sparse_hash(bytes, rounds = 64)
    pos = 0
    skip = 0
    ca = CircularArray.new(Array(0..255))

    rounds.times do
      bytes.each do |b|
        ca.reverse!(pos, b)
        pos += b
        pos += skip
        skip += 1
      end
    end

    ca.a
  end
  private_class_method :sparse_hash

  # Computes a dense 16 hash from a sparse 256 hash
  def self.dense_hash(a256)
    # XOR blocks of 16 together...
    a256.each_slice(16).map do |a|
      a.inject { |acc, x| acc ^ x }
    end
  end
  private_class_method :dense_hash

  # Converts an array to a string in hexadecimal format.
  def self.to_hex_string(array)
    array.map { |x| sprintf("%02x", x) }.join
  end
  private_class_method :to_hex_string
end

s = ARGF.gets.chomp
puts KnotHash.hash(s)
