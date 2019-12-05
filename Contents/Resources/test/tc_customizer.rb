#!/usr/bin/env ruby

require 'minitest/autorun'
require_relative 'lib/test_setup'
require_relative '../lib/customizer'

# Test server
class TestServer < Minitest::Test
  NPM_COMMAND = 'npm start'.freeze
  NPM_COMMAND_WHITESPACE = 'npm     start'.freeze
  NPM_COMMAND_DEBUG = 'DEBUG=myapp:* npm start'.freeze
  NPM_COMMAND_PORT = 'npm start -p 5000'.freeze
  JUPYTER_COMMAND = 'jupyter notebook'.freeze
  JUPYTER_COMMAND_WHITESPACE = 'jupyter     notebook'.freeze
  JUPYTER_COMMAND_NOBROWSER = 'jupyter notebook --no-browser'.freeze
  RAILS_COMMAND = 'bin/rails server'.freeze

  def test_customizer
    command = NPM_COMMAND
    command, options = Repla::Server::Customizer.customize(command)
    assert_equal(Repla::Server::EXPRESS_PORT, options[:port])
    assert_equal(NPM_COMMAND, command)

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

    command = NPM_COMMAND_WHITESPACE
    command, options = Repla::Server::Customizer.customize(command)
    assert_equal(Repla::Server::EXPRESS_PORT, options[:port])
    assert_equal(NPM_COMMAND_WHITESPACE,
                 command)

    refute_equal(Repla::Server::EXPRESS_PORT, SERVER_PORT)
    command = NPM_COMMAND
    command, options = Repla::Server::Customizer.customize(command,
                                                           TEST_OPTIONS_PORT)
    assert_equal(SERVER_PORT, options[:port])
    assert_equal(NPM_COMMAND, command)

    command = NPM_COMMAND_DEBUG
    command, options = Repla::Server::Customizer.customize(command)
    assert_equal(Repla::Server::EXPRESS_PORT, options[:port])
    assert_equal(NPM_COMMAND_DEBUG, command)

    command = JUPYTER_COMMAND
    command, options = Repla::Server::Customizer.customize(command,
                                                           TEST_OPTIONS_PORT)
    assert_equal(SERVER_PORT, options[:port])
    assert_equal(JUPYTER_COMMAND + Repla::Server::JUPYTER_SUFFIX, command)

    command = JUPYTER_COMMAND_NOBROWSER
    command, options = Repla::Server::Customizer.customize(command)
    assert(options.empty?)
    assert_equal(JUPYTER_COMMAND_NOBROWSER, command)

    command = NPM_COMMAND
    command, options = Repla::Server::Customizer
                       .customize(command,
                                  TEST_DELAY_OPTIONS_LONG)
    assert_equal(Repla::Server::EXPRESS_PORT, options[:port])
    assert_equal(TEST_DELAY_LENGTH_LONG, options[:delay])
    assert_equal(NPM_COMMAND, command)

    command = NPM_COMMAND
    command, options = Repla::Server::Customizer
                       .customize(command,
                                  TEST_OPTIONS_URL)
    assert_nil(options[:port])
    assert_equal(NPM_COMMAND, command)

    command = NPM_COMMAND
    command, options = Repla::Server::Customizer
                       .customize(command,
                                  TEST_OPTIONS_URL_PORT)
    assert_equal(SERVER_PORT, options[:port])
    assert_equal(NPM_COMMAND, command)

    command = NPM_COMMAND
    command, options = Repla::Server::Customizer
                       .customize(command,
                                  TEST_OPTIONS_FILE)
    assert_nil(options[:port])
    assert_equal(TEST_FILE, options[:file])
    assert_equal(NPM_COMMAND, command)

    command = NPM_COMMAND_PORT
    command, options = Repla::Server::Customizer
                       .customize(command)
    assert_nil(options[:port])
    assert_equal(NPM_COMMAND_PORT, command)

    # command = 'bundle exec jekyll serve --watch --drafts'
    # command = 'jupyter notebook --no-browser'
    # command = 'python3 manage.py runserver'
  end
end
