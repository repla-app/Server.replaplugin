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
SERVER_COMMAND = 'server.sh'.freeze
SERVER_COMMAND_DEFAULT = 'server.sh -d'.freeze
SERVER_COMMAND_ROOT = "#{SERVER_COMMAND} "\
  "-r #{Shellwords.escape(SERVER_ROOT)}".freeze
SERVER_COMMAND_DIR = TEST_DATA_DIR
SERVER_COMMAND_PATH = File.join(SERVER_COMMAND_DIR,
                                SERVER_COMMAND)
SERVER_COMMAND_DEFAULT_PATH = File.join(SERVER_COMMAND_DIR,
                                        SERVER_COMMAND_DEFAULT)
SERVER_COMMAND_STRING = 'Server started at'.freeze
SERVER_COMMAND_OTHER_STRING = 'A different message'.freeze
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
      attr_reader :failed
      attr_reader :called
      def initialize
        @called = false
        @failed = false
      end

      def load_url(_url, _options = {})
        @failed = true if @called
        @called = true
      end
    end
  end
end
