# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../manapool'

class ManaPoolTest < Minitest::Test
  def test_can_create_a_new_instance_of_manapool
    test_pool = ManaPool.new
    assert_instance_of ManaPool, test_pool
  end

  def test_new_manapool_has_a_maximum_value
    test_pool = ManaPool.new(mana: 5)
    assert_equal 5, test_pool.max
  end

  def test_new_manapool_has_a_current_value
    test_pool = ManaPool.new(mana: 5)
    assert_equal 5, test_pool.mana
  end
end