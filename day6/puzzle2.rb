################################################################################
# Finds the length of a cycle.                                                 #
#                                                                              #
# To run: ruby puzzle1.rb input                                                #
################################################################################

class ReallocationCycleFinder
  attr_reader :states

  def initialize(banks)
    @banks = banks.dup
    @size = @banks.size
    @states = []
  end

  def find_cycle_length
    find_cycle_iterations
    @states = []
    find_cycle_iterations
  end

  private

  def to_s
    @banks.inspect
  end

  def find_cycle_iterations
    return @states.length unless @states.empty?
    i = 0

    until @states.include? @banks.hash
      store_state_hash
      allocate
      i += 1
    end

    i
  end

  def store_state_hash
    @states << @banks.hash
  end

  def allocate
    i = find_next_bank
    blocks = @banks[i]
    @banks[i] = 0

    while blocks > 0
      i = (i + 1) % @size
      @banks[i] += 1
      blocks -= 1
    end
  end

  def find_next_bank
    max_blocks = 0
    max_i = 0

    @banks.each_with_index do |blocks, i|
      if blocks > max_blocks
        max_blocks = blocks
        max_i = i
      end
    end

    max_i
  end
end

banks = ARGF.gets.split.map(&:to_i)
rcf = ReallocationCycleFinder.new(banks)
p rcf.find_cycle_length
