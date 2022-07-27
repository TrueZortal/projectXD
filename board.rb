# frozen_string_literal: true

require_relative 'field'
require_relative 'render_board'

class InvalidMovementError < StandardError
end

class OutOfRangeError < StandardError
end

class InvalidTargetError < StandardError
end

class InvalidPositionError < StandardError
end

# working surface for board is @rowified_board
class Board
  attr_reader :array_of_fields, :upper_limit

  def initialize(size_of_board_edge, uniform: true, starting_surface: 'grass')
    raise ArgumentError unless size_of_board_edge > 1

    @upper_limit = size_of_board_edge - 1
    @uniform = uniform
    @starting_surface = starting_surface
    generate_an_array_of_fields(size_of_board_edge)
    rowify_the_array_of_fields
  end

  def render_board
    RenderBoard.render(@rowified_board)
  end

  def state
    @rowified_board
  end

  def check_field(position_object)
    unless position_object.to_a.size == 2 && position_object.to_a.first <= @upper_limit && position_object.to_a.last <= @upper_limit
      raise InvalidPositionError
    end

    @rowified_board[position_object.x][position_object.y]
  end

  def valid_position(position)
    position.to_a.none? { |coordinate_value| coordinate_value > @upper_limit }
  end

  private

  def generate_an_array_of_fields(size_of_board_edge)
    @array_of_fields = []
    size_of_board_edge.times do |x|
      size_of_board_edge.times do |y|
        chosen_terrain = terrain_selector
        @array_of_fields << Field.new(x: x, y: y, terrain: chosen_terrain, obstacle: is_an_obstacle?(chosen_terrain))
      end
    end
    @array_of_fields
  end

  def terrain_selector
    # 'rock': {'grass': 3,'rock': 1}
    generation_key = {
      'grass': { 'grass': 6, 'dirt': 1 },
      'dirt': { 'dirt': 2, 'grass': 1 }
    }

    if @array_of_fields.empty? || @uniform == true
      @starting_surface
    else
      field_pool = []
      generation_key[@array_of_fields.last.terrain.to_sym].map do |terrain, weight|
        weight.times { field_pool << terrain }
      end
      field_pool.sample
    end
  end

  def is_an_obstacle?(terrain)
    obstacles = [
      'tree'
    ]
    obstacles.include?(terrain)
  end

  def rowify_the_array_of_fields
    @rowified_board = []
    Math.sqrt(@array_of_fields.size).to_i.times do |row_index|
      row_index = []
      @rowified_board << row_index
    end
    @array_of_fields.each do |field|
      @rowified_board[field.position.x] << field
    end
  end
end
