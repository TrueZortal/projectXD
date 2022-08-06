require 'minitest/autorun'
require_relative '../menu'

class MenuTest < Minitest::Test
  def test_a_new_game_can_be_started_and_ended_between_4_players
    list_of_test_inputs = ['PVP','4','8','cool','M','10','T','10','Z','10','Q','10','concede','concede','concede','concede','no']
    Menu.instance.command_queue.bulk_add(list_of_test_inputs)
    Menu.instance.display_menu
  end
end