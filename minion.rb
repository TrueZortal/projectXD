class Minion
  @@MINION_DATA = {
    'skeleton': {mana: 1, health: 5, attack: 1, defense: 1}
  }
  attr_accessor :x, :y, :attack, :defense, :health
  attr_reader :mana, :owner, :type

  def initialize(x: 0, y: 0, owner: '', type: 'skeleton')
    raise ArgumentError if x.negative? || y.negative? || !@@MINION_DATA.keys.include?(type.to_sym)

    @x = x
    @y = y
    @owner = owner
    @type = type
    @attack = @@MINION_DATA[@type.to_sym][:attack]
    @defense = @@MINION_DATA[@type.to_sym][:defense]
    @health = @@MINION_DATA[@type.to_sym][:health]

  end

  def move(x_y_coordinate_array)
  end
end


