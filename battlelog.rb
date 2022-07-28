# frozen_string_literal: true

class BattleLog
  attr_accessor :log, :time

  def initialize
    @time = Time.now
    @log = []
  end

  def add(log_event)
    @log << log_event
  end

  def place(unit, mana_after_placing)
    @log << "#{unit.owner} placed #{unit.type} on #{unit.position.to_a} for #{unit.mana_cost} mana, they have #{mana_after_placing} mana remaining. Health:#{unit.health}, Attack:#{unit.attack}, Defense:#{unit.defense}, Speed:#{unit.speed}"
  end

  def move(unit, to_position)
    @log << "#{unit.owner} moved #{unit.type} from #{unit.position.to_a} to #{to_position.to_a}"
  end

  def attack(unit, another_unit, damage)
    message = another_unit.health - damage >= 0 ? "is at #{another_unit.health} health" : 'perished'
    @log << "#{unit.owner} attacked #{another_unit.owner}s #{another_unit.type} with their #{unit.type} from #{unit.position.to_a} to #{another_unit.position.to_a} causing #{damage} damage. #{another_unit.owner}s #{another_unit.type} #{message}"
  end

  def print
    output = String.new("**#{@time.utc} BattleLog**\n", encoding: 'UTF-8')
    @log.each_with_index do |event, index|
      output << "TURN #{index + 1}:#{event}\n"
    end
    output << '------------'
    output
  end
end
