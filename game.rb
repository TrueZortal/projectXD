# frozen_string_literal: true

require_relative 'field'
require_relative 'minion'
require_relative 'board'
require_relative 'player'

class InvalidMovementError < StandardError
end

class OutOfRangeError < StandardError
end

class InvalidTargetError < StandardError
end

class UnknownPlayerError < StandardError
end

class Game
  attr_accessor :board, :players

  def initialize(size_of_board)
    @board = Board.new(size_of_board)
    @players = []
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

  def add_player(player_name, max_mana: 0)
    @players << Player.new(name: player_name, mana: max_mana)
  end

  def place(owner: '', type: '', x: nil, y: nil)
    raise UnknownPlayerError unless @players.map { |player| player = player.name }.include?(owner)

    raise InvalidPositionError unless x <= @board.upper_limit && y <= @board.upper_limit

    # check if owner has sufficient mana, return insufficient mana error

    @board.state[x][y].occupant = Minion.new(owner: owner, type: type, x: x, y: y)
  end

  private

  def check_field(position)
    @board.check_field(position)
  end

  def valid_position(position)
    @board.valid_position(position)
  end

  # returns perished minion/creature for future logging purpose
  def perish_a_creature(position)
    minion = check_field(position).occupant
    check_field(position).occupant = ''

    minion
  end

  def different_owners(first_occupant_position_array, second_occupant_position_array)
    check_field(first_occupant_position_array).occupant.owner != check_field(second_occupant_position_array).occupant.owner
  end
end
