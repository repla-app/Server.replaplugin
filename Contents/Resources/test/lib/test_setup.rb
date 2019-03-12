require_relative '../../bundle/bundler/setup'
require 'repla/test'
require 'Shellwords'

PRINT_VARIABLE_PATH = File.expand_path(File.join(File.dirname(__FILE__),
                                                 '../data/print_variable.sh'))
SERVER_ROOT = Repla::Test::TEST_HTML_DIRECTORY
SERVER_COMMAND = 'server.sh'.freeze
SERVER_COMMAND_ARG = "#{SERVER_COMMAND} "\
  "#{Shellwords.escape(SERVER_ROOT)}".freeze
SERVER_DIR = File.expand_path(File.join(File.dirname(__FILE__),
                                        '../data/'))
SERVER_PATH = File.join(SERVER_DIR,
                        SERVER_COMMAND)
TEST_SERVER_PATH_ENV = "PATH=\"#{SERVER_DIR}:$PATH\"".freeze
TEST_SERVER_ENV = "SERVER_ROOT=\"#{SERVER_ROOT}\"".freeze
TEST_ENV_KEY = 'TEST_VARIABLE'.freeze
TEST_ENV_KEY_TWO = 'TEST_VARIABLE_TWO'.freeze
TEST_ENV_VALUE = 'A test string'.freeze
TEST_ENV_VALUE_TWO = 'A second test string'.freeze
TEST_ENV = "#{TEST_ENV_KEY}=\"#{TEST_ENV_VALUE}\" "\
  "#{TEST_ENV_KEY_TWO}=\"#{TEST_ENV_VALUE_TWO}\"".freeze
