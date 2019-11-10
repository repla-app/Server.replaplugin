#!/usr/bin/env ruby

require 'minitest/autorun'

require_relative 'lib/test_setup'

require_relative '../lib/tester'

# Test tester
class TestTester < Minitest::Test
  def test_shell_command
    result = Repla::Dependencies::Tester.check('grep', :shell_command)
    assert(result, 'The dependency check should have succeeded.')
  end

  def test_missing_shell_command
    result = Repla::Dependencies::Tester.check('asdf', :shell_command)
    assert(!result, 'The dependency check should have failed.')
  end
end
