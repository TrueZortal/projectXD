# frozen_string_literal: true

require_relative 'position'

class Field
  attr_accessor :status, :terrain, :obstacle, :occupant
  attr_reader :position

  def initialize(x: 0, y: 0, status: 'empty', occupant: '', terrain: '', obstacle: '')
    @position = Position.new(x, y)
    @status = status
    @occupant = occupant
    @terrain = terrain
    @obstacle = obstacle
  end

  def is_occupied?
    @occupant != ''
  end

  def is_empty?
    @occupant == ''
  end
end
