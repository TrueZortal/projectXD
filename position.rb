class InvalidPositionError < StandardError
end

class Position
  attr_accessor :x, :y, :to_a
  def initialize(x, y)
    raise InvalidPositionError if !x.nil? && x.negative? || !y.nil? && y.negative?

    @x = x
    @y = y
    @to_a = [x,y]
  end

  def ==(other_position)
    @x == other_position.x && @y == other_position.y
  end


end