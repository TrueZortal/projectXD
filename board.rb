# frozen_string_literal: true

require_relative 'field'
require_relative 'minion'

class InvalidMovementError < StandardError
end

class OutOfRangeError < StandardError
end

class InvalidTargetError < StandardError
end

# working surface for board is @rowified_board
class Board
  attr_reader :array_of_fields, :rowified_board, :upper_limit

  def initialize(size_of_board_edge, uniform: true, starting_surface: 'grass')
    raise ArgumentError unless size_of_board_edge > 1

    @upper_limit = size_of_board_edge - 1
    @uniform = uniform
    @starting_surface = starting_surface
    generate_an_array_of_fields(size_of_board_edge)
    rowify_the_array_of_fields
  end

  def place(owner: '', type: '', x: nil, y: nil)
    raise ArgumentError unless x <= @upper_limit && y <= @upper_limit

    # check if owner has sufficient mana, return insufficient mana error

    @rowified_board[x][y].occupant = Minion.new(owner: owner, type: type, x: x, y: y)
  end

  def render_board
    # 'tree': '🌲',
    render_key = {
      'dirt': '🟫',
      'grass': '🟩'
    }
    rendered_board = String.new(encoding: 'UTF-8')
    @rowified_board.each_with_index do |row, index|
      row.each do |field|
        rendered_board << if field.is_occupied?
                            field.occupant.type.chr + field.occupant.owner
                          else
                            render_key[field.terrain.to_sym]
                          end
      end
      rendered_board << "\n" if index < @rowified_board.size - 1
    end
    rendered_board
  end

  def check_field(address_array)
    unless address_array.size == 2 && address_array.first <= @upper_limit && address_array.last <= @upper_limit
      raise ArgumentError
    end

    @rowified_board[address_array.first][address_array.last]
  end

  def move(from_position_array, to_position_array)
    raise InvalidMovementError unless distance(from_position_array,
                                               to_position_array) <= check_field(from_position_array).occupant.speed &&
                                      check_field(to_position_array).is_empty? && valid_position(from_position_array) && valid_position(to_position_array)

    check_field(to_position_array).occupant = check_field(from_position_array).occupant
    check_field(from_position_array).occupant = ''
  end

  def attack(from_position_array, to_position_array)
    raise OutOfRangeError unless distance(from_position_array,
                                          to_position_array) <= check_field(from_position_array).occupant.range

    raise InvalidTargetError unless check_field(to_position_array).is_occupied? && different_owners(
      from_position_array, to_position_array
    ) && valid_position(from_position_array) && valid_position(to_position_array)

    target_health = check_field(to_position_array).occupant.health
    target_defense = check_field(to_position_array).occupant.defense
    attacker_attack = check_field(from_position_array).occupant.attack

    damage = attacker_attack - target_defense > 1 ? attacker_attack - target_defense : 1

    check_field(to_position_array).occupant.health = target_health - damage

    perish_a_creature(to_position_array) if check_field(to_position_array).occupant.health <= 0
  end

  private

  # returns perished minion/creature for future logging purpose
  def perish_a_creature(position_array)
    minion = check_field(position_array).occupant
    check_field(position_array).occupant = ''

    minion
  end

  def different_owners(first_occupant_position_array, second_occupant_position_array)
    check_field(first_occupant_position_array).occupant.owner != check_field(second_occupant_position_array).occupant.owner
  end

  def valid_position(address_array)
    address_array.none? { |coordinate_value| coordinate_value > @upper_limit }
  end

  def distance(starting_field_array, end_field_array)
    Math.sqrt((end_field_array[0] - starting_field_array[0])**2 + (end_field_array[1] - starting_field_array[1])**2)
  end

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

# test_board = Board.new(5)
# test_board.place(owner: '1',type: 'skeleton', x: 1,y: 1)
# puts test_board.render_board
