# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../game'
require_relative '../minion'
require_relative '../field'

class GameTest < Minitest::Test
  def test_a_minion_can_be_placed_on_board
    # skip
    test_game = Game.new(3)
    skelly = test_game.board.place(type: 'skeleton', x: 1, y: 2)
    assert_equal 1, skelly.position.x
    assert_equal 2, skelly.position.y
    assert_equal skelly, test_game.board.check_field(Position.new(skelly.position.x, skelly.position.y)).occupant
  end

  def test_a_minion_cant_be_placed_out_of_bounds
    # skip
    test_game = Game.new(3)
    assert_raises(ArgumentError) do
      test_game.board.place(type: 'skeleton', x: 3, y: 2)
    end
  end

  def test_a_minion_that_was_placed_exists_on_the_board
    # skip
    test_game = Game.new(3)
    skelly = test_game.board.place(type: 'skeleton', x: 2, y: 2)
    test_field = Position.new(2, 2)
    assert_equal skelly, test_game.board.check_field(test_field).occupant
  end

  def test_a_minion_can_move_from_a_field_to_a_field_and_does_not_exist_in_two_places_at_once
    # skip
    test_game = Game.new(3)
    skelly = test_game.board.place(type: 'skeleton', x: 1, y: 1)
    target_field = Position.new(2, 2)
    test_game.move(skelly.position, target_field)
    assert_equal skelly, test_game.board.check_field(target_field).occupant
    assert_equal '', test_game.board.check_field(skelly.position).occupant
  end

  def test_a_minion_cannot_move_out_of_bounds
    # skip
    test_game = Game.new(3)
    skelly = test_game.board.place(type: 'skeleton', x: 0, y: 0)
    assert_raises(InvalidPositionError) do
      test_game.board.move(skelly.position, Position.new(-1, -1))
    end
  end

  def test_skeletons_can_only_move_1_square_in_every_direction
    # skip
    test_game = Game.new(3)
    skelly = test_game.board.place(type: 'skeleton', x: 0, y: 0)
    target_field = Position.new(2, 2)
    assert_raises(InvalidMovementError) do
      test_game.move(skelly.position, target_field)
    end
    target_field = Position.new(0, 2)
    assert_raises(InvalidMovementError) do
      test_game.move(skelly.position, target_field)
    end
    target_field = Position.new(1, 1)
    test_game.move(skelly.position, target_field)
    assert_equal skelly, test_game.board.check_field(target_field).occupant
  end

  def test_skeleton_cant_step_on_another_skeleton_or_move_to_an_occupied_square
    # skip
    test_game = Game.new(3)
    skelly = test_game.board.place(type: 'skeleton', x: 0, y: 0)
    skellys_estranged_cousin_timmy = test_game.board.place(type: 'skeleton', x: 0, y: 1)
    assert_raises(InvalidMovementError) do
      test_game.move(skelly.position, skellys_estranged_cousin_timmy.position)
    end
  end

  def test_skeleton_can_attack_within_1_square
    # skip
    test_game = Game.new(3)
    skelly = test_game.board.place(owner: 'P1', type: 'skeleton', x: 0, y: 0)
    skellys_sworn_enemy_kevin = test_game.board.place(type: 'skeleton', x: 0, y: 1)
    test_game.attack(skelly.position, skellys_sworn_enemy_kevin.position)
    assert_equal 4, test_game.board.check_field(skellys_sworn_enemy_kevin.position).occupant.health
  end

  def test_skeleton_cannot_attack_from_further_than_their_range
    # skip
    test_game = Game.new(3)
    skelly = test_game.board.place(type: 'skeleton', x: 0, y: 0)
    skellys_sworn_enemy_kevin = test_game.board.place(type: 'skeleton', x: 0, y: 2)
    assert_raises(OutOfRangeError) do
      test_game.attack(skelly.position, skellys_sworn_enemy_kevin.position)
    end
  end

  def test_skeleton_cant_attack_an_empty_field
    # skip
    test_game = Game.new(3)
    skelly = test_game.board.place(type: 'skeleton', x: 0, y: 0)
    suspicious_patch_of_grass = Position.new(0, 1)
    assert_raises(InvalidTargetError) do
      test_game.attack(skelly.position, suspicious_patch_of_grass)
    end
  end

  def test_skeleton_cant_attack_an_out_of_bound_field
    # skip
    test_game = Game.new(3)
    skelly = test_game.board.place(type: 'skeleton', x: 0, y: 0)
    assert_raises(InvalidPositionError) do
      test_game.board.attack(skelly.position, Position.new(0, -1))
    end
  end

  def test_minion_with_0_hp_perishes
    # skip
    test_game = Game.new(3)
    skelly = test_game.board.place(owner: 'P1', type: 'skeleton', x: 0, y: 0)
    skellys_sworn_enemy_kevin = test_game.board.place(type: 'skeleton', x: 0, y: 1)
    test_game.attack(skelly.position, skellys_sworn_enemy_kevin.position)
    test_game.attack(skelly.position, skellys_sworn_enemy_kevin.position)
    test_game.attack(skelly.position, skellys_sworn_enemy_kevin.position)
    test_game.attack(skelly.position, skellys_sworn_enemy_kevin.position)
    test_game.attack(skelly.position, skellys_sworn_enemy_kevin.position)
    assert_equal false, test_game.board.check_field(skellys_sworn_enemy_kevin.position).is_occupied?
  end
end
