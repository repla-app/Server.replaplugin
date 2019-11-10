#!/usr/bin/env ruby

require 'minitest/autorun'

require_relative 'lib/test_setup'
require Repla::Test::HELPER_FILE
require_relative 'lib/test_javascript_constants'

require Repla::Test::HELPER_FILE

class TestViewRootAccessDirectory < Minitest::Test
  def test_root_access_directory
    view = Repla::View.new
    view.root_access_directory_path = TEST_ROOT_ACCESS_PATH
    view.load_file(TEST_TEMPLATE_FILE)
    result = view.do_javascript_function(
      TEST_JAVASCRIPT_FUNCTION_WITHOUT_ARGUMENTS_NAME
    )
    assert_equal(TEST_JAVASCRIPT_FUNCTION_WITHOUT_ARGUMENTS_RESULT, result)
    view.close
  end
end

class TestViewTitle < Minitest::Test
  def test_no_title
    view = Repla::View.new
    view.root_access_directory_path = TEST_ROOT_ACCESS_PATH
    view.load_file(TEST_TEMPLATE_FILE)
    title_result = view.do_javascript(TEST_TITLE_JAVASCRIPT)
    assert(TEST_TEMPLATE_TITLE, title_result)
    view.close
  end
end
