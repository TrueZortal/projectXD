require 'minitest/autorun'
require_relative 'minion'

class MinionTest < Minitest::Test
  def test_can_create_a_new_minion_object_without_type_and_space
      skelly = Minion.new
      assert_nil skelly.x
      assert_nil skelly.y
  end

  def test_cant_create_a_new_minion_with_a_negative_coordinate_x
    assert_raises(ArgumentError) do
      skelly = Minion.new(x: -1)
    end
  end

  def test_cant_create_a_new_minion_with_a_negative_coordinate_y
    assert_raises(ArgumentError) do
      skelly = Minion.new(y: -1)
    end
  end

  def test_minion_can_be_placed_anywhere_if_not_connected_to_a_board
    skelly = Minion.new(x: 7, y: 1000)
    assert_equal 1000, skelly.y
  end

  def test_minion_can_be_assigned_an_owner
    skelly = Minion.new(owner: 'Mateusz')
    assert_equal 'Mateusz', skelly.owner
  end

  def test_a_skeleton_minion_has_correct_default_values_when_created
    # skip
    skelly = Minion.new(type: 'skeleton')
    assert_equal 1, skelly.attack
    assert_equal 1, skelly.defense
    assert_equal 5, skelly.health
    assert_equal 1.5, skelly.speed
  end

  def test_cant_create_a_minion_of_non_existent_type
    assert_raises(ArgumentError) do
      skelly = Minion.new(type: 'tomato')
    end
  end
end