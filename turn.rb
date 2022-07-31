# frozen_string_literal: true

require_relative 'position'

class Turn
  def initialize(game_instance)
    @game_instance = game_instance
    set_turn_order
    play_turn
  end

  private

  def play_turn
    @order.each do |player|
      puts "it's #{player.name}s move. #{player.status}"
      if player.minions.empty? && player.manapool.empty?
        break
      elsif player.manapool.empty?
        actions_if_player_has_no_mana_available(player)
      elsif player.minions.empty?
        actions_if_player_has_no_minions(player)
      elsif !player.minions.empty?
        actions_if_player_has_minions_available(player)
      end
    end
  end

  def actions_if_player_has_no_minions(player_instance_of_current_player)
    puts "type your prefered action:\n'summon' a minion\n'concede'"
    ans = gets.chomp.downcase
    case ans
    when 'summon'
      summon(player_instance_of_current_player)
    when 'concede'
      concede(player_instance_of_current_player)
    else
      puts 'nothing selected, please enter a valid command'
      actions_if_player_has_no_minions(player_instance_of_current_player)
    end
  end

  def actions_if_player_has_no_mana_available(player_instance_of_current_player)
    puts "type your prefered action:\n'move' from a field to a field\n'attack' from a field to a field\n'concede'"
    ans = gets.chomp.downcase
    case ans
    when 'move'
      move(player_instance_of_current_player)
    when 'attack'
      attack(player_instance_of_current_player)
    when 'concede'
      concede(player_instance_of_current_player)
    else
      puts 'nothing selected, please enter a valid command'
      actions_if_player_has_no_mana_available(player_instance_of_current_player)
    end
  end

  def actions_if_player_has_minions_available(player_instance_of_current_player)
    puts "type your prefered action:\n'summon' a minion\n'move' from a field to a field\n'attack' from a field to a field\n'concede'"
    ans = gets.chomp.downcase
    case ans
    when 'summon'
      summon(player_instance_of_current_player)
    when 'move'
      move(player_instance_of_current_player)
    when 'attack'
      attack(player_instance_of_current_player)
    when 'concede'
      concede(player_instance_of_current_player)
    else
      puts 'nothing selected, please enter a valid command'
      actions_if_player_has_minions_available(player_instance_of_current_player)
    end
  end

  def summon(player_instance_of_current_player)
    puts "which minion do you want to summon? available: #{player_instance_of_current_player.available_minions}\n#{@game_instance.board.zone_message(player_instance_of_current_player.summoning_zone)}"
    minion = get_input
    puts "which field do you want to place your minion? format 'x,y'"
    field = get_position
    @game_instance.place(owner: player_instance_of_current_player.name, type: minion, x: field[0].to_i,
                         y: field[1].to_i)
    print_last_log_message
    show_boardstate
  rescue StandardError
    retry
  end

  def attack(player_instance_of_current_player)
    puts 'which minion would you like to attack with? enter minion number to proceed'
    player_instance_of_current_player.print_selectable_hash_of_unliving_minions
    minion_number = get_input.to_i
    from_field = player_instance_of_current_player.get_position_from_minion_number(minion_number)
    puts "which field do you want to attack? format 'x,y'"
    to = get_position
    to_field = Position.new(to[0].to_i, to[1].to_i)
    @game_instance.attack(from_field, to_field)
    print_last_log_message
    show_boardstate
  rescue StandardError
    actions_if_player_has_minions_available(player_instance_of_current_player)
  end

  def move(player_instance_of_current_player)
    puts 'which minion would you like to move with? enter minion number to proceed'
    player_instance_of_current_player.print_selectable_hash_of_unliving_minions
    minion_number = get_input.to_i
    from_field = player_instance_of_current_player.get_position_from_minion_number(minion_number)
    puts "which field do you want to move to? format 'x,y'"
    to = get_position
    to_field = Position.new(to[0].to_i, to[1].to_i)
    @game_instance.move(from_field, to_field)
    print_last_log_message
    show_boardstate
  rescue StandardError
    actions_if_player_has_minions_available(player_instance_of_current_player)
  end

  def concede(player_instance_of_current_player)
    puts 'you lose kek'
    player_instance_of_current_player.mana = 0
    player_instance_of_current_player.minions = []
  end

  def print_last_log_message
    puts @game_instance.log.log.last
  end

  def get_position
    gets.chomp.split(',')
  end

  def get_input
    gets.chomp.downcase
  end

  def show_boardstate
    puts @game_instance.board.render_board
  end

  def set_turn_order
    @order = @game_instance.players.shuffle
  end
end
