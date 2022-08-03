# frozen_string_literal: true

class InvalidPositionError < StandardError
end

class Position
  attr_accessor :x, :y, :to_a

  def initialize(x, y)
    raise InvalidPositionError if !x.nil? && x.negative? || !y.nil? && y.negative?

    @x = x
    @y = y
    @to_a = [x, y]
  end

  def ==(other)
    @x == other.x && @y == other.y
  end

  def distance(other_position)
    Math.sqrt((other_position.x - x)**2 + (other_position.y - y)**2)
  end

  def get_route_to(other_position)
    other_x = other_position.x
    other_y = other_position.y
    @coordinates_between = []
    @distance_between_x = @x - other_x
    @distance_between_y = @y - other_y
    mod = 1
    until @distance_between_x.zero? && @distance_between_y.zero?
      #to write a function that counts steps but grabs out modified target coordinates based on the change to the distances
    end
end

# Position.new(4, 4).get_route_to(Position.new(7, 4))
# Position.new(0,0).get_route_to(Position.new(3,0))
# p Position.new(0,0).distance(Position.new(1,2))
# p Position.new(0,0).get_route_to(Position.new(3,1))
# p Position.new(0,0).get_route_to(Position.new(4,5))

# until @distance_between_x.zero? && @distance_between_y.zero?
#   puts "before operation #{[@distance_between_x, @distance_between_y]}"
#   if mod > 10
#     break
#   elsif @distance_between_x > @distance_between_y
#     @coordinates_between << [0, mod]
#     @distance_between_y += mod
#     if @distance_between_x == @distance_between_y && [@distance_between_x,@distance_between_y] != [0,0]
#       inner_loop(mod)
#     end
#     mod += 1
#   elsif @distance_between_x < @distance_between_y
#     @coordinates_between << [mod, 0]
#     @distance_between_x += mod
#     if @distance_between_x == @distance_between_y && [@distance_between_x,@distance_between_y] != [0,0]
#       inner_loop(mod)
#     end
#     mod += 1
#   elsif @distance_between_x == @distance_between_y
#     @coordinates_between << [mod, mod]
#     @distance_between_x += mod
#     @distance_between_y += mod
#     mod += 1
#   end
#   puts "after operation #{[@distance_between_x, @distance_between_y]}"
# end
# p @coordinates_between.map { |array| array = [array[0] += @x, array[1] += @y] }
# end

# def inner_loop(mod)
# temp_mod = mod
#   until @distance_between_x == @x && @distance_between_y == @y
#     temp_mod += 1
#     @coordinates_between << [temp_mod, temp_mod]
#     @distance_between_x += mod
#     @distance_between_y += mod
#     # mod += 1
#   end
# end