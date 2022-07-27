# frozen_string_literal: true

require_relative 'board_test'
require_relative 'game_test'
require_relative 'minion_test'
require_relative 'field_test'
require_relative 'position_test'
require_relative 'render_board_test'
require_relative 'player_test'
require_relative 'mana_pool_test'
require 'minitest/autorun'

Dir.glob('**/*Test.rb')