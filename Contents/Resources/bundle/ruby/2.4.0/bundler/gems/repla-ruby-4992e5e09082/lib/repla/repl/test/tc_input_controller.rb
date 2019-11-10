#!/usr/bin/env ruby

require 'minitest/autorun'

require_relative 'lib/test_setup'

require_relative '../lib/input_controller'
require_relative '../lib/view'

# Test input controller
class TestInputController < Minitest::Test
  def test_input_controller
    view = Repla::REPL::View.new
    input_controller = Repla::REPL::InputController.new(view)

    test_text = 'Some test text'
    input_controller.parse_input(test_text)

    javascript = File.read(Repla::Test::LASTCODE_JAVASCRIPT_FILE)
    result = input_controller.view.do_javascript(javascript)
    refute_nil(result)
    result.strip!

    assert_equal(test_text, result, 'The test text should equal the result.')

    input_controller.view.close
  end
end
