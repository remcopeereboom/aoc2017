# ConnectedComponents
#
# Holds connected component information for an undirected graph.
#
# @!attribute count [r] The number of connected components in the graph.
#   @return [Integer]
class ConnectedComponents
  attr_reader :count

  # Finds the conncected components for the graph.
  # @param graph [Graph]
  def initialize(graph)
    @marked        = Array.new(graph.v)
    @component_ids = Array.new(graph.v)
    @size          = Array.new(graph.v, 0)
    @count         = 0

    (0...graph.v).each do |v|
      next if @marked[v]
      dfs(graph, v)
      @count += 1
    end
  end

  # Returns the id of the connected component that includes vertex v or -1 if
  # v is a not vertex in the graph.
  # @param v [VertexID]
  # @return [ComponentID]
  def component_id(v)
    @component_ids[v] || -1
  end

  # Returns the size of the connect component with the given ID or 0 if there
  # is no such component.
  # @param [ComponentID]
  # @return [Integer]
  def size(component)
    @size[component] || 0
  end

  def connected?(v, w)
    return false unless v >= 0 && v < @marked.size
    return false unless w >= 0 && w < @marked.size

    @component_ids[v] == @component_ids[w]
  end

  private

  # Recursively find all vertices connected to v.
  # @param graph [Graph]
  # @param v [VertexID]
  # @api private
  def dfs(graph, v)
    return if v >= graph.v

    @marked[v]        = true
    @component_ids[v] = @count
    @size[@count]    += 1

    graph
      .each_adjacent(v)
      .lazy.reject { |w| @marked[w] }
      .each { |w| dfs(graph, w) }
  end
end
