# Disk
#
# Represents a rectangular grid of memory cells. Each cell can be eiter in use
# or free.
class Disk
  FREE = false
  private_constant :FREE
  USED = true
  private_constant :USED

  # Loads a disk from a state described by a hash.
  # @param key_string [String]
  # @param size [Integer] The size of the disk (square)
  # @return [Disk]
  def self.from_hash(key_string, size = 128)
    state = (0...size).map do |row|
      hash = KnotHash.hash(key_string + '-' + row.to_s)
      bits = to_bits(hash)
      bits.map { |b| b == '1' ? USED : FREE }
    end

    Disk.new(state)
  end

  # Takes a string of hexadecimals and converts it into an array of bits.
  # @param hex_string [String]
  # @return [Array<['0'|'1']>]
  def self.to_bits(hex_string)
    hex_string
      .each_char
      .map { |c| c.to_i(16) }
      .map { |i| format('%04b', i) }
      .join
      .chars
  end
  private_class_method :to_bits

  attr_reader :rows, :cols

  # Initializes a new disk with the given state.
  # @param state [Array<Array<['0'|'1']>>]
  def initialize(state)
    @state = state
    @rows = state.size
    @cols = state[0].size
  end

  # Is the square at given coordinates in use?
  # @return [boolean]
  def used?(row, col)
    @state[row][col] == USED
  end

  # Is the square at given coordinates free (unused)?
  # @return [boolean]
  def free?(row, col)
    @state[row][col] == FREE
  end

  # Returns the total number of squares in use.
  # @return [Integer]
  def used
    @state.sum do |row|
      row.count { |square| square == USED }
    end
  end

  # Returns the total number of free squares.
  # @return [Integer]
  def free
    @state.sum do |row|
      row.count { |square| square == FREE }
    end
  end

  # Returns the number of distinct regions (contiguous squares in use).
  # @return [Integer]
  def nr_of_regions
    ConnectedComponents.new(in_use_graph).count
  end

  private

  # Returns a graph of all the squares that are in use, with edges between
  # adjacent cells that are in use.
  # @return [Graph]
  def in_use_graph
    graph = Graph.new

    index_to_vertex = build_index
    index_to_vertex.each do |(vrow, vcol), v|
      neighbours_in_use(vrow, vcol)
        .map { |index| index_to_vertex[index] }
        .each { |w| graph.add_edge(v, w) }
    end

    graph
  end

  # Builds a mapping from [row, col] pairs to vertex ids.
  # @return [Hash<Array<[Integer, Integer]>:Integer>]
  def build_index
    index = {}
    count = 0
    (0...rows).each do |row|
      (0...cols).each do |col|
        next unless used?(row, col)
        index[[row, col]] = count
        count += 1
      end
    end

    index
  end

  # Returns all neighbours of the square [row, col] that are in use.
  # @return [Array<[Integer, Integer]>]
  def neighbours_in_use(row, col)
    neighbours = []

    neighbours << [row - 1, col] if row > 0 && used?(row - 1, col)
    neighbours << [row + 1, col] if row < @rows - 1 && used?(row + 1, col)
    neighbours << [row, col - 1] if col > 0 && used?(row, col - 1)
    neighbours << [row, col + 1] if col < @cols - 1 && used?(row, col + 1)

    neighbours
  end
end
