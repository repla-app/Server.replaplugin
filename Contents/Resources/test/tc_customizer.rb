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
  TEST_HOME_DIR = '/Users/username'

  def test_customizer_jupyter
    command = JUPYTER_COMMAND
    command, options = Repla::Server::Customizer.customize(command)
    refute(options[:file_refresh])
    options.delete(:file_refresh)
    assert(options.empty?)
    assert_equal(JUPYTER_COMMAND + Repla::Server::JUPYTER_SUFFIX, command)

    command = RAILS_COMMAND
    command, options = Repla::Server::Customizer.customize(command)
    assert(options.empty?)
    assert_equal(RAILS_COMMAND, command)

    command = JUPYTER_COMMAND_WHITESPACE
    command, options = Repla::Server::Customizer.customize(command)
    refute(options[:file_refresh])
    options.delete(:file_refresh)
    assert(options.empty?)
    assert_equal(JUPYTER_COMMAND_WHITESPACE + Repla::Server::JUPYTER_SUFFIX,
                 command)

    command = JUPYTER_COMMAND
    command, options = Repla::Server::Customizer.customize(command,
                                                           TEST_OPTIONS_PORT)
    assert_equal(SERVER_PORT, options[:port])
    assert_equal(JUPYTER_COMMAND + Repla::Server::JUPYTER_SUFFIX, command)

    command = JUPYTER_COMMAND_NOBROWSER
    command, options = Repla::Server::Customizer.customize(command)
    refute(options[:file_refresh])
    options.delete(:file_refresh)
    assert(options.empty?)
    assert_equal(JUPYTER_COMMAND_NOBROWSER, command)
  end

  def test_customizer_file_refresh
    options = { file_refresh: true }
    result = Repla::Server::Customizer.disable_file_refresh?(RAILS_COMMAND,
                                                             options,
                                                             TEST_HOME_DIR,
                                                             TEST_HOME_DIR)
  end
end
