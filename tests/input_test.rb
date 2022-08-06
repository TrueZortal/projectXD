# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../input'

class InputTest < Minitest::Test
  def test_input_defaults_to_gets_if_command_queue_is_empty
    value = 'command_input_thing_standardIO_thing'
    test_input = StringIO.new(value)
    assert_equal value, Input.new(input: test_input).standard_input
  end
end
