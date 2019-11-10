require_relative '../../lib/repla/test'
require Repla::Test::HELPER_FILE
require Repla::Test::REPLA_FILE

TEST_LIB_DIRECTORY = __dir__

# Template
TEST_TEMPLATE_FILE = File.join(TEST_LIB_DIRECTORY, '../html/index.html')
TEST_TEMPLATE_TITLE = 'Test'.freeze

TEST_ROOT_ACCESS_PATH = File.expand_path(File.join(TEST_LIB_DIRECTORY,
                                                   '../../'))

# Data Plugin
TEST_DATA_DIRECTORY = File.join(TEST_LIB_DIRECTORY, '../data')
DATA_PLUGIN_FILE = File.join(TEST_DATA_DIRECTORY, 'Data.replaplugin')
DATA_PLUGIN_NAME = 'Data'.freeze
DATA_PLUGIN_PATH_KEY = 'Path'.freeze
DATA_PLUGIN_ARGUMENTS_KEY = 'Arguments'.freeze

# Test Data
TEST_TITLE = 'Test'.freeze
TEST_TITLE_JAVASCRIPT = 'document.title'.freeze
