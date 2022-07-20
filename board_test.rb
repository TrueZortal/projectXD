# frozen_string_literal: true

require 'minitest/autorun'
require_relative 'board'

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
    value = "|grass|grass|\n|grass|grass|"
    assert_equal value, test_output.string
  end
end
