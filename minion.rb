class Minion
  @@MINION_DATA = {
    'skeleton': {mana: 1, health: 5, attack: 1, defense: 1}
  }
  attr_accessor :x, :y
  attr_reader :mana, :owner

  def initialize(x: 0, y: 0, owner: '', name: '')
    raise ArgumentError if x.negative? || y.negative?

    @x = x
    @y = y
    @owner = owner
    @name = name
  end

  def move(x_y_coordinate_array)
  end
end


