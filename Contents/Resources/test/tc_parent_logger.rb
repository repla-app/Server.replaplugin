#!/usr/bin/env ruby

require 'minitest/autorun'
require_relative '../lib/parent_logger'

# Test parent
class TestParent < Minitest::Test
  def setup
    @parent_logger = Repla::ParentLogger.new
  end

  def teardown
    window = Repla::Window.now(@parent_logger.logger.window_id)
    window.close
  end

  def test_parent_logger
    @parent_logger.process_output(TEST_ENV_VALUE)
    @parent_logger.process_error(TEST_ENV_VALUE_TWO)
  end
end
