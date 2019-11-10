#!/usr/bin/env ruby

require 'minitest/autorun'

require_relative 'lib/test_setup'

require Repla::Test::HELPER_FILE

require_relative '../../repl'

# Test REPL
class TestREPL < Minitest::Test
  def test_repl
    wrapper = Repla::REPL::Wrapper.new('irb')

    test_text = '1 + 1'
    test_result = '2'

    wrapper.parse_input(test_text + "\n")
    window_id = Repla::Test::Helper.window_id
    window = Repla::Window.new(window_id)

    javascript = File.read(Repla::Test::FIRSTCODE_JAVASCRIPT_FILE)
    result = nil
    Repla::Test.block_until do
      result = window.do_javascript(javascript)
      result == test_text
    end
    # Test Wrapper Input
    result.strip!
    assert_equal(test_text, result)

    # Test Wrapper Output
    javascript = File.read(Repla::Test::LASTCODE_JAVASCRIPT_FILE)
    result = window.do_javascript(javascript)
    refute_nil(result)
    result.strip!
    result.sub!('=&gt; ', '') # Remove the prompt that irb adds
    assert_equal(test_result, result)

    window.close
  end
end
