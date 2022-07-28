# frozen_string_literal: true

require_relative 'manapool'

class Player
  attr_reader :name
  attr_accessor :manapool, :mana, :minions

  def initialize(name: '', mana: 0)
    @name = name
    @manapool = ManaPool.new(mana: mana) # tu tu tururu
    @mana = @manapool.mana
    @minions = []
  end
end
