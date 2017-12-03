#############################################################################
# Returns the index of a "summed number spiral" for which the value of that #
# element is larger than the given input.                                   #
# ruby puzzle1.rb input                                                     #
#############################################################################

# Return the side length of a square with l layers
def side(l)
  1 + 2 * (l - 1)
end

# Return the area of a square with l layers
def area(l)
  side(l)**2
end

# Finds the layer for a given number n.
# Uses a naive algorithm so will be slow for large n!
def find_layer(n)
  l = 1
  l += 1 while area(l) < n
  l
end

# Computes the x and y coordinates for a given index.
def i_to_xy(i)
  l = find_layer(i)
  s = side(l)

  start = area(l - 1)
  tr = start + s - 1
  tl = tr + s - 1
  bl = tl + s - 1
  br = bl + s - 1

  if i < tr
    x = l - 1
    y = i - (tr + start) / 2
  elsif i < tl
    x = (tl + tr) / 2 - i
    y = l - 1
  elsif i < bl
    x = 1 - l
    y =  (bl + tl) / 2 - i
  else # Bottom
    x = i - (br + bl) / 2
    y = 1 - l
  end

  [x, y]
end

# Returns a list of neighbour coordinate pairs for a given coordinate pair.
def neighbours(x, y)
  [
    [x - 1, y    ],
    [x - 1, y + 1],
    [x    , y + 1],
    [x + 1, y + 1],
    [x + 1, y    ],
    [x + 1, y - 1],
    [x    , y - 1],
    [x - 1, y - 1]
  ]
end

# A mapping of coordinates to indices.
$cache = {
  [0, 0] => 1,
}

# Returns the sum of all neighbours that are in the cache.
def sum_neighbours(x, y)
  ns = neighbours(x, y)
  ns.sum { |n| $cache.fetch(n, 0) }
end

limit = ARGF.gets.to_i
(2..Float::INFINITY).each do |i|
  x, y = i_to_xy(i)
  s = sum_neighbours(x, y)
  $cache[[x, y]] = s

  if s > limit
    break
  end
end

puts $cache.size
