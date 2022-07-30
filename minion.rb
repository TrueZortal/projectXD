# frozen_string_literal: true

# Speed/range thresholds
# 1 -> 1 straight, 0 diagonal,
# 1.5 -> 1 straight, 1 diagonal,
# 2 -> 2 straight, 1 diagonal,
# 2.83 -> 2 straight, 2 diagonal
# 3 -> 3 straight, 2 across
# 4.25 -> 3 straight, 3 across

require_relative 'position'

class InvalidMovementError < StandardError
end

class Minion
  # 🏹💀🐉
  @@MINION_DATA = {
    'skeleton': { mana_cost: 1, symbol: 's',health: 5, attack: 1, defense: 0, speed: 2, initiative: 3, range: 1.5 },
    'skeleton archer': { mana_cost: 2, symbol: 'a', health: 2, attack: 2, defense: 0, speed: 1, initiative: 3, range: 3 }
  }
  attr_accessor :attack, :defense, :health, :speed, :initiative, :range, :position
  attr_reader :mana_cost, :owner, :type, :current_health, :symbol

  def initialize(x: nil, y: nil, owner: '', type: 'skeleton')
    raise ArgumentError unless @@MINION_DATA.keys.include?(type.to_sym)

    @position = Position.new(x, y)
    @owner = owner
    @type = type
    @symbol = @@MINION_DATA[@type.to_sym][:symbol]
    @attack = @@MINION_DATA[@type.to_sym][:attack]
    @defense = @@MINION_DATA[@type.to_sym][:defense]
    @max_health = @@MINION_DATA[@type.to_sym][:health]
    @health = @max_health
    @current_health = "#{@health}/#{@max_health}"
    @speed = @@MINION_DATA[@type.to_sym][:speed]
    @initiative = @@MINION_DATA[@type.to_sym][:initiative]
    @range = @@MINION_DATA[@type.to_sym][:range]
    @mana_cost = @@MINION_DATA[@type.to_sym][:mana_cost]
  end

  def move(to_position)
    raise InvalidMovementError unless @position.distance(to_position) <= @speed

    @position = to_position
  end

  def attack_action(another_minion)
    raise OutOfRangeError unless @position.distance(another_minion.position) <= @range

    target_health = another_minion.health
    target_defense = another_minion.defense

    # damage calculation is currently attack - defense but no less than 1
    damage = @attack - target_defense > 1 ? @attack - target_defense : 1

    another_minion.take_damage(damage)
    damage
  end

  def take_damage(damage)
    @health -= damage
    @current_health = "#{@health}/#{@max_health}"
  end

  def status
    { pos: @position.to_a, type: @type, hp: @current_health, attack: @attack, defense: @defense }
  end
end
