# frozen_string_literal: true

require_relative 'manapool'

class Player
  attr_reader :name
  attr_accessor :manapool, :mana, :minions, :available_minions

  def initialize(name: '', mana: 0)
    @name = name
    @manapool = ManaPool.new(mana: mana) # tu tu tururu
    @mana = @manapool.mana
    @minions = []
    @available_minions = ['skeleton', 'skeleton archer']
  end

  def status
    status = "\nMana:#{manapool.current} \nCurrent Minions:#{minion_list}"
  end

  def add_minion(minion_instance)
    @mana = @manapool.mana
    @minions << minion_instance
  end

  private

  def minion_list
    newline_list = +''
    if @minions.empty?
      newline_list = ' none'
    else
      @minions.each do |minion|
        newline_list << "\n#{minion.type} - hp:#{minion.current_health} - #{minion.position.to_a}"
      end
    end
    newline_list
  end
end
