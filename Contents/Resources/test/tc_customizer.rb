#!/usr/bin/env ruby

require 'minitest/autorun'
require_relative 'lib/test_setup'
require_relative '../lib/customizer'

# Test server
class TestServer < Minitest::Test
  JUPYTER_COMMAND = 'jupyter notebook'.freeze
  JUPYTER_COMMAND_WHITESPACE = 'jupyter     notebook'.freeze
  JUPYTER_COMMAND_NOBROWSER = 'jupyter notebook --no-browser'.freeze
  RAILS_COMMAND = 'bin/rails server'.freeze
  TEST_HOME_DIR = Dir.home
  TEST_LIBRARY_DIR = File.join(TEST_HOME_DIR, 'Library')
  TEST_LIBRARY_DIR_CASE = File.join(TEST_HOME_DIR, 'library')
  TEST_LIBRARY_DIR_SLASH = File.join(TEST_HOME_DIR, 'Library/')
  PWD_NO_MATCH = __dir__

  def test_customizer_jupyter
    customizer = Repla::Server::Customizer.new(PWD_NO_MATCH, TEST_HOME_DIR)

    command = RAILS_COMMAND
    command, options = customizer.customize(command)
    assert(options.empty?)
    assert_equal(RAILS_COMMAND, command)

    command = JUPYTER_COMMAND_WHITESPACE
    command, options = customizer .customize(command)
    assert(options.empty?)
    assert_equal(JUPYTER_COMMAND_WHITESPACE + Repla::Server::JUPYTER_SUFFIX,
                 command)
  end

  def test_customizer_file_refresh
    customizer = Repla::Server::Customizer.new(TEST_HOME_DIR, TEST_HOME_DIR)
    options = { file_refresh: true }
    command, options = customizer.customize(RAILS_COMMAND, options)
    assert(options[:file_refresh])
    assert_equal(RAILS_COMMAND, command)

    customizer = Repla::Server::Customizer.new(TEST_HOME_DIR, TEST_HOME_DIR)
    options = {}
    command, options = customizer.customize(RAILS_COMMAND, options)
    refute(options[:file_refresh])
    assert_equal(RAILS_COMMAND, command)

    customizer = Repla::Server::Customizer.new(TEST_LIBRARY_DIR, TEST_HOME_DIR)
    options = {}
    command, options = customizer.customize(RAILS_COMMAND, options)
    refute(options[:file_refresh])
    assert_equal(RAILS_COMMAND, command)

    customizer = Repla::Server::Customizer.new(TEST_LIBRARY_DIR_CASE,
                                               TEST_HOME_DIR)
    options = {}
    command, options = customizer.customize(RAILS_COMMAND, options)
    refute(options[:file_refresh])
    assert_equal(RAILS_COMMAND, command)

    customizer = Repla::Server::Customizer.new(TEST_LIBRARY_DIR_SLASH,
                                               TEST_HOME_DIR)
    options = {}
    command, options = customizer.customize(RAILS_COMMAND, options)
    refute(options[:file_refresh])
    assert_equal(RAILS_COMMAND, command)

    customizer = Repla::Server::Customizer.new(PWD_NO_MATCH,
                                               TEST_HOME_DIR)
    options = {}
    command, options = customizer.customize(RAILS_COMMAND, options)
    assert_nil(options[:file_refresh])
    assert_equal(RAILS_COMMAND, command)
  end
end
