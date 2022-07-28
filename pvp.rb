# frozen_string_literal: true

require_relative 'game'
require_relative 'turn'

class PVP
  attr_accessor :game

  def initialize(players: 2)
    @game = Game.new(4)
    players.times do |index|
      puts "enter P#{index + 1} name"
      name = gets.chomp
      puts "enter P#{index + 1} maximum mana"
      mana = gets.chomp.to_i
      @game.add_player(name, max_mana: mana)
    end
    Turn.new(@game) while @game.players.filter { |player| player.mana.zero? && player.minions.empty? }.empty?
    winner = @game.players - @game.players.filter { |player| player.mana.zero? && player.minions.empty? }
    puts "#{winner[0].name} is victorious"
  end

  def get_input
    gets.chomp
  end
end

PVP.new
