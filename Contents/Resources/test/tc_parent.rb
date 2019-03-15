#!/System/Library/Frameworks/Ruby.framework/Versions/2.3/usr/bin/ruby

require 'minitest/autorun'
require_relative '../lib/parent.rb'
require_relative 'lib/parent_delegate'
require_relative 'lib/test_setup'

# Test parent
class TestParent < Minitest::Test
  TEST_OUTPUT_COUNT = 40
  def test_parent
    delegate = ParentDelegate.new
    parent = Repla::Server::Parent.new(PRINT_VARIABLE_PATH, TEST_ENV, delegate)
    test_output_count = TEST_OUTPUT_COUNT
    output_count = 0
    (1..test_output_count).each do |_|
      delegate.add_process_output_block do |text|
        text.chomp!
        assert_equal(TEST_ENV_VALUE, text)
        output_count += 1
      end
    end
    test_error_count = TEST_OUTPUT_COUNT
    error_count = 0
    (1..test_error_count).each do |_|
      delegate.add_process_error_block do |text|
        text.chomp!
        assert_equal(TEST_ENV_VALUE_TWO, text)
        error_count += 1
      end
    end
    parent.run
    count = 0
    until (output_count == test_output_count &&
        error_count == test_error_count) || count > 4
      sleep(1)
      count += 1
    end
    assert_equal(test_output_count, output_count)
    assert_equal(test_error_count, error_count)
  end

  def test_parent_real_env
    delegate = ParentDelegate.new
    parent = Repla::Server::Parent.new(PRINT_VARIABLE_NO_ERROR_PATH,
                                       TEST_REAL_ENV,
                                       delegate)
    test_output_count = TEST_OUTPUT_COUNT

    # return

    output_count = 0
    (1..test_output_count).each do |_|
      delegate.add_process_output_block do |text|
        text.chomp!
        assert_equal(TEST_REAL_VALUE, text)
        output_count += 1
      end
    end
    error_called = false
    delegate.add_process_error_block do |text|
      error_called = true
    end
    parent.run
    count = 0
    until output_count == test_output_count || count > 4
      sleep(1)
      count += 1
    end
    refute(error_called)
    assert_equal(test_output_count, output_count)
  end
end
