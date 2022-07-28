# frozen_string_literal: true

class ManaPool
  attr_accessor :mana, :max

  def initialize(mana: 0)
    mana == String ? @max = mana.to_i : @max = mana
    @mana = @max
  end
end
