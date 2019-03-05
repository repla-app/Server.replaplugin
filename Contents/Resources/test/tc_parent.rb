#!/usr/bin/env ruby

require 'minitest/autorun'
require_relative '../lib/parent.rb'
require_relative 'lib/parent_delegate'
require_relative 'lib/test_constants'

# Test parent
class TestParent < Minitest::Test
  def test_parent
    delegate = ParentDelegate.new
    parent = Repla::Parent.new(delegate)
    delegate.add_process_output_block do |text|
      # TODO: Need to also test standard error
      assert_equal(text, TEST_ENV_VALUE)
    end
    parent.run_command(PRINT_VARIABLE_PATH, TEST_ENV)
  end
end
