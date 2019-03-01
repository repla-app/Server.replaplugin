require_relative '../../../test'
require Repla::Test::HELPER_FILE
require Repla::Test::REPLA_FILE

TEST_CLASS_JAVASCRIPT = 'document.body.lastChild.classList[0]'.freeze
TEST_MESSAGE_JAVASCRIPT = 'document.body.lastChild.innerText'.freeze
TEST_MESSAGE_COUNT_JAVASCRIPT = 'document.body.children.length'.freeze

TEST_JAVASCRIPT_DIRECTORY = File.join(File.dirname(__FILE__), '..', 'js')
TEST_JAVASCRIPT_FILE = File.join(TEST_JAVASCRIPT_DIRECTORY,
                                 'test_view_helper.js')
