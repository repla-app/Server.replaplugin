#!/usr/bin/env ruby

require 'minitest/autorun'
require_relative 'lib/test_setup'
require_relative '../lib/customizer'

# Test server
class TestServer < Minitest::Test
  def test_customizer
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
