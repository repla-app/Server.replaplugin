#!/usr/bin/env ruby

require 'minitest/autorun'
require_relative '../bundle/bundler/setup'
require 'repla/test'
require Repla::Test::LOG_HELPER_FILE
require_relative 'lib/test_constants'
require_relative '../lib/parent_logger'

class TestParentLoggerClass < Minitest::Test
  def test_url_from_line
    good_url = 'http://www.google.com'
    line_with_good_url = "Here is a URL #{good_url}"
    url = Repla::ParentLogger.url_from_line(line_with_good_url)
    assert_equal(good_url, url)
    local_url = 'http://127.0.0.1'
    line_with_local_url = "#{local_url} is a local URL"
    url = Repla::ParentLogger.url_from_line(line_with_local_url)
    assert_equal(local_url, url)
    line_with_no_url = 'This line doesn\'t have any URLs'
    url = Repla::ParentLogger.url_from_line(line_with_no_url)
    assert_nil(url)
  end
end

# Test parent
class TestParentLogger < Minitest::Test
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
