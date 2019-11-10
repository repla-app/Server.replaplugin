#!/usr/bin/env ruby

require 'minitest/autorun'

require_relative 'lib/test_setup'
require Repla::Test::HELPER_FILE
require Repla::Test::VIEW_HELPER_FILE
require_relative '../lib/repla/logger.rb'

class TestViewAttributes < Minitest::Test
  def test_view_id
    Repla.load_plugin(Repla::Test::TEST_HELLOWORLD_PLUGIN_FILE)
    window_id = Repla.run_plugin(Repla::Test::TEST_HELLOWORLD_PLUGIN_NAME)
    assert(!window_id.nil?)
    split_id = Repla.split_id_in_window(window_id)
    assert(!split_id.nil?)
    split_id_two = Repla.split_id_in_window(window_id,
                                            Repla::Test::
                                            TEST_HELLOWORLD_PLUGIN_NAME)
    assert(!split_id_two.nil?)
    assert(split_id == split_id_two)
    split_id_three = Repla.split_id_in_window_last(window_id)
    assert(split_id != split_id_three)

    view = Repla::View.new(window_id, split_id)
    assert(split_id == view.view_id)
    assert(window_id == view.window_id)

    view.close
  end
end

class TestViewBadURL < Minitest::Test
  def test_no_server
    view = Repla::View.new
    view.load_url(Repla::Test::NO_SERVER_URL, should_clear_cache: true)
    view.close
  end
end

class TestViewDoJavaScript < Minitest::Test
  def setup
    @view = Repla::View.new
    @view.load_file(Repla::Test::INDEX_HTML_FILE)
  end

  def teardown
    @view.close
  end

  def test_do_javascript
    javascript = File.read(Repla::Test::NODOM_JAVASCRIPT_FILE)
    result = @view.do_javascript(javascript)
    expected = Repla::Test::Helper.run_javascript(javascript)
    assert_equal(expected.to_i, result.to_i)
  end
end

class TestTwoViews < Minitest::Test
  def test_load_file
    windows = Repla::Test::ViewHelper.make_windows(
      Repla::Test::INDEX_HTML_FILENAME
    )

    javascript = File.read(Repla::Test::TITLE_JAVASCRIPT_FILE)
    windows.each_with_index do |window, index|
      view_one = Repla::View.new(window.window_id)
      view_two = Repla::View.new(window.window_id, window.split_id_last)
      if index == 0
        view_two.load_file(Repla::Test::INDEXJQUERY_HTML_FILE)
      else
        view_two.load_url(Repla::Test::INDEXJQUERY_HTML_URL,
                          should_clear_cache: true)
      end

      result = view_one.do_javascript(javascript)
      assert_equal(Repla::Test::INDEX_HTML_TITLE, result)

      result = view_two.do_javascript(javascript)
      assert_equal(Repla::Test::INDEXJQUERY_HTML_TITLE, result)
      view_one.close
    end
  end
end

class TestServer < Minitest::Test
  def setup
    Repla.load_plugin(Repla::Test::TEST_SERVER_PLUGIN_FILE)
    window_id = Repla.run_plugin(Repla::Test::TEST_SERVER_PLUGIN_NAME,
                                 Repla::Test::TEST_HTML_DIRECTORY)
    @window = Repla::Window.new(window_id)
    assert(window_id == @window.window_id)
    @title_javascript = File.read(Repla::Test::TITLE_JAVASCRIPT_FILE)
  end

  def teardown
    @window.close
  end

  def test_backforward
    window = Repla::Window.new
    logger = Repla::Logger.new(window.window_id)
    logger.show
    view = Repla::View.new(window.window_id, window.split_id_last)
    refute_nil(view)
    result = nil
    Repla::Test.block_until do
      # Try reloading the URL in the loop in case the server hasn't finished
      # loading
      view.load_url(Repla::Test::INDEX_HTML_URL,
                    should_clear_cache: true)
      result = view.do_javascript(@title_javascript)
      result == Repla::Test::INDEX_HTML_TITLE
    end
    assert_equal(Repla::Test::INDEX_HTML_TITLE, result)

    # Nothing should happen if there's no back or forward to go to
    view.go_back
    result = view.do_javascript(@title_javascript)
    assert_equal(Repla::Test::INDEX_HTML_TITLE, result)
    view.go_forward
    result = view.do_javascript(@title_javascript)
    assert_equal(Repla::Test::INDEX_HTML_TITLE, result)

    # Load a second URL
    view.load_url(Repla::Test::INDEXJQUERY_HTML_URL,
                  should_clear_cache: true)
    result = nil
    Repla::Test.block_until do
      result = view.do_javascript(@title_javascript)
      result == Repla::Test::INDEXJQUERY_HTML_TITLE
    end
    assert_equal(Repla::Test::INDEXJQUERY_HTML_TITLE, result)

    # Confirm going forward is no-op
    view.go_forward
    result = view.do_javascript(@title_javascript)
    assert_equal(Repla::Test::INDEXJQUERY_HTML_TITLE, result)

    # Go back
    view.go_back
    result = nil
    Repla::Test.block_until do
      result = view.do_javascript(@title_javascript)
      result == Repla::Test::INDEX_HTML_TITLE
    end
    assert_equal(Repla::Test::INDEX_HTML_TITLE, result)

    # Confirm going back is no-op
    view.go_back
    result = view.do_javascript(@title_javascript)
    assert_equal(Repla::Test::INDEX_HTML_TITLE, result)

    # Go forward
    view.go_forward
    result = view.do_javascript(@title_javascript)
    assert_equal(Repla::Test::INDEXJQUERY_HTML_TITLE, result)

    window.close
  end
end

class TestTwoViewsReadFromStandardInput < Minitest::Test
  def setup
    Repla.load_plugin(Repla::Test::PRINT_PLUGIN_FILE)
    window_id = Repla.run_plugin(Repla::Test::PRINT_PLUGIN_NAME)
    window = Repla::Window.new(window_id)

    split_id = Repla.run_plugin_in_split(Repla::Test::PRINT_PLUGIN_NAME,
                                         window_id, window.split_id_last)
    assert(window.split_id_last, split_id)

    @view_one = Repla::View.new(window.window_id, window.split_id)
    @view_two = Repla::View.new(window.window_id, window.split_id_last)
  end

  def teardown
    @view_one.close
  end

  def test_read_from_standard_input
    test_text_one = 'This is a test string'
    @view_one.read_from_standard_input(test_text_one + "\n")
    test_text_two = 'This is a test string two'
    @view_two.read_from_standard_input(test_text_two + "\n")

    javascript = File.read(Repla::Test::LASTCODE_JAVASCRIPT_FILE)
    result_one = nil
    result_two = nil
    Repla::Test.block_until do
      result_one = @view_one.do_javascript(javascript)
      result_two = @view_two.do_javascript(javascript)
      !result_one.nil? && !result_two.nil?
    end

    result_one.strip!
    result_two.strip!
    assert_equal(test_text_one, result_one)
    assert_equal(test_text_two, result_two)
  end
end
