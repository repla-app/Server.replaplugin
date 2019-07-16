require_relative '../../bundle/bundler/setup'
require 'repla/test'
require 'repla/logger'
require 'Shellwords'

TEST_DATA_DIR = File.join(__dir__, '../data/')
PRINT_VARIABLE_PATH = File.expand_path(File.join(TEST_DATA_DIR,
                                                 'print_variable.sh'))
PRINT_VARIABLE_NO_ERROR_PATH = File.expand_path(File.join(TEST_DATA_DIR,
                                                          'print_variable_'\
                                                          'no_error.sh'))
SERVER_ROOT = Repla::Test::TEST_HTML_DIRECTORY
SERVER_PORT = 5000
SERVER_URL = 'http://127.0.0.1'.freeze
SERVER_COMMAND = 'server.sh'.freeze
SERVER_COMMAND_DEFAULT = 'server.sh -d'.freeze
SERVER_COMMAND_DEFAULT_ROOT = "#{SERVER_COMMAND} -d "\
  "-r #{Shellwords.escape(SERVER_ROOT)}".freeze
SERVER_COMMAND_DIR = TEST_DATA_DIR
SERVER_COMMAND_PATH = File.join(SERVER_COMMAND_DIR,
                                SERVER_COMMAND)
SERVER_COMMAND_DEFAULT_PATH = File.join(SERVER_COMMAND_DIR,
                                        SERVER_COMMAND_DEFAULT)
SERVER_COMMAND_REFRESH_PATH = File.join(SERVER_COMMAND_DIR,
                                        'server.rb')
SERVER_COMMAND_STRING = 'Server started at'.freeze
SERVER_COMMAND_OTHER_STRING = 'A different message'.freeze
TEST_DELAY_OPTIONS_ZERO = { delay: 0 }.freeze
TEST_DELAY_LENGTH_LONG = 1
TEST_DELAY_LENGTH_DEFAULT = 0.5
TEST_DELAY_OPTIONS_LONG = { delay: TEST_DELAY_LENGTH_LONG }.freeze
TEST_SERVER_COMMAND_PATH_ENV = "PATH=#{SERVER_COMMAND_DIR}:"\
  "#{ENV['PATH']}".freeze
TEST_SERVER_ENV = "SERVER_ROOT=#{SERVER_ROOT}".freeze
TEST_ENV_KEY = 'TEST_VARIABLE'.freeze
TEST_ENV_KEY_TWO = 'TEST_VARIABLE_TWO'.freeze
TEST_ENV_VALUE = 'A test string'.freeze
TEST_ENV_VALUE_TWO = 'A second test string'.freeze
TEST_ENV = "#{TEST_ENV_KEY}=#{TEST_ENV_VALUE}\n"\
  "#{TEST_ENV_KEY_TWO}=#{TEST_ENV_VALUE_TWO}\n".freeze
TEST_REAL_ENV = File.read(File.join(TEST_DATA_DIR, 'real_env.txt'))
TEST_REAL_VALUE = 'CHANGEDfd --type d --hidden --exclude .git'.freeze
TEST_ESCAPE_FILE = File.join(TEST_DATA_DIR,
                             'output_with_escapes.txt')
TEST_ESCAPE_FILE2 = File.join(TEST_DATA_DIR,
                              'output_with_escapes2.txt')

module Repla
  module Test
    # Helper
    module Helper
      def self.add_env(env)
        restore = {}
        env.each_line do |line|
          line.chomp!
          key, value = line.split('=', 2)
          restore[key] = ENV[key] if ENV.key?(key)
          ENV[key] = value
        end
        restore
      end

      def self.remove_env(env, restore = {})
        env.each_line do |line|
          line.chomp!
          key, _value = line.split('=', 2)
          ENV.delete(key)
          ENV[key] = restore[key] if restore.key?(key)
        end
      end
    end

    # Mock logger
    class MockLogger
      def error(text); end

      def info(text); end
    end

    # Mock view
    class MockView
      attr_reader :load_url_failed
      attr_reader :load_url_timestamp
      attr_reader :reload_timestamp
      def initialize
        @reload_called = false
        @load_url_called = false
        @load_url_failed = false
      end

      def load_url(_url, _options = {})
        @load_url_failed = true if load_url_called
        @load_url_timestamp = Time.now.to_i
      end

      def reload_reset
        @reload_timestamp = nil
      end

      def reload
        @reload_timestamp = Time.now.to_i
      end

      def load_url_called
        !@load_url_timestamp.nil?
      end

      def reload_called
        !@reload_timestamp.nil?
      end
    end
  end
end
