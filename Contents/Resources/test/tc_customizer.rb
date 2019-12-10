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

  def test_customizer
    command = JUPYTER_COMMAND
    command, options = Repla::Server::Customizer.customize(command)
    assert(options.empty?)
    assert_equal(JUPYTER_COMMAND + Repla::Server::JUPYTER_SUFFIX, command)

    command = RAILS_COMMAND
    command, options = Repla::Server::Customizer.customize(command)
    assert(options.empty?)
    assert_equal(RAILS_COMMAND, command)

    command = JUPYTER_COMMAND_WHITESPACE
    command, options = Repla::Server::Customizer.customize(command)
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
    assert(options.empty?)
    assert_equal(JUPYTER_COMMAND_NOBROWSER, command)
  end
end
