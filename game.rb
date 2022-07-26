# frozen_string_literal: true

require_relative 'field'
require_relative 'minion'
require_relative 'board'

class InvalidMovementError < StandardError
end

class OutOfRangeError < StandardError
end

class InvalidTargetError < StandardError
end

# working surface for board is @rowified_board
class Game
  attr_accessor :board

  def initialize(size_of_board)
    @board = Board.new(size_of_board)
  end

  def move(from_position, to_position)
    raise InvalidMovementError unless from_position.distance(to_position) <= check_field(from_position).occupant.speed &&
    check_field(to_position).is_empty? && valid_position(from_position) && valid_position(to_position)

    check_field(to_position).occupant = check_field(from_position).occupant
    check_field(from_position).occupant = ''
  end

  def attack(from_position, to_position)
    raise OutOfRangeError unless from_position.distance(to_position) <= check_field(from_position).occupant.range

    raise InvalidTargetError unless check_field(to_position).is_occupied? && different_owners(
      from_position, to_position
    ) && valid_position(from_position) && valid_position(to_position)

    target_health = check_field(to_position).occupant.health
    target_defense = check_field(to_position).occupant.defense
    attacker_attack = check_field(from_position).occupant.attack

    damage = attacker_attack - target_defense > 1 ? attacker_attack - target_defense : 1

    check_field(to_position).occupant.health = target_health - damage

    perish_a_creature(to_position) if check_field(to_position).occupant.health <= 0
  end
  private

  def check_field(position)
    @board.check_field(position)
  end

  def valid_position(position)
    @board.valid_position(position)
  end

  # returns perished minion/creature for future logging purpose
  def perish_a_creature(position_array)
    minion = check_field(position_array).occupant
    check_field(position_array).occupant = ''

    minion
  end

  def different_owners(first_occupant_position_array, second_occupant_position_array)
    check_field(first_occupant_position_array).occupant.owner != check_field(second_occupant_position_array).occupant.owner
  end

end

# test_board = Board.new(5)
# test_board.place(owner: '1',type: 'skeleton', x: 1,y: 1)
# puts test_board.render_board
