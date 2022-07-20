# frozen_string_literal: true

require_relative 'field'

class Board
  attr_reader :array_of_fields

  def initialize(size_of_board_edge, starting_surface: 'grass')
    raise ArgumentError unless size_of_board_edge > 1

    @starting_surface = starting_surface
    generate_an_array_of_fields(size_of_board_edge)
  end

  def generate_an_array_of_fields(size_of_board_edge)
    @array_of_fields = []
    size_of_board_edge.times do |x|
      size_of_board_edge.times do |y|
        @array_of_fields << Field.new(x: x, y: y, surface: surface_selector)
      end
    end
    @array_of_fields
  end

  def surface_selector
    generation_key = {
      'grass': ['grass','road','tree'],
      'road': ['road','road','grass','tree'],
      'tree': ['grass','grass','tree']
    }
    if @array_of_fields.empty?
      @starting_surface
    else
      puts generation_key[@array_of_fields.last.surface]
    end
  end

  def rowify_the_hash_of_fields
    @rowified_board = []
    Math.sqrt(@array_of_fields.size).to_i.times do |row_index|
      row_index = []
      @rowified_board << row_index
    end

    @array_of_fields.each do |field|
      @rowified_board[field.x] << field
    end
  end

  def render_field
    rowify_the_hash_of_fields
    rendered_board = String.new(encoding: 'UTF-8')

    @rowified_board.each_with_index do |row, index|
      rendered_board << '|'
      row.each do |field|
        rendered_board << "#{field.surface}|"
      end

      rendered_board << "\n" if index < @rowified_board.size - 1
    end

    rendered_board
  end
end

tomato = Board.new(2)
puts tomato.render_field
