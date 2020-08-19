#!/usr/bin/env ruby

require 'minitest/autorun'
require_relative 'lib/test_setup'
require_relative '../lib/config'

# Test config
class TestConfig < Minitest::Test
  def test_config
    options = TEST_DELAY_OPTIONS_ZERO.dup
    refresh_string = 'refresh string'
    options[:refresh_string] = refresh_string
    options[:file_refresh] = true
    config = Repla::Server::Config.new(options)
    assert_equal(config.refresh_string, refresh_string)
    assert(config.file_refresh)
  end
end
