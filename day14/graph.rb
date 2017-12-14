require 'set'

# Graph
#
# An undirected graph using an adjacency set representation.
#
# @!attribute v [r] The number of vertices in the graph.
#   @return [Integer]
# @!attribute w [r] The number of edges in the graph.
#   @return [Integer]
class Graph
  # Loads a graph from a stream.
  # @param istream [IO] Must be an input stream!
  # @return [Graph]
  def self.from(istream)
    graph = Graph.new
    istream.each_line do |l|
      v, adjacent = parse_line(l)
      adjacent.each { |w| graph.add_edge(v, w) }
    end

    graph
  end

  # Parses a line l for a vertex and it's adjacencies.
  # @param l [String]
  # @return [VertexID, Array<VertexID>]
  # @api private
  def self.parse_line(l)
    /(?<v>\d+) <-> (?<adjacent>.*)/ =~ l
    v = v.to_i
    adjacent = adjacent.split(', ').map(&:to_i)

    [v, adjacent]
  end
  private_class_method :parse_line

  attr_reader :v, :e

  # Initializes a new empty Graph.
  def initialize
    @v = 0
    @e = 0
    @edges = []
  end

  # Adds an edge between v and w.
  # Takes amortized constant time.
  # @param v [VertexID]
  # @param w [VertexID]
  # @return [self]
  def add_edge(v, w)
    return self if adjacent?(v, w)

    # Resizes the graph if necessary.
    initialize_upto(v)
    initialize_upto(w)

    @edges[v].add(w)
    @edges[w].add(v)

    @e += 1

    self
  end

  # Is there an edge between v and w?
  # @param v [VertexID]
  # @param w [VertexID]
  # @return [Boolean]
  def adjacent?(v, w)
    return false if v >= @v
    return false if w >= @v

    @edges[v].include?(w)
  end

  # Yields each vertex adjacent to v if a block is given. If no block is given,
  # returns an enumerator to do the same.
  # @param v [VertexID]
  # @return [self] if a block is given.
  # @return [Enumerator<:each_adjacent>] if no block is given.
  def each_adjacent(v, &block)
    unless block_given?
      return enum_for(:each_adjacent, v) { @edges[v]&.size || 0 }
    end

    @edges[v]&.each(&block)

    self
  end

  # Returns a multi-line string describing the graph.
  # This string can be parsed by Graph.from(istream) if converted to a stream.
  # @return [String]
  def to_s
    @edges
      .each_with_index
      .map { |edges, i| "#{i} <-> #{edges.to_a.join(', ')}" }
      .join("\n")
  end

  private

  # Expands the adjaceny list to include up to v vertices if the number of
  # vertices currently in the graph is to small.
  # @param v [VertexID]
  # @return [void]
  # @api private
  def initialize_upto(v)
    return if @v > v
    (@v..v).each { |i| @edges[i] = Set.new }
    @v = v + 1
  end
end
