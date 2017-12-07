###############################################################################
# Given a list of nodes, their weights and their immediate children, finds    #
# the root of the tower (tree).                                               #
#                                                                             #
# To run: ruby puzzle1.rb input                                               #
###############################################################################

require 'set'

# Could do topological sort to actually build the DAG, but we are only
# interested in the root, so no need. Just build a set of all nodes and keep a
# separate set of children. The disjunction of these should be a single
# element, the root.

programs = Set.new
children = Set.new
matcher = /^(?<name>[a-z]+)\s+\((?<weight>\d+)\)(\s+->\s+(?<children>.*))?$/
ARGF.each_line do |l|
  m = matcher.match(l)

  programs << m[:name]
  (m[:children] || '').split(', ').each { |c| children << c }
end
p "Tower root: #{(programs - children).first}"
