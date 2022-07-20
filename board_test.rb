# frozen_string_literal: true

require 'minitest/autorun'
require_relative 'board'
require_relative 'field'

class FieldTest < Minitest::Test
  def test_can_create_a_new_field_with_default_values
    test = Field.new
    assert_equal 0, test.x
    assert_equal 0, test.y
    assert_equal 'empty', test.status
    assert_equal '', test.terrain
    assert_equal '', test.occupant
    assert_equal '', test.obstacle
  end

  def test_can_create_a_new_field_with_custom_coordinates
    test = Field.new(x: 3, y: 4)
    assert_equal 3, test.x
    assert_equal 4, test.y
  end
end

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
    test_output = StringIO.new(test.render_field)
    value = "🟩🟩\n🟩🟩"
    assert_equal value, test_output.string
  end

  def test_board_gives_correct_limit
    test = Board.new(8)
    assert_equal 7, test.upper_limit
  end
end

