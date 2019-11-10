#!/usr/bin/env ruby

require 'minitest/autorun'

require_relative 'lib/test_setup.rb'

class TestClass < Minitest::Test
  def test_run_plugin_in_directory_with_arguments
    arguments = '1 2 3'
    path = File.expand_path(TEST_DATA_DIRECTORY)

    Repla.load_plugin(DATA_PLUGIN_FILE)
    window_id = Repla.run_plugin(DATA_PLUGIN_NAME, path, arguments.split(' '))
    window = Repla::Window.new(window_id)

    javascript = %[valueForKey('#{DATA_PLUGIN_PATH_KEY}');]
    path_result = nil
    Repla::Test.block_until do
      path_result = window.do_javascript(javascript)
      path_result == path
    end

    javascript = %[valueForKey('#{DATA_PLUGIN_ARGUMENTS_KEY}');]
    arguments_result = window.do_javascript(javascript)
    assert_equal(path, path_result)
    assert_equal(arguments, arguments_result)
    window.close
  end
end
