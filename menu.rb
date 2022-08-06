# frozen_string_literal: true

require_relative 'pvp'
require_relative 'input'

class Menu
  def initialize
    display_menu
  end

  def display_menu
    puts 'Welcome to Ultimate Giga Master Super Summoner King'
    puts "PVP\nexit"
    menu_loop
  end

  def menu_loop
    ans = get_input
    case ans
    when 'pvp'
      start_pvp
    when 'exit'
      exit!
    else
      display_menu
    end
  end

  def start_pvp
    puts 'how many players will be playing?'
    players = get_input.to_i
    puts 'how big would you like the board?'
    board_size = get_input.to_i
    puts 'would you like a cool board or a boring one? cool/boring'
    board_type = get_input
    uniform = case uniform
              when 'boring'
                true
              else
                false
              end
    PVP.new(players: players, board_size: board_size, uniform: uniform)
  rescue StandardError
    puts 'game crashed, restarting'
    puts error.backtrace
    retry
  end

  def get_input
    Input.get
  end
end

Menu.new
