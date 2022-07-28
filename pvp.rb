require_relative 'game'
require_relative 'turn'

class PVP
  attr_accessor :game

  def initialize(players: 2)
    @game = Game.new(4)
    players.times do |index|
      puts "enter P#{index+1} name"
      name = gets.chomp
      puts "enter P#{index+1} maximum mana"
      mana = gets.chomp.to_i
      @game.add_player(name, max_mana: mana)
    end
    until !@game.players.filter { |player| player.mana == 0 && player.minions.empty?}.empty?
      Turn.new(@game)
    end
    winner = @game.players - @game.players.filter { |player| player.mana == 0 && player.minions.empty?}
    puts "#{winner} is victorious"
  end

  def get_input
    gets.chomp
  end
end


PVP.new