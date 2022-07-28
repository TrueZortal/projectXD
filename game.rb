# frozen_string_literal: true

require_relative 'field'
require_relative 'minion'
require_relative 'board'
require_relative 'player'
require_relative 'battlelog'

class InvalidMovementError < StandardError
end

class OutOfRangeError < StandardError
end

class InvalidTargetError < StandardError
end

class UnknownPlayerError < StandardError
end

class DuplicatePlayerError < StandardError
end

class InsufficientManaError < StandardError
end

class Game
  attr_accessor :board, :players, :log

  def initialize(size_of_board)
    @board = Board.new(size_of_board)
    @log = BattleLog.new
    @players = []
  end

  def move(from_position, to_position)
    unless check_field(to_position).is_empty? && valid_position(from_position) && valid_position(to_position)
      raise InvalidMovementError
    end

    check_field(from_position).occupant.move(to_position)
    check_field(to_position).occupant = check_field(from_position).occupant
    check_field(from_position).occupant = ''
  end

  def attack(from_position, to_position)
    raise InvalidTargetError unless check_field(to_position).is_occupied? && different_owners(
      from_position, to_position
    ) && valid_position(from_position) && valid_position(to_position)

    attacker = check_field(from_position).occupant
    defender = check_field(to_position).occupant
    damage = attacker.attack_action(defender)

    perish_a_creature(to_position) if check_field(to_position).occupant.health <= 0

    @log.attack(attacker,defender,damage)
  end

  def add_player(player_name, max_mana: 0)
    raise DuplicatePlayerError unless @players.filter { |player| player.name == player_name }.empty?

    @players << Player.new(name: player_name, mana: max_mana)
  end

  def place(owner: '', type: '', x: nil, y: nil)
    raise UnknownPlayerError unless @players.map { |player| player = player.name }.include?(owner)

    raise InvalidPositionError unless x <= @board.upper_limit && y <= @board.upper_limit

    summoned_minion = Minion.new(owner: owner, type: type, x: x, y: y)
    minion_owner = @players.filter { |player| player.name == owner }.first
    raise InsufficientManaError unless minion_owner.mana >= summoned_minion.mana_cost

    minion_owner.mana -= summoned_minion.mana_cost
    @log.place(summoned_minion, minion_owner.mana)
    @board.state[x][y].occupant = summoned_minion
  end

  def start_a_two_player_game
    puts "enter P1 name"
    p1_name = gets
    puts "enter P1 maximum mana"
    p1_mana = gets.to_i
    add_player(p1_name, max_mana: p1_mana)
    puts "enter P2 name"
    p2_name = gets
    puts "enter P2 maximum mana"
    p2_mana = gets.to_i
    add_player(p2_name, max_mana: p2_mana)
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

# Game.new(8).start_a_two_player_game