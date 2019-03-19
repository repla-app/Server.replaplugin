#!/System/Library/Frameworks/Ruby.framework/Versions/2.3/usr/bin/ruby

require 'minitest/autorun'
require_relative 'lib/test_setup'
require Repla::Test::LOG_HELPER_FILE

SERVER_BUNDLE_COMMAND = File.expand_path(File.join(File.dirname(__FILE__),
                                                   '../server.rb'))

# Test server
class TestServer < Minitest::Test
  def setup
    @pid = spawn(SERVER_BUNDLE_COMMAND, SERVER_COMMAND_PATH, TEST_SERVER_ENV)
    sleep Repla::Test::TEST_PAUSE_TIME
    window_id = Repla::Test::Helper.window_id
    refute_nil(window_id)
    @window = Repla::Window.new(window_id)
  end

  def teardown
    @window.close
    Process.kill(:INT, @pid)
  end

  def test_server
    javascript = File.read(Repla::Test::TITLE_JAVASCRIPT_FILE)
    @window.load_url(Repla::Test::INDEX_HTML_URL, should_clear_cache: true)
    result = @window.do_javascript(javascript)
    assert_equal(Repla::Test::INDEX_HTML_TITLE, result)
  end
end

# Test server without environment
class TestServerNoEnv < Minitest::Test
  def setup
    @pid = spawn(SERVER_BUNDLE_COMMAND,
                 SERVER_COMMAND_PATH,
                 chdir: SERVER_ROOT)
    sleep Repla::Test::TEST_PAUSE_TIME
    window_id = Repla::Test::Helper.window_id
    refute_nil(window_id)
    @window = Repla::Window.new(window_id)
  end

  def teardown
    @window.close
    Process.kill(:INT, @pid)
  end

  def test_server_no_env
    javascript = File.read(Repla::Test::TITLE_JAVASCRIPT_FILE)
    @window.load_url(Repla::Test::INDEX_HTML_URL, should_clear_cache: true)
    result = @window.do_javascript(javascript)
    assert_equal(result, Repla::Test::INDEX_HTML_TITLE)
  end
end

# Test server path and arg
class TestServerPathAndArg < Minitest::Test
  def setup
    @pid = spawn(SERVER_BUNDLE_COMMAND,
                 SERVER_COMMAND_ARG,
                 TEST_SERVER_COMMAND_PATH_ENV)
    sleep Repla::Test::TEST_PAUSE_TIME
    window_id = Repla::Test::Helper.window_id
    refute_nil(window_id)
    @window = Repla::Window.new(window_id)
  end

  def teardown
    @window.close
    Process.kill(:INT, @pid)
  end

  def test_server_path_and_arg
    javascript = File.read(Repla::Test::TITLE_JAVASCRIPT_FILE)
    @window.load_url(Repla::Test::INDEX_HTML_URL, should_clear_cache: true)
    result = @window.do_javascript(javascript)
    assert_equal(result, Repla::Test::INDEX_HTML_TITLE)
  end
end
