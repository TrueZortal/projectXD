# frozen_string_literal: true

class Field
  attr_accessor :status, :terrain, :obstacle, :occupant
  attr_reader :x, :y

  def initialize(x: 0, y: 0, status: 'empty', occupant: '', terrain: '', obstacle: '')
    @x = x
    @y = y
    @status = status
    @occupant = occupant
    @terrain = terrain
    @obstacle = obstacle
  end
end