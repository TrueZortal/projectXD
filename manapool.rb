# frozen_string_literal: true

class ManaPool
  attr_accessor :mana, :max

  def initialize(mana: 0)
    @max = mana
    @mana = mana
  end
end
