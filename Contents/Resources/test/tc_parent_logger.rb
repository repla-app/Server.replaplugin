#!/System/Library/Frameworks/Ruby.framework/Versions/2.3/usr/bin/ruby

require 'minitest/autorun'
require_relative 'lib/test_setup'
require Repla::Test::LOG_HELPER_FILE
require_relative '../lib/parent_logger'
require_relative '../lib/parent'

# Test parent logger class
class TestParentLoggerClass < Minitest::Test
  def test_url_from_line
    good_url = 'http://www.google.com'
    line_with_good_url = "Here is a URL #{good_url}"
    url = Repla::Server::ParentLogger.send(:url_from_line, line_with_good_url)
    assert_equal(good_url, url)

    local_url = 'http://127.0.0.1'
    line_with_local_url = "#{local_url} is a local URL"
    url = Repla::Server::ParentLogger.send(:url_from_line, line_with_local_url)
    assert_equal(local_url, url)

    line_with_no_url = 'This line doesn\'t have any URLs'
    url = Repla::Server::ParentLogger.send(:url_from_line, line_with_no_url)
    assert_nil(url)

    local_url_with_port = 'http://127.0.0.1:5000'
    line_with_local_url_with_port = "Here is a URL #{local_url_with_port}"
    url = Repla::Server::ParentLogger.send(:url_from_line,
                                           line_with_local_url_with_port)
    assert_equal(local_url_with_port, url)

    real_example_url = 'http://127.0.0.1:4000/'
    line_with_real_example_url = "Server address: #{real_example_url}"
    url = Repla::Server::ParentLogger.send(:url_from_line,
                                           line_with_real_example_url)
    assert_equal(real_example_url, url)
  end

  # Mock logger
  class MockLogger
    def error(text); end

    def info(text); end
  end
  # Mock view
  class MockView
    attr_reader :failed
    attr_reader :called
    def initialize
      @called = false
      @failed = false
    end

    def load_url(_url)
      @failed = true if @called
      @called = true
    end
  end

  def test_multiple_urls
    mock_view = MockView.new
    parent_logger = Repla::Server::ParentLogger.new(MockLogger.new, mock_view)
    real_example_url = 'http://127.0.0.1:4000/'
    line_with_real_example_url = "Server address: #{real_example_url}"
    parent_logger.process_output(line_with_real_example_url)
    assert(mock_view.called)
    local_url_with_port = 'http://127.0.0.1:5000'
    line_with_local_url_with_port = "Here is a URL #{local_url_with_port}"
    parent_logger.process_output(line_with_local_url_with_port)
    assert(!mock_view.failed)
  end
end

# Test logger
class TestLogger < Minitest::Test
  def setup
    @parent_logger = Repla::Server::ParentLogger.new
    @logger = @parent_logger.logger
    @logger.show
    @test_log_helper = Repla::Test::LogHelper.new(@logger.window_id,
                                                  @logger.view_id)
  end

  def teardown
    window = Repla::Window.new(@parent_logger.logger.window_id)
    window.close
  end

  def test_logging
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

# Test server
class TestServer < Minitest::Test
  def setup
    @parent_logger = Repla::Server::ParentLogger.new
    @parent_logger.logger.show
    @window = Repla::Window.new(@parent_logger.logger.window_id)
    @parent = Repla::Server::Parent.new(SERVER_COMMAND_PATH,
                                        TEST_SERVER_ENV,
                                        @parent_logger)
    Thread.new do
      @parent.run
    end
    sleep Repla::Test::TEST_PAUSE_TIME
  end

  def teardown
    @window.close
    @parent.stop
  end

  def test_server
    javascript = File.read(Repla::Test::TITLE_JAVASCRIPT_FILE)
    @window.load_url(Repla::Test::INDEX_HTML_URL)
    result = @window.do_javascript(javascript)
    assert_equal(result, Repla::Test::INDEX_HTML_TITLE)
  end
end

# Test server path
class TestServerPathAndArg < Minitest::Test
  def setup
    @parent_logger = Repla::Server::ParentLogger.new
    @parent_logger.logger.show
    @window = Repla::Window.new(@parent_logger.logger.window_id)
    @parent = Repla::Server::Parent.new(SERVER_COMMAND_ARG,
                                        TEST_SERVER_COMMAND_PATH_ENV,
                                        @parent_logger)
    Thread.new do
      @parent.run
    end
    sleep Repla::Test::TEST_PAUSE_TIME
  end

  def teardown
    @window.close
    @parent.stop
  end

  def test_server_path_and_arg
    javascript = File.read(Repla::Test::TITLE_JAVASCRIPT_FILE)

    @window.load_url(Repla::Test::INDEX_HTML_URL)
    result = @window.do_javascript(javascript)
    assert_equal(result, Repla::Test::INDEX_HTML_TITLE)
  end
end
