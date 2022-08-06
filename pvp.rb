# frozen_string_literal: true

require_relative 'game'
require_relative 'turn'
require_relative 'input'

class PVP
  attr_accessor :game

  def initialize(players: 2, board_size: 8, uniform: false)
    @game = Game.new(board_size, uniform: false)
    @players = players
    populate_players
    show_boardstate
    gameplay_loop
    resolve_skirmish
  end

  private

  def populate_players
    @players.times do |index|
      puts "enter P#{index + 1} name"
      name = Input.get_raw
      puts "enter P#{index + 1} maximum mana"
      mana = Input.get.to_i
      @game.add_player(name, max_mana: mana)
    end
  end

  def resolve_skirmish
    winner = @game.remaining_players
    if winner.empty?
      puts "it's a draw. Would you like to see the combat log? yes/no"
      query_log_view
    elsif @game.there_can_be_only_one
      puts "#{winner[0].name} is victorious, would you like to see the combat log? yes/no" # save it in a file for later gloating"
    end
    query_log_view
  end

  def query_log_view
    log_query = Input.get
    case log_query
    when 'yes'
      puts @game.log.print
    when 'no'
      exit!
    else
      puts 'invalid entry please select yes/no'
      query_log_view
    end
  end

  def gameplay_loop
    Turn.new(@game) until @game.there_can_be_only_one
  end

  def show_boardstate
    puts @game.board.render_board
  end
end
