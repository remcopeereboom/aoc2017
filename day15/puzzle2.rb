################################################################################
# Takes two lines of input, each with an integer describing the initial state  #
# of a generator. Runs a duel between both generators and returns the number   #
# of ties between them.                                                        #
#                                                                              #
# To run: ruby puzzle1.rb input                                                #
################################################################################

module Duel
  def self.generator(state, factor, divisor, multiple)
    Enumerator.new do |y|
      loop do
        state = (state * factor) % divisor
        y << state if state % multiple == 0
      end
    end
  end

  def self.judge(a, b, n = 5_000_000)
    low_order_bits_16 = 65_535 # 1111_1111_1111_1111_1111
    n.times.count do |i|
      a.next & low_order_bits_16 == b.next & low_order_bits_16
    end
  end
end

def self.initial_state_from(istream)
  ARGF.gets.chomp.match(/(\d+)/)[1].to_i
end

a_state = initial_state_from(ARGF)
b_state = initial_state_from(ARGF)
a_factor = 16807
b_factor = 48271
a_divisor = 2147483647
b_divisor = 2147483647
a_multiple = 4
b_multiple = 8

generator_a = Duel.generator(a_state, a_factor, a_divisor, a_multiple)
generator_b = Duel.generator(b_state, b_factor, b_divisor, b_multiple)

puts Duel.judge(generator_a, generator_b)
