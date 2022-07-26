require 'minitest/autorun'
require_relative '../render_board'
require_relative '../board'

class RenderBoardTest < Minitest::Test
  def test_correctly_renders_2_x_2_board
    test = Board.new(2)
    test_output = StringIO.new(test.render_board)
    value = "🟩🟩\n🟩🟩"
    assert_equal value, test_output.string
  end

  def test_a_placed_minion_renders_with_its_first_letter_as_symbol_and_owner_name
    test_board = Board.new(2)
    skelly = test_board.place(owner: '1', type: 'skeleton', x: 1, y: 1)
    test_output = StringIO.new(test_board.render_board)
    value = "🟩🟩\n🟩s1"
    assert_equal value, test_output.string
  end
end