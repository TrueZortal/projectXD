# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../board'
require_relative '../minion'
require_relative '../field'

class BoardTest < Minitest::Test
  def test_cant_create_a_board_without_an_argument
    assert_raises(ArgumentError) do
      Board.new
    end
  end

  def test_cant_create_a_board_smaller_than_2_x_2
    assert_raises(ArgumentError) do
      Board.new(1)
    end
  end

  def test_creates_a_custom_sized_board
    test = Board.new(5)
    assert_equal 25, test.array_of_fields.size
  end

  def test_correctly_renders_2_x_2_board
    test = Board.new(2)
    test_output = StringIO.new(test.render_board)
    value = "🟩🟩\n🟩🟩"
    assert_equal value, test_output.string
  end

  def test_board_gives_correct_limit
    test = Board.new(8)
    assert_equal 7, test.upper_limit
  end

  def test_a_minion_can_be_placed_on_board
    test = Board.new(3)
    skelly = test.place(type: 'skeleton', x: 1, y: 2)
    assert_equal 1, skelly.position.x
    assert_equal 2, skelly.position.y
    assert_equal skelly, test.rowified_board[1][2].occupant
  end

  def test_a_minion_cant_be_placed_out_of_bounds
    test_board = Board.new(3)
    assert_raises(ArgumentError) do
      test_board.place(type: 'skeleton', x: 3, y: 2)
    end
  end

  def test_a_minion_that_was_placed_exists_on_the_board
    test_board = Board.new(3)
    skelly = test_board.place(type: 'skeleton', x: 2, y: 2)
    test_field = Position.new(2,2)
    assert_equal skelly, test_board.check_field(test_field.to_a).occupant
  end

  def test_a_placed_minion_renders_with_its_first_letter_as_symbol_and_owner_name
    test_board = Board.new(2)
    skelly = test_board.place(owner: '1', type: 'skeleton', x: 1, y: 1)
    test_output = StringIO.new(test_board.render_board)
    value = "🟩🟩\n🟩s1"
    assert_equal value, test_output.string
  end

  def test_a_minion_can_move_from_a_field_to_a_field_and_does_not_exist_in_two_places_at_once
    test_board = Board.new(3)
    skelly = test_board.place(type: 'skeleton', x: 1, y: 1)
    target_field = Position.new(2,2)
    test_board.move(skelly.position.to_a, target_field.to_a)
    assert_equal skelly, test_board.check_field(target_field.to_a).occupant
    assert_equal '', test_board.check_field(skelly.position.to_a).occupant
  end

  def test_a_minion_cannot_move_out_of_bounds
    test_board = Board.new(3)
    skelly = test_board.place(type: 'skeleton', x: 0, y: 0)
    assert_raises(InvalidPositionError) do
      test_board.move(skelly.position.to_a, Position.new(-1,-1).to_a)
    end
  end

  def test_skeletons_can_only_move_1_square_in_every_direction
    test_board = Board.new(3)
    skelly = test_board.place(type: 'skeleton', x: 0, y: 0)
    target_field = Position.new(2,2)
    assert_raises(InvalidMovementError) do
      test_board.move(skelly.position.to_a, target_field.to_a)
    end
    target_field = Position.new(0,2)
    assert_raises(InvalidMovementError) do
      test_board.move(skelly.position.to_a, target_field.to_a)
    end
    target_field = Position.new(1,1)
    test_board.move(skelly.position.to_a, target_field.to_a)
    assert_equal skelly, test_board.check_field(target_field.to_a).occupant
  end

  def test_skeleton_cant_step_on_another_skeleton_or_move_to_an_occupied_square
    test_board = Board.new(3)
    skelly = test_board.place(type: 'skeleton', x: 0, y: 0)
    skellys_estranged_cousin_timmy = test_board.place(type: 'skeleton', x: 0, y: 1)
    assert_raises(InvalidMovementError) do
      test_board.move(skelly.position.to_a, skellys_estranged_cousin_timmy.position.to_a)
    end
  end

  def test_skeleton_can_attack_within_1_square
    test_board = Board.new(3)
    skelly = test_board.place(owner: 'P1',type: 'skeleton', x: 0, y: 0)
    skellys_sworn_enemy_kevin = test_board.place(type: 'skeleton', x: 0, y: 1)
    test_board.attack(skelly.position.to_a,skellys_sworn_enemy_kevin.position.to_a)
    assert_equal 4, test_board.check_field(skellys_sworn_enemy_kevin.position.to_a).occupant.health
  end

  def test_skeleton_cannot_attack_from_further_than_their_range
    test_board = Board.new(3)
    skelly = test_board.place(type: 'skeleton', x: 0, y: 0)
    skellys_sworn_enemy_kevin = test_board.place(type: 'skeleton', x: 0, y: 2)
    assert_raises (OutOfRangeError) do
      test_board.attack(skelly.position.to_a,skellys_sworn_enemy_kevin.position.to_a)
    end
  end

  def test_skeleton_cant_attack_an_empty_field
    test_board = Board.new(3)
    skelly = test_board.place(type: 'skeleton', x: 0, y: 0)
    suspicious_patch_of_grass = [0,1]
    assert_raises (InvalidTargetError) do
      test_board.attack(skelly.position.to_a,Position.new(0,1).to_a)
    end
  end

  def test_skeleton_cant_attack_an_out_of_bound_field
    test_board = Board.new(3)
    skelly = test_board.place(type: 'skeleton', x: 0, y: 0)
    assert_raises (InvalidPositionError) do
      test_board.attack(skelly.position.to_a,Position.new(0,-1).to_a)
    end
  end

  def test_minion_with_0_hp_perishes
    test_board = Board.new(3)
    skelly = test_board.place(owner: 'P1',type: 'skeleton', x: 0, y: 0)
    skellys_sworn_enemy_kevin = test_board.place(type: 'skeleton', x: 0, y: 1)
    test_board.attack(skelly.position.to_a,skellys_sworn_enemy_kevin.position.to_a)
    test_board.attack(skelly.position.to_a,skellys_sworn_enemy_kevin.position.to_a)
    test_board.attack(skelly.position.to_a,skellys_sworn_enemy_kevin.position.to_a)
    test_board.attack(skelly.position.to_a,skellys_sworn_enemy_kevin.position.to_a)
    test_board.attack(skelly.position.to_a,skellys_sworn_enemy_kevin.position.to_a)
    assert_equal false, test_board.check_field(skellys_sworn_enemy_kevin.position.to_a).is_occupied?
  end
end
