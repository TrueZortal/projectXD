# frozen_string_literal: true

require_relative 'field'

class Board
  attr_reader :array_of_fields

  def initialize(size_of_board_edge, uniform: true, starting_surface: 'grass')
    raise ArgumentError unless size_of_board_edge > 1

    @uniform = uniform
    @starting_surface = starting_surface
    generate_an_array_of_fields(size_of_board_edge)
  end

  def render_field
    # 'tree': '🌲',
    render_key = {
      'dirt': '🟫',
      'grass': '🟩'
    }
    rowify_the_array_of_fields
    rendered_board = String.new(encoding: 'UTF-8')

    @rowified_board.each_with_index do |row, index|
      row.each do |field|
        rendered_board << render_key[field.terrain.to_sym]
      end

      rendered_board << "\n" if index < @rowified_board.size - 1
    end

    rendered_board
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
    #'rock': {'grass': 3,'rock': 1}
    generation_key = {
      'grass': {'grass': 6,'dirt': 1},
      'dirt': {'dirt': 2,'grass': 1}
    }

    if @array_of_fields.empty? || @uniform == true
      return @starting_surface
    else
      field_pool = []
      generation_key[@array_of_fields.last.terrain.to_sym].map do |terrain, weight|
        weight.times {field_pool << terrain}
      end
      return field_pool.sample
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
      @rowified_board[field.x] << field
    end
  end


end

tomato = Board.new(8, uniform: false)
# tomato = Board.new(8, uniform: true ,starting_surface: 'grass')
puts tomato.render_field