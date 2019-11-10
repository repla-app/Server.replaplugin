#!/usr/bin/env ruby

require 'minitest/autorun'

require_relative 'lib/test_setup'
require Repla::Test::HELPER_FILE
require_relative 'lib/test_javascript_constants'

class TestViewJavaScript < Minitest::Test
  def setup
    @view = Repla::View.new
    @view.root_access_directory_path = TEST_ROOT_ACCESS_PATH
    @view.load_file(TEST_TEMPLATE_FILE)
  end

  def teardown
    @view.close
  end

  def test_resources
    # Testing jquery assures that `zepto.js` has been loaded correctly
    javascript = File.read(Repla::Test::TEXTJQUERY_JAVASCRIPT_FILE)
    result = @view.do_javascript(javascript)

    test_javascript = File.read(Repla::Test::TEXT_JAVASCRIPT_FILE)
    expected = @view.do_javascript(test_javascript)

    assert_equal(expected, result)
  end

  def test_javascript_function_without_arguments
    result = @view.do_javascript_function(
      TEST_JAVASCRIPT_FUNCTION_WITHOUT_ARGUMENTS_NAME
    )
    assert_equal(
      TEST_JAVASCRIPT_FUNCTION_WITHOUT_ARGUMENTS_RESULT, result
    )
  end

  def test_javascript_function_with_arguments
    result = @view.do_javascript_function(
      TEST_JAVASCRIPT_FUNCTION_WITH_ARGUMENTS_NAME,
      TEST_JAVASCRIPT_FUNCTION_WITH_ARGUMENTS_STRING_ARGUMENTS
    )
    assert_equal(
      TEST_JAVASCRIPT_FUNCTION_WITH_ARGUMENTS_STRING_RESULT, result
    )
  end

  def test_javascript_function_with_integer_argument
    result = @view.do_javascript_function(
      TEST_JAVASCRIPT_FUNCTION_WITH_ARGUMENTS_NAME,
      TEST_JAVASCRIPT_FUNCTION_WITH_ARGUMENTS_INTEGER_ARGUMENTS
    )
    assert_equal(TEST_JAVASCRIPT_FUNCTION_WITH_ARGUMENTS_INTEGER_RESULT, result)
  end

  def test_javascript_function_with_float_argument
    result = @view.do_javascript_function(
      TEST_JAVASCRIPT_FUNCTION_WITH_ARGUMENTS_NAME,
      TEST_JAVASCRIPT_FUNCTION_WITH_ARGUMENTS_FLOAT_ARGUMENTS
    )
    assert_equal(TEST_JAVASCRIPT_FUNCTION_WITH_ARGUMENTS_FLOAT_RESULT, result)
  end
end
