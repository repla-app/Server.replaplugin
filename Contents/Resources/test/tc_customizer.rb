#!/usr/bin/env ruby

require 'minitest/autorun'
require_relative 'lib/test_setup'
require_relative '../lib/customizer'

# Test server
class TestServer < Minitest::Test
  def test_customizer
    command = 'repla server "bin/rails server"'
    command = 'bundle exec jekyll serve --watch --drafts"'
    command = 'jupyter notebook --no-browser"'
    command = 'python3 manage.py runserver"'
    command = 'DEBUG=myapp:* npm start" -p 3000'
  end
end
