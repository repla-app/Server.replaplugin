#!/usr/bin/env ruby

require 'minitest/autorun'

require_relative 'lib/test_setup'

require_relative '../lib/controller'

class TestController < Minitest::Test
  def test_controller
    controller = Repla::Data::Controller.new
    controller.add_key_value(TEST_KEY, TEST_VALUE)
    result = controller.value_for_key(TEST_KEY)
    assert_equal(TEST_VALUE, result, 'The result should equal the test value.')
    controller.view.close
  end
end
