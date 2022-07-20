# frozen_string_literal: true

class Field
  attr_accessor :status, :surface, :obstacle, :occupant
  attr_reader :x, :y

  def initialize(x: 0, y: 0, status: 'empty', occupant: '', surface: '', obstacle: '')
    @x = x
    @y = y
    @status = status
    @occupant = occupant
    @surface = surface
    @obstacle = obstacle
  end
end

