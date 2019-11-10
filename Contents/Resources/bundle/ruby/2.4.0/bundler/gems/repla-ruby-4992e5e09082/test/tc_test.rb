#!/usr/bin/env ruby

require 'minitest/autorun'

require_relative '../lib/repla/test'
require Repla::Test::HELPER_FILE

class TestReplaRunPlugin < Minitest::Test
  def test_window_id
    window_id = Repla::Test::Helper.window_id
    assert_nil(window_id)
  end
end
