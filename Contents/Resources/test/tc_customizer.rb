#!/usr/bin/env ruby

require 'minitest/autorun'
require_relative 'lib/test_setup'
require_relative '../lib/customizer'

# Test server
class TestServer < Minitest::Test
  NPM_COMMAND = 'npm start'.freeze
  JUPYTER_COMMAND = 'jupyter notebook'.freeze
  JUPYTER_COMMAND_WHITESPACE = 'jupyter     notebook'.freeze
  RAILS_COMMAND = 'bin/rails server'.freeze
  def test_customizer
    command = NPM_COMMAND
    command, options = Repla::Server::Customizer.customize(command)
    assert_equal(Repla::Server::EXPRESS_PORT, options[:port])
    assert_equal(NPM_COMMAND, command)

    command = 'jupyter notebook'
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

    # TEST_DELAY_OPTIONS_LONG
    # TEST_OPTIONS_FILE
    # TEST_OPTIONS_PORT
    # TEST_OPTIONS_URL
    # TEST_OPTIONS_URL_PORT
    # command = 'bundle exec jekyll serve --watch --drafts'
    # command = 'jupyter notebook --no-browser'
    # command = 'jupyter notebook'
    # command = 'jupyter    notebook'
    # command = 'python3 manage.py runserver'
    # command = 'DEBUG=myapp:* npm start'
    # command = 'npm start'
    # command = 'npm start -p 8002'
    # command = 'npm    start'
  end
end
