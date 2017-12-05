################################################################################
# Takes a list of jump instructions and returns the runtime (in instructions)  #
# it takes for the program to finish.                                          #
#                                                                              #
# To run: ruby puzzle1.rb input                                                #
################################################################################

instructions = ARGF.map(&:to_i)

nr_of_jumps = 0
i = 0
until i < 0 || i >= instructions.length
  if instructions[i] >= 3
    instructions[i] -= 1
    i += instructions[i] + 1
  else
    instructions[i] += 1
    i += instructions[i] - 1
  end

  nr_of_jumps += 1
end

puts nr_of_jumps
