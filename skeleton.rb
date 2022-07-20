require_relative 'minion'

class RaisedSkeleton < Minion
  attr_accessor :attack, :defense, :health

  def place(x: @x, y: @y)
    @mana = 1
    @attack = @@MINION_DATA[@name.to_sym][:attack]
    @defense = @@MINION_DATA[@name.to_sym][:defense]
    @health = @@MINION_DATA[@name.to_sym][:health]
  end
end

