###############################################################################
# Given the expression language described below, this program returns the     #
# number of non-ignored characters in garbage expressions.                    #
#                                                                             #
# Expression = Expression                                                     #
#            | Garbage (<Ignore|Value|Empty, Ignore|Value|Empty, ....>)       #
#            | Group   ({Expression1, Expression2, Expression3, ....})        #
#            | Ignore  (!Value)                                               #
#            | Value   (Value)                                                #
#            | Empty   ()                                                     #
#                                                                             #
# The score of an expression is the sum of all the groups in an expression.   #
# The score of a group is 1 + the score of all the groups in the group.       #
#                                                                             #
# To run: ruby puzzle1.rb input                                               #
###############################################################################

class Tokenizer
  attr_reader :sexpressions

  def initialize(istream)
    @istream = istream
    @sexpressions = tokenize
  end

  private

  def tokenize
    sub_expressions = []
    loop do
      c = @istream.getc

      case c
      when nil
        return sub_expressions
      when '}'
        return sub_expressions
      when '{'
        sub_expressions << [:GROUP, tokenize]
      when ','
        sub_expressions << [:GROUP_SEPARATOR, ',']
      when '!'
        sub_expressions << [:IGNORE, @istream.get_c]
      when '<'
        sub_expressions << [:GARBAGE, tokenize_garbage]
      else
        sub_expressions << [:VALUE, c]
      end
    end
  end

  def tokenize_garbage
    garbage = ''
    loop do
      c = @istream.getc

      case c
      when '>', nil
        return garbage
      when '!'
        garbage << '!' << @istream.getc
      else
        garbage << c
      end
    end
  end
end

# Recursively calculates the score of an sexpression.
def score_expressions(sexpressions, depth = 1)
  sexpressions.sum do |type, *sub_expressions|
    if type == :GROUP
      sub_expressions.sum(depth) { |se| score_expressions(se, depth + 1) }
    else
      0
    end
  end
end

# Count the total number of non-cancelled characters in garabage expressions.
def count_non_canceled_chars_in_garbage(sexpressions)
  sexpressions.sum do |type, *sub_expressions|
    case type
    when :GROUP
      sub_expressions.sum { |se| count_non_canceled_chars_in_garbage(se) }
    when :GARBAGE
      garbage = sub_expressions.pop
      garbage.gsub!(/!./, '')
      garbage.length
    else
      0
    end
  end
end

sexpressions = Tokenizer.new(ARGF).sexpressions
puts count_non_canceled_chars_in_garbage(sexpressions)
