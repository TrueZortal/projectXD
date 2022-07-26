require 'minitest/autorun'
require_relative '../position'

class PositionTest < Minitest::Test
  def test_can_create_a_new_position
    test_position = Position.new(2,3)
    assert_equal 2, test_position.x
    assert_equal 3, test_position.y
    assert_equal [2,3], test_position.position
  end

  def test_can_compare_if_two_positions_are_overlapping
    test_position = Position.new(2,3)
    other_position = Position.new(2,3)
    assert_equal true, test_position == other_position
  end
end