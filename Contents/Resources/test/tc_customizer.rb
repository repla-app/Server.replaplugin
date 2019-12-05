#!/usr/bin/env ruby

require 'minitest/autorun'
require_relative 'lib/test_setup'
require_relative '../lib/customizer'

# Test server
class TestServer < Minitest::Test
  def test_customizer
    TEST_OPTIONS_FILE
    TEST_OPTIONS_PORT
    TEST_OPTIONS_URL
    TEST_OPTIONS_URL_PORT

    command = 'bin/rails server'
    command = 'bundle exec jekyll serve --watch --drafts'
    command = 'jupyter notebook --no-browser'
    command = 'jupyter notebook'
    command = 'jupyter    notebook'
    command = 'python3 manage.py runserver'
    command = 'DEBUG=myapp:* npm start'
    command = 'npm start'
    command = 'npm start -p 8002'
    command = 'npm    start'
  end
end
