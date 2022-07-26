class Position
  attr_accessor :x, :y, :position
  def initialize(x, y)
    @x = x
    @y = y
    @position = [x,y]
  end

  def ==(other_position)
    @x == other_position.x && @y == other_position.y
  end
end