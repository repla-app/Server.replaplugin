require_relative '../../bundle/bundler/setup'
require 'repla/test'
require 'Shellwords'

TEST_DATA_DIR = File.join(__dir__, '../data/')
PRINT_VARIABLE_PATH = File.expand_path(File.join(TEST_DATA_DIR,
                                                 'print_variable.sh'))
PRINT_VARIABLE_NO_ERROR_PATH = File.expand_path(File.join(TEST_DATA_DIR,
                                                          'print_variable_'\
                                                          'no_error.sh'))
SERVER_ROOT = Repla::Test::TEST_HTML_DIRECTORY
SERVER_COMMAND = 'server.sh'.freeze
SERVER_COMMAND_ARG = "#{SERVER_COMMAND} "\
  "#{Shellwords.escape(SERVER_ROOT)}".freeze
SERVER_COMMAND_DIR = TEST_DATA_DIR
SERVER_COMMAND_PATH = File.join(SERVER_COMMAND_DIR,
                                SERVER_COMMAND)
TEST_SERVER_COMMAND_PATH_ENV = "PATH=\"#{SERVER_COMMAND_DIR}:$PATH\"".freeze
TEST_SERVER_ENV = "SERVER_ROOT=\"#{SERVER_ROOT}\"".freeze
TEST_ENV_KEY = 'TEST_VARIABLE'.freeze
TEST_ENV_KEY_TWO = 'TEST_VARIABLE_TWO'.freeze
TEST_ENV_VALUE = 'A test string'.freeze
TEST_ENV_VALUE_TWO = 'A second test string'.freeze
TEST_ENV = "#{TEST_ENV_KEY}=#{TEST_ENV_VALUE}\n"\
  "#{TEST_ENV_KEY_TWO}=#{TEST_ENV_VALUE_TWO}\n".freeze
TEST_REAL_ENV = File.read(File.join(TEST_DATA_DIR, 'real_env.txt'))
TEST_REAL_VALUE = 'CHANGEDfd --type d --hidden --exclude .git'.freeze
