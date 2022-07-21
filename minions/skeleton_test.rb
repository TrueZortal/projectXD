require 'minitest/autorun'
require_relative 'skeleton'

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