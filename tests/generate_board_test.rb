# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../generate_board'

class GenerateBoardTest < Minitest::Test
  def test_cant_create_a_board_without_an_argument
    assert_raises(ArgumentError) do
      GenerateBoard.new
    end
  end

  def test_cant_create_a_board_smaller_than_2_x_2
    assert_raises(ArgumentError) do
      GenerateBoard.new(1)
    end
  end

  def test_creates_a_custom_sized_board
    test = GenerateBoard.new(5, true, 'grass')
    assert_equal 25, test.rowified.flatten.size
  end
end
