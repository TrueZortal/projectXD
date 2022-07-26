# Speed thresholds 1 -> 1 straight, 0 diagonal, 1.5 -> 1 straight, 1 diagonal, 2 -> 2 straight, 1 diagonal, 2.83 -> 2 straight, 2 diagonal

class Minion
  @@MINION_DATA = {
    'skeleton': {mana: 1, health: 5, attack: 1, defense: 1, speed: 1.5, initiative: 3}
  }
  attr_accessor :x, :y, :attack, :defense, :health, :speed, :initiative
  attr_reader :mana, :owner, :type

  def initialize(x: nil, y: nil, owner: '', type: 'skeleton')
    raise ArgumentError if !x.nil? && x.negative? || !y.nil? && y.negative? || !@@MINION_DATA.keys.include?(type.to_sym)

    @x = x
    @y = y
    @owner = owner
    @type = type
    @attack = @@MINION_DATA[@type.to_sym][:attack]
    @defense = @@MINION_DATA[@type.to_sym][:defense]
    @health = @@MINION_DATA[@type.to_sym][:health]
    @speed = @@MINION_DATA[@type.to_sym][:speed]
    @initiative = @@MINION_DATA[@type.to_sym][:initiative]
  end

end


