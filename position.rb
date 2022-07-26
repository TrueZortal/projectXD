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
end
