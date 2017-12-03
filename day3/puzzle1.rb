##########################################################
# Returns the distance to the center of a number spiral. #
# ruby puzzle1.rb input                                  #
##########################################################

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

# Computes the distance to the center for a number n.
def distance_to_center(n)
  l = find_layer(n)
  s = side(l)

  start = area(l - 1)
  tr = start + s - 1
  tl = tr + s - 1
  bl = tl + s - 1
  br = bl + s - 1

  middle = 
    if n < tr
      (tr + start) / 2
    elsif n < tl
      (tl + tr) / 2
    elsif n < bl
      (bl + tl) / 2
    else
      (br + bl) / 2
    end

  (n - middle).abs + (l - 1)
end

puts distance_to_center(ARGF.gets.to_i)
