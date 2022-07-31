# frozen_string_literal: true

# exlucded because they break auto testing
# require_relative 'pvp_test'
# require_relative 'turn_test'

require_relative 'board_test'
require_relative 'game_test'
require_relative 'minion_test'
require_relative 'field_test'
require_relative 'position_test'
require_relative 'render_board_test'
require_relative 'player_test'
require_relative 'manapool_test'
require_relative 'battlelog_test'
require_relative 'generate_board_test'
require 'minitest/autorun'

Dir.glob('**/*Test.rb')
