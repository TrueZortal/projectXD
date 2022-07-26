require_relative 'board_test'
require_relative 'minion_test'
require_relative 'field_test'
require_relative 'position_test'
require "minitest/autorun"

Dir.glob("**/*Test.rb")