#!/usr/bin/env ruby

require 'minitest/autorun'
require_relative '../bundle/bundler/setup'
require 'repla/test'
require Repla::Test::LOG_HELPER_FILE
require_relative 'lib/test_constants'
require_relative '../lib/parent_logger'

# Test parent
class TestParent < Minitest::Test
  def setup
    @parent_logger = Repla::ParentLogger.new
    @logger = @parent_logger.logger
    @logger.show
    @test_log_helper = Repla::Test::LogHelper.new(@logger.window_id,
                                                  @logger.view_id)
  end

  def teardown
    window = Repla::Window.new(@parent_logger.logger.window_id)
    window.close
  end

  def test_parent_logger
    # Message
    message = TEST_ENV_VALUE
    @parent_logger.process_output(message)
    sleep Repla::Test::TEST_PAUSE_TIME
    last = @test_log_helper.last_log_message
    assert_equal(message, last)
    test_class = @test_log_helper.last_log_class
    assert_equal('message', test_class)

    # Error
    error = TEST_ENV_VALUE_TWO
    refute_equal(message, error)
    @parent_logger.process_error(error)
    sleep Repla::Test::TEST_PAUSE_TIME
    last = @test_log_helper.last_log_message
    assert_equal(error, last)
    test_class = @test_log_helper.last_log_class
    assert_equal('error', test_class)
  end
end
