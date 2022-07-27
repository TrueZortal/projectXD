class Player
  attr_reader :name, :manapool
  def initialize(name: '', mana: 0)
    @name = name
    @manapool = ManaPool.new(mana: mana) #tu tu tururu
  end

  def mana
    @manapool.mana
  end
end