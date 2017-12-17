################################################################################
# Takes a step size from standard input and fills a circular buffer with       #
# sequential integers at the given step. Returns the value at index 2017       #
#                                                                              #
# To run: ruby puzzle1.rb input                                                #
################################################################################

def fill_buffer(step, iterations)
  buffer = [0]
  pos = 0

  (1..iterations).each do |i|
    pos = (pos + step) % buffer.length + 1
    buffer.insert(pos, i)
  end

  buffer
end

def find_value(step, iterations)
  buffer = fill_buffer(step, iterations)
  buffer[buffer.find_index(iterations) + 1]
end

step = ARGF.gets.to_i
iterations = 2017
p find_value(step, iterations)
