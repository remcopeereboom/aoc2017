################################################################################
# Takes a map from standard input and prints out the number of steps taken.    #
#                                                                              #
# To run: ruby puzzle2.rb input                                                #
################################################################################

class PathFollower
  def initialize(map)
    @map = map
    @row = 0
    @col = @map[0].index('|')
    @dir = :down
  end

  def follow
    steps = 0

    until @dir == :stop
      move
      steps += 1

      c = @map[@row][@col]

      case c
      when /\+/
        turn
      when /[-|a-zA-Z]/
        # Do nothing
      else
        @dir = :stop
      end
    end

    puts steps
  end

  private

  def move
    case @dir
    when :up
      @row -= 1
    when :down
      @row += 1
    when :left
      @col -= 1
    when :right
      @col += 1
    end
  end

  def turn
    @dir = 
      case @dir
      when :up, :down
        if @map[@row][@col - 1] =~ /[-a-zA-Z]/
          :left
        elsif @map[@row][@col + 1] =~ /[-a-zA-Z]/
          :right
        else
          :stop
        end
      when :left, :right
        if @map[@row - 1][@col] =~ /[|a-zA-Z]/
          :up
        elsif @map[@row + 1][@col] =~ /[|a-zA-Z]/
          :down
        else
          :stop
        end
      else
        :stop
      end
  end
end

PathFollower.new(ARGF.readlines).follow
