require 'minitest/autorun'
require_relative 'minion'
require_relative 'skeleton'

class MinionTest < Minitest::Test
  def test_can_create_a_new_minion_object_without_type
      skelly = Minion.new
      assert_equal 0, skelly.x
      assert_equal 0, skelly.y
      assert_equal 0, skelly.mana
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
    skelly = Minion.new(x: 7, y:1000)
    assert_equal 1000, skelly.y
  end

  def test_minion_can_be_assigned_an_owner
    skelly = Minion.new(owner: 'Mateusz')
    assert_equal 'Mateusz', skelly.owner
  end
end

class RaisedSkeletonTest < Minitest::Test
  def test_skeleton_can_be_placed_anywhere_if_not_connected_to_a_board
    skelly = RaisedSkeleton.new(x: 1, y: 666)
    assert_equal 666, skelly.y
  end

  def test_skeleton_has_correct_default_values_when_created
    # skip
    skelly = RaisedSkeleton.new(name: 'skeleton')
    skelly.place
    assert_equal 1, skelly.attack
    assert_equal 1, skelly.defense
    assert_equal 5, skelly.health
  end
end