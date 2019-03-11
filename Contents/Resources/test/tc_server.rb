#!/usr/bin/env ruby

require 'minitest/autorun'
require_relative 'lib/test_setup'
require Repla::Test::LOG_HELPER_FILE

# Test server
class TestServer < Minitest::Test
  SERVER_FILE = File.expand_path(File.join(File.dirname(__FILE__),
                                           '../server.rb'))
  def test_server
    command = "#{Shellwords.escape(SERVER_FILE)} \"#{SERVER_PATH}\""\
      " #{Shellwords.escape(TEST_SERVER_ENV)}"
    `#{command}`
  end
end
