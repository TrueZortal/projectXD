# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../turn'

class TurnTest < Minitest::Test
  def test_can_create_a_turn
    test_turn = Turn.new
    assert_instance_of Turn, test_turn
  end

  def test_turn_can_have_a_starting_player; end
end
