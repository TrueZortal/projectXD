# frozen_string_literal: true

# Speed/range thresholds
# 1 -> 1 straight, 0 diagonal,
# 1.5 -> 1 straight, 1 diagonal,
# 2 -> 2 straight, 1 diagonal,
# 2.83 -> 2 straight, 2 diagonal

require_relative 'position'

class InvalidMovementError < StandardError
end

class Minion
  @@MINION_DATA = {
    'skeleton': { mana: 1, health: 5, attack: 1, defense: 0, speed: 1.5, initiative: 3, range: 1.5 }
  }
  attr_accessor :attack, :defense, :health, :speed, :initiative, :range, :position
  attr_reader :mana, :owner, :type

  def initialize(x: nil, y: nil, owner: '', type: 'skeleton')
    raise ArgumentError unless @@MINION_DATA.keys.include?(type.to_sym)

    @position = Position.new(x, y)
    @owner = owner
    @type = type
    @attack = @@MINION_DATA[@type.to_sym][:attack]
    @defense = @@MINION_DATA[@type.to_sym][:defense]
    @health = @@MINION_DATA[@type.to_sym][:health]
    @speed = @@MINION_DATA[@type.to_sym][:speed]
    @initiative = @@MINION_DATA[@type.to_sym][:initiative]
    @range = @@MINION_DATA[@type.to_sym][:range]
  end

  def move(to_position)
    raise InvalidMovementError unless @position.distance(to_position) <= @speed

    @position = to_position
  end

  def attack_action(another_minion)
    raise OutOfRangeError unless @position.distance(another_minion.position) <= @range

    target_health = another_minion.health
    target_defense = another_minion.defense

    #damage calculation is currently attack - defense but no less than 1
    damage = @attack - target_defense > 1 ? @attack - target_defense : 1

    another_minion.health = target_health - damage
  end
end
