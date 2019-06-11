#!/System/Library/Frameworks/Ruby.framework/Versions/2.3/usr/bin/ruby --disable-gems

require 'minitest/autorun'
require_relative 'lib/test_setup'
require Repla::Test::LOG_HELPER_FILE

SERVER_BUNDLE_COMMAND = File.expand_path(File.join(__dir__,
                                                   '../server.rb'))

# Test server
class TestServer < Minitest::Test
  def setup
    @restore = Repla::Test::Helper.add_env(TEST_SERVER_ENV)
    @pid = spawn(SERVER_BUNDLE_COMMAND, SERVER_COMMAND_DEFAULT_PATH)
    window_id = nil
    Repla::Test.block_until do
      window_id = Repla::Test::Helper.window_id
      !window_id.nil?
    end
    refute_nil(window_id)
    @window = Repla::Window.new(window_id)
  end

  def teardown
    Repla::Test::Helper.remove_env(TEST_SERVER_ENV, @restore)
    @window.close
    Process.kill(:INT, @pid)
  end

  def test_server
    javascript = File.read(Repla::Test::TITLE_JAVASCRIPT_FILE)
    result = nil
    Repla::Test.block_until do
      result = @window.do_javascript(javascript)
      result == Repla::Test::INDEX_HTML_TITLE
    end
    assert_equal(Repla::Test::INDEX_HTML_TITLE, result)
  end
end

# Test server without environment
class TestServerNoEnv < Minitest::Test
  def setup
    @pid = spawn(SERVER_BUNDLE_COMMAND,
                 SERVER_COMMAND_DEFAULT_PATH,
                 chdir: SERVER_ROOT)
    window_id = nil
    Repla::Test.block_until do
      window_id = Repla::Test::Helper.window_id
      !window_id.nil?
    end
    refute_nil(window_id)
    @window = Repla::Window.new(window_id)
  end

  def teardown
    @window.close
    Process.kill(:INT, @pid)
  end

  def test_server_no_env
    javascript = File.read(Repla::Test::TITLE_JAVASCRIPT_FILE)
    result = nil
    Repla::Test.block_until do
      result = @window.do_javascript(javascript)
      result == Repla::Test::INDEX_HTML_TITLE
    end
    assert_equal(Repla::Test::INDEX_HTML_TITLE, result)
  end
end

# Test server path and arg
class TestServerPathAndArg < Minitest::Test
  def setup
    @restore = Repla::Test::Helper.add_env(TEST_SERVER_COMMAND_PATH_ENV)
    @pid = spawn(SERVER_BUNDLE_COMMAND,
                 SERVER_COMMAND_DEFAULT_ROOT,
                 TEST_SERVER_COMMAND_PATH_ENV)
    window_id = nil
    Repla::Test.block_until do
      window_id = Repla::Test::Helper.window_id
      !window_id.nil?
    end
    refute_nil(window_id)
    @window = Repla::Window.new(window_id)
  end

  def teardown
    Repla::Test::Helper.remove_env(TEST_SERVER_COMMAND_PATH_ENV, @restore)
    @window.close
    Process.kill(:INT, @pid)
  end

  def test_server_path_and_arg
    javascript = File.read(Repla::Test::TITLE_JAVASCRIPT_FILE)
    result = nil
    Repla::Test.block_until do
      result = @window.do_javascript(javascript)
      result == Repla::Test::INDEX_HTML_TITLE
    end
    assert_equal(Repla::Test::INDEX_HTML_TITLE, result)
  end
end

# Test server string
class TestServerString < Minitest::Test
  def setup
    command = "#{SERVER_COMMAND_DEFAULT_PATH} "\
              '-u www.example.com '\
              "-m '#{SERVER_COMMAND_OTHER_STRING}'"
    argument = "-s #{SERVER_COMMAND_STRING}"
    @pid = spawn(SERVER_BUNDLE_COMMAND,
                 argument, command,
                 chdir: SERVER_ROOT)
    window_id = nil
    Repla::Test.block_until do
      window_id = Repla::Test::Helper.window_id
      !window_id.nil?
    end
    refute_nil(window_id)
    @window = Repla::Window.new(window_id)
  end

  def teardown
    @window.close
    Process.kill(:INT, @pid)
  end

  def test_server_string
    javascript = File.read(Repla::Test::TITLE_JAVASCRIPT_FILE)
    result = nil
    Repla::Test.block_until do
      result = @window.do_javascript(javascript)
      result == Repla::Test::INDEX_HTML_TITLE
    end
    assert_equal(Repla::Test::INDEX_HTML_TITLE, result)
  end
end

# Test server port
class TestServerPort < Minitest::Test
  def setup
    command = SERVER_COMMAND_PATH.to_s
    argument = "-p #{SERVER_PORT}"
    @pid = spawn(SERVER_BUNDLE_COMMAND,
                 argument, command,
                 chdir: SERVER_ROOT)
    window_id = nil
    Repla::Test.block_until do
      window_id = Repla::Test::Helper.window_id
      !window_id.nil?
    end
    refute_nil(window_id)
    @window = Repla::Window.new(window_id)
  end

  def teardown
    @window.close
    Process.kill(:INT, @pid)
  end

  def test_server_port
    javascript = File.read(Repla::Test::TITLE_JAVASCRIPT_FILE)
    result = nil
    Repla::Test.block_until do
      result = @window.do_javascript(javascript)
      result == Repla::Test::INDEX_HTML_TITLE
    end
    assert_equal(Repla::Test::INDEX_HTML_TITLE, result)
  end
end

# Test server URL
class TestServerURL < Minitest::Test
  def setup
    command = SERVER_COMMAND_PATH.to_s
    argument = "-u #{SERVER_URL}:#{SERVER_PORT}"
    @pid = spawn(SERVER_BUNDLE_COMMAND,
                 argument, command,
                 chdir: SERVER_ROOT)
    window_id = nil
    Repla::Test.block_until do
      window_id = Repla::Test::Helper.window_id
      !window_id.nil?
    end
    refute_nil(window_id)
    @window = Repla::Window.new(window_id)
  end

  def teardown
    @window.close
    Process.kill(:INT, @pid)
  end

  def test_server_url
    javascript = File.read(Repla::Test::TITLE_JAVASCRIPT_FILE)
    result = nil
    Repla::Test.block_until do
      result = @window.do_javascript(javascript)
      result == Repla::Test::INDEX_HTML_TITLE
    end
    assert_equal(Repla::Test::INDEX_HTML_TITLE, result)
  end
end

# Test server port URL string
class TestServerPortURLString < Minitest::Test
  def setup
    # Pass in the `-e` flag as a quick standard error test. Note that this
    # isn't really relevant right now because `PTY` merges `STDOUT` and
    # `STDERR`. But this might be relevant in the future.
    command = "#{SERVER_COMMAND_PATH} -e "\
              '-u www.example.com '
    arguments = ["-u #{SERVER_URL}",
                 "-p #{SERVER_PORT}",
                 "-s #{SERVER_COMMAND_STRING}"]
    @pid = spawn(SERVER_BUNDLE_COMMAND,
                 arguments[0], arguments[1], arguments[2], command,
                 chdir: SERVER_ROOT)
    window_id = nil
    Repla::Test.block_until do
      window_id = Repla::Test::Helper.window_id
      !window_id.nil?
    end
    refute_nil(window_id)
    @window = Repla::Window.new(window_id)
  end

  def teardown
    @window.close
    Process.kill(:INT, @pid)
  end

  def test_server_url
    javascript = File.read(Repla::Test::TITLE_JAVASCRIPT_FILE)
    result = nil
    Repla::Test.block_until do
      result = @window.do_javascript(javascript)
      result == Repla::Test::INDEX_HTML_TITLE
    end
    assert_equal(Repla::Test::INDEX_HTML_TITLE, result)
  end
end
