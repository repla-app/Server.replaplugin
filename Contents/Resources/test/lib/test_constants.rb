PRINT_VARIABLE_PATH = File.expand_path(File.join(File.dirname(__FILE__),
                                                 '../data/print_variable.sh'))
TEST_ENV_KEY = 'TEST_VARIABLE'.freeze
TEST_ENV_KEY_TWO = 'TEST_VARIABLE_TWO'.freeze
TEST_ENV_VALUE = 'A test string'.freeze
TEST_ENV_VALUE_TWO = 'A second test string'.freeze
TEST_ENV = "#{TEST_ENV_KEY}=\"#{TEST_ENV_VALUE}\" "\
  "#{TEST_ENV_KEY_TWO}=\"#{TEST_ENV_VALUE_TWO}\"".freeze
