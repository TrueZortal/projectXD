# frozen_string_literal: true

require_relative 'position'

class Turn
  def initialize(game_instance)
    @game_instance = game_instance
    order = game_instance.players.shuffle
    puts @game_instance.board.render_board
    order.each do |player|
      puts "it's #{player.name}s move"
      if player.minions.empty?
        puts "type your prefered action:\n'summon' a minion\n'concede'"
        ans = gets.chomp.downcase
        case ans
        when 'summon'
          begin
            puts "which minion do you want to summon? available: 'skeleton'"
            minion = gets.chomp.downcase
            puts "which field do you want to place your minion? format 'x,y'"
            field = gets.split(',')
            @game_instance.place(owner: player.name, type: minion, x: field[0].to_i, y: field[1].to_i)
            puts "placed a #{minion} on #{field}"
            puts @game_instance.board.render_board
          rescue StandardError
            retry
          end
        when 'concede'
          puts 'you lose kek'
          player.mana = 0
          player.minions = []
        else
          puts 'nothing selected, please enter a valid command'
          redo
        end
      elsif !player.minions.empty?
        puts "type your prefered action:\n'summon' a minion\n'move' from a field to a field\n'attack' from a field to a field\n'concede'"
        ans = gets.chomp.downcase
        case ans
        when 'summon'
          begin
            puts "which minion do you want to summon? available: 'skeleton'"
            minion = gets.chomp.downcase
            puts "which field do you want to place your minion? format 'x,y'"
            field = gets.split(',')
            @game_instance.place(owner: player.name, type: minion, x: field[0].to_i, y: field[1].to_i)
            puts "placed a #{minion} on #{field}"
            puts @game_instance.board.render_board
          rescue StandardError
            retry
          end
        when 'move'
          begin
            puts "which field do you want start the movement? format 'x,y'"
            from = gets.split(',')
            from_field = Position.new(from[0].to_i, from[1].to_i)
            puts "which field do you want to move to? format 'x,y'"
            to = gets.split(',')
            to_field = Position.new(to[0].to_i, to[1].to_i)
            @game_instance.move(from_field, to_field)
            puts "moved from #{from_field.to_a} to #{to_field.to_a}"
            puts @game_instance.board.render_board
          rescue StandardError
            retry
          end
        when 'attack'
          begin
            puts "which field do you want to attack from? format 'x,y'"
            from = gets.split(',')
            from_field = Position.new(from[0].to_i, from[1].to_i)
            puts "which field do you want to attack? format 'x,y'"
            to = gets.split(',')
            to_field = Position.new(to[0].to_i, to[1].to_i)
            @game_instance.attack(from_field, to_field)
            puts "attacked from #{from_field.to_a} to #{to_field.to_a}"
            puts @game_instance.board.render_board
          rescue StandardError
            retry
          end
        when 'concede'
          puts 'you lose kek'
          player.mana = 0
          player.minions = []
          break
        else
          puts 'nothing selected, please enter a valid command'
          redo
        end
      end
    end
  end
end
