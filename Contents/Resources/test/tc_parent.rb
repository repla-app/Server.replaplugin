#!/usr/bin/env ruby

require 'minitest/autorun'
require_relative '../lib/parent.rb'
require_relative 'lib/parent_delegate'
require_relative 'lib/test_setup'

# Test parent
class TestParent < Minitest::Test
  def test_parent
    delegate = ParentDelegate.new
    parent = Repla::Parent.new(PRINT_VARIABLE_PATH, TEST_ENV, delegate)
    output_ran = false
    delegate.add_process_output_block do |text|
      assert_equal(text, TEST_ENV_VALUE)
      output_ran = true
    end
    error_ran = false
    delegate.add_process_error_block do |text|
      assert_equal(text, TEST_ENV_VALUE_TWO)
      error_ran = true
    end
    parent.run
    sleep Repla::Test::TEST_PAUSE_TIME
    assert(output_ran)
    assert(error_ran)
  end
end
