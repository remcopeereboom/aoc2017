################################################################################
# Loads a tree from input, where each node has a weight. Finds an imbalance in #
# the tree where a nodes children have unequal weights.                        #
#                                                                              #
# To run: ruby puzzle2.rb input                                                #
################################################################################

# A directed tree
class Tree
  # Parser to build trees from the specified input files.
  #
  # The format should be:
  # node (weight)
  # node (weight) -> child1, child2, child3
  # node (weight) -> child1
  # node (weight)
  # node (weight) -> child1, child2
  module Parser
    MATCHER = /^(?<name>[a-z]+)\s+\((?<weight>\d+)\)(\s+->\s+(?<children>.*))?$/
    private_constant :MATCHER

    # Parses the input file and returns a tree.
    def self.parse(istream)
      data = istream.each_line.map do |l|
        m = MATCHER.match(l)

        name     = m[:name].to_sym
        weight   = m[:weight].to_i
        children = (m[:children] || '').split(', ').map!(&:to_sym)

        [name, weight, children]
      end

      Tree.new(data)
    end
  end

  include Parser

  attr_reader :v, :e

  # Initializes a new Tree.
  # Takes a bunch of nodes, reorganizes that data to allow for log time ops.
  def initialize(nodes)
    @v = nodes.size
    @e = 0

    @weights = {}
    nodes.each { |v, weight, _| @weights[v] = weight.to_i }

    @in_degrees = {}
    nodes.each { |v, _, _| @in_degrees[v] = 0 }

    @adjacencies = {}
    nodes.each { |v, _, _| @adjacencies[v] = [] }
    nodes.each do |v, _, children|
      children.each { |w| add_edge(v, w) }
    end

    @total_weights = {}
    total_weight(root) # Force computation
  end

  # Yields each vertex in the tree and then returns self.
  def each(&block)
    return enum_for(:each) { v } unless block_given?

    @weights.each_key(&block)

    self
  end

  # Returns an enumerable of all verticex IDs adjacent to v.
  def adjacent(v, &block)
    return enum_for(:adjacent, v) { @adjacencies[v].size } unless block_given?
    @adjacencies[v].each(&block)
  end

  # Returns the out degree of v.
  def out_degree(v)
    @adjacencies[v].size
  end

  # Returns the in degree of v.
  def in_degree(v)
    @in_degrees[v]
  end

  # Returns the root of the tree.
  def root
    @root ||= @in_degrees.find { |v, d| d == 0 }.first
  end

  # Returns the weight of vertex v.
  def weight(v)
    @weights[v]
  end

  # Returns the weight of the subtree rooted at v.
  def total_weight(v)
    @total_weights[v] ||= @weights[v] + adjacent(v).sum { |w| total_weight(w) }
  end

  private

  # Adds an edge from v (parent) to w (child).
  def add_edge(v, w)
    @adjacencies[v] << w

    @in_degrees[w] += 1
    @e += 1
  end
end

class UnbalanceFinder
  # Initialize for a new unbalanced tree.
  def initialize(unbalanced_tree)
    @tree = unbalanced_tree
  end

  # Finds the deepest node with unbalanced children.
  def deepest_unbalanced_parent
    unbalanced_parents.last
  end

  # Finds all nodes that have unbalanced children.
  def unbalanced_parents
    unbalanced_parents = []
    stack = [@tree.root]
    while v = stack.pop
      ws = @tree.adjacent(v).map { |w| @tree.total_weight(w) }
      next if ws.each_cons(2).all? { |a, b| a == b }

      unbalanced_parents << v
      @tree.adjacent(v) { |w| stack << w }
    end

    unbalanced_parents
  end

  # Finds the child of a parent node that has an unbalanced weight.
  def unbalanced_child(parent)
    ws = @tree.adjacent(parent).map { |w| @tree.total_weight(w) }
    @tree.adjacent(parent).find { |w| ws.count(@tree.total_weight(w)) == 1 } 
  end

  # Returns the difference in weight a child needs to balance its parent.
  def weight_diff(parent, child)
    current_weight = @tree.total_weight(child)
    desired_weight =
      @tree.adjacent(parent)
        .map { |w| @tree.total_weight(w) }
        .find { |w| w != current_weight }

    desired_weight - current_weight
  end
end

# Setup the tree and finder.
tree = Tree::Parser.parse(ARGF)
uf = UnbalanceFinder.new(tree)

# Find the nodes of interest
up = uf.deepest_unbalanced_parent
uc = uf.unbalanced_child(up)

# Calculate the weights
dw = uf.weight_diff(up, uc)
actual_weight = tree.weight(uc)
desired_weight = actual_weight + dw

# Print output
puts "The node '#{uc}' unbalances its parent '#{up}'"
puts "Need to add '#{dw}' to '#{uc}'s weight of #{actual_weight}" \
  " to achieve the balanced weight of #{desired_weight}."
