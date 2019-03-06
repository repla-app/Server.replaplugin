#!/usr/bin/env ruby

require 'minitest/autorun'
require_relative '../bundle/bundler/setup'
require 'repla/test'
require Repla::Test::LOG_HELPER_FILE

require_relative '../lib/parent_logger'

# Test parent
class TestParent < Minitest::Test
  def setup
    @parent_logger = Repla::ParentLogger.new
    @logger = @parent_logger.logger
    @test_log_helper = Repla::Test::LogHelper.new(@logger.window_id,
                                                  @logger.view_id)
  end

  def teardown
    window = Repla::Window.new(@parent_logger.logger.window_id)
    window.close
  end

  def test_parent_logger
    message = TEST_ENV_VALUE
    @parent_logger.process_output(TEST_ENV_VALUE)
    sleep Repla::Test::TEST_PAUSE_TIME
    test_message = test_log_helper.last_log_message
    assert_equal(message, test_message)
    test_class = test_log_helper.last_log_class
    assert_equal('message', test_class)
    @parent_logger.process_error(TEST_ENV_VALUE_TWO)
  end
end
