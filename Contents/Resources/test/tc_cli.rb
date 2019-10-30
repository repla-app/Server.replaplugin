#!/usr/bin/env ruby

require 'minitest/autorun'
require 'English'

require_relative 'lib/test_setup'
require_relative '../lib/validator'
require 'repla'
require Repla::Test::LOG_HELPER_FILE

# Test CLI
class TestCLI < Minitest::Test
  SYMLINK_DST = File.join(__dir__, 'repla')
  CLI_PATH_COMPONENT = 'Contents/Resources/Scripts/repla'.freeze
  PLUGIN_ROOT = File.join(__dir__, '../../../')
  def setup
    Repla.load_plugin(PLUGIN_ROOT)
    bundle_command = '/usr/bin/osascript -e \'POSIX path of '\
    '(path to application "Repla")\''
    app_bundle_path = `#{bundle_command}`
    app_bundle_path.chomp!
    symlink_src = File.join(app_bundle_path, CLI_PATH_COMPONENT)
    File.delete(SYMLINK_DST) if File.file?(SYMLINK_DST)
    File.symlink(symlink_src, SYMLINK_DST)
  end

  def teardown
    File.delete(SYMLINK_DST)
  end

  def test_invalid
    server_command = SERVER_COMMAND_DEFAULT_PATH
    flags = "-o \"#{TEST_FILE_INVALID}\""
    command = "#{SYMLINK_DST} server "\
      "#{Shellwords.escape(server_command)}"
    `#{command} #{flags}`
    window_id = nil
    Repla::Test.block_until do
      window_id = Repla::Test::Helper.window_id
      !window_id.nil?
    end
    refute_nil(window_id)
    window = Repla::Window.new(window_id)

    logger = Repla::Logger.new(window_id)
    logger.show
    test_log_helper = Repla::Test::LogHelper.new(logger.window_id,
                                                 logger.view_id)
    message = 'ERROR: The specified file doesn\'t exist.'.freeze
    last = nil
    Repla::Test.block_until do
      last = test_log_helper.last_log_message
      last == message
    end
    assert_equal(message, last)
    window.close
  end

  def test_cli
    server_command = "#{SERVER_COMMAND_DEFAULT_PATH} -r #{SERVER_ROOT}"
    command = "#{SYMLINK_DST} server "\
      "#{Shellwords.escape(server_command)}"
    `#{command}`
    window_id = nil
    Repla::Test.block_until do
      window_id = Repla::Test::Helper.window_id
      !window_id.nil?
    end
    refute_nil(window_id)
    window = Repla::Window.new(window_id)
    javascript = File.read(Repla::Test::TITLE_JAVASCRIPT_FILE)
    result = nil
    Repla::Test.block_until do
      result = window.do_javascript(javascript)
      result == Repla::Test::INDEX_HTML_TITLE
    end
    assert_equal(Repla::Test::INDEX_HTML_TITLE, result)
    window.close
  end

  def test_file
    server_command = "#{SERVER_COMMAND_DEFAULT_PATH} -r #{SERVER_ROOT}"
    flags = "-o \"#{TEST_FILE}\""
    command = "#{SYMLINK_DST} server "\
      "#{Shellwords.escape(server_command)}"
    Dir.chdir(Repla::Test::TEST_HTML_DIRECTORY) do
      `#{command} #{flags}`
    end
    window_id = nil
    Repla::Test.block_until do
      window_id = Repla::Test::Helper.window_id
      !window_id.nil?
    end
    refute_nil(window_id)
    window = Repla::Window.new(window_id)
    javascript = File.read(Repla::Test::TITLE_JAVASCRIPT_FILE)
    result = nil
    Repla::Test.block_until do
      result = window.do_javascript(javascript)
      result == Repla::Test::INDEXJQUERY_HTML_TITLE
    end
    assert_equal(Repla::Test::INDEXJQUERY_HTML_TITLE, result)
    window.close
  end

  def test_stdin
    server_command = 'cat'
    command = "#{SYMLINK_DST} server "\
      "#{Shellwords.escape(server_command)}"
    `#{command}`
    window_id = nil
    Repla::Test.block_until do
      window_id = Repla::Test::Helper.window_id
      !window_id.nil?
    end
    refute_nil(window_id)
    window = Repla::Window.new(window_id)

    # Setup Logger
    logger = Repla::Logger.new(window_id)
    logger.show
    test_log_helper = Repla::Test::LogHelper.new(logger.window_id,
                                                 logger.view_id)
    # Run Test
    message = 'a test string'
    window.read_from_standard_input("#{message}\n")
    last = nil
    Repla::Test.block_until do
      last = test_log_helper.last_log_message
      last == message
    end
    assert_equal(message, last)
    window.close
  end

  def test_refresh
    server_command = "#{SERVER_COMMAND_REFRESH_PATH} #{SERVER_ROOT}"
    flags = "-r \"#{SERVER_COMMAND_REFERSH_STRING}\""
    command = "#{SYMLINK_DST} server "\
      "#{Shellwords.escape(server_command)}"
    `#{command} #{flags}`
    window_id = nil
    Repla::Test.block_until do
      window_id = Repla::Test::Helper.window_id
      !window_id.nil?
    end
    refute_nil(window_id)
    window = Repla::Window.new(window_id)
    javascript = File.read(Repla::Test::TITLE_JAVASCRIPT_FILE)

    # Test original
    result = nil
    Repla::Test.block_until do
      result = window.do_javascript(javascript)
      result == Repla::Test::INDEX_HTML_TITLE
    end
    assert_equal(Repla::Test::INDEX_HTML_TITLE, result)

    # Change to jQuery
    window.read_from_standard_input("#{Repla::Test::INDEXJQUERY_HTML_FILENAME}\n")
    result = nil
    Repla::Test.block_until_with_timeout(Repla::Test::TEST_TIMEOUT_TIME * 2) do
      result = window.do_javascript(javascript)
      result == Repla::Test::INDEXJQUERY_HTML_TITLE
    end
    assert_equal(Repla::Test::INDEXJQUERY_HTML_TITLE, result)

    # Change it back
    window.read_from_standard_input("#{Repla::Test::INDEX_HTML_FILENAME}\n")
    result = nil
    Repla::Test.block_until_with_timeout(Repla::Test::TEST_TIMEOUT_TIME * 2) do
      result = window.do_javascript(javascript)
      result == Repla::Test::INDEX_HTML_TITLE
    end
    assert_equal(Repla::Test::INDEX_HTML_TITLE, result)

    window.close
  end
end
