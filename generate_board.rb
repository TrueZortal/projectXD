require_relative 'field'

class InvalidMovementError < StandardError
end

class OutOfRangeError < StandardError
end

class InvalidTargetError < StandardError
end

class InvalidPositionError < StandardError
end

class GenerateBoard
  attr_accessor :rowified

  def initialize(size_of_board_edge, uniform, starting_surface)
    raise ArgumentError unless size_of_board_edge > 1

    @size_of_board_edge = size_of_board_edge
    @uniform = uniform
    @starting_surface = starting_surface
    generate_an_array_of_fields(size_of_board_edge)
    rowify_the_array_of_fields
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
    @rowified = []
    Math.sqrt(@array_of_fields.size).to_i.times do
      empty_column = []
      @rowified << empty_column
    end
    @array_of_fields.each do |field|
      @rowified[field.position.x] << field
    end
    @rowified
  end
end

