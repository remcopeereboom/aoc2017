################################################################################
# Takes a step size from standard input and fills a circular buffer with       #
# sequential integers at the given step. Returns the value after the index of  #
# 0 after 50 million iterations (50_000_000).                                  #
#                                                                              #
# To run: ruby puzzle2.rb input                                                #
################################################################################

def find_value_after_0(step, iterations)
  pos             = 0
  pos_of_0        = 0
  val_of_after_0  = 0
  buffer_length   = 1

  # Fill the buffer...
  (1..iterations).each do |i|
    # Find the current position for this iteration.
    pos = (pos + step) % buffer_length

    # Keep track of the position of 0 and the value after it.
    val_of_after_0   = i if pos == pos_of_0
    pos_of_0        += 1 if pos < pos_of_0

    # Update the new current position and buffer length.
    pos             += 1
    buffer_length   += 1
  end

  val_of_after_0
end

step = ARGF.gets.to_i
iterations = 50_000_000
p find_value_after_0(step, iterations)
