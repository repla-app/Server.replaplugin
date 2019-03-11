#!/usr/bin/env ruby

require 'minitest/autorun'
require_relative 'lib/test_setup'
require Repla::Test::LOG_HELPER_FILE

# Test server
class TestServer < Minitest::Test
  SERVER_FILE = File.expand_path(File.join(File.dirname(__FILE__),
                                           '../server.rb'))

  def setup
    # command = "#{Shellwords.escape(SERVER_FILE)} \"#{SERVER_PATH}\""\
    #   " #{Shellwords.escape(TEST_SERVER_ENV)}"
    @pid = spawn(SERVER_FILE, SERVER_PATH, TEST_SERVER_ENV)
    window_id = Repla::Test::Helper.window_id
    @window = Repla::Window.new(window_id)
  end

  def teardown
    Process.kill(:TERM, @pid)
    @window.close
  end

  def test_server
    javascript = File.read(Repla::Test::TITLE_JAVASCRIPT_FILE)
    @window.load_file(Repla::Test::INDEX_HTML_FILE)
    result = @window.do_javascript(javascript)
    assert_equal(result, Repla::Test::INDEX_HTML_TITLE)
  end
end
