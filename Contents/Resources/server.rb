#!/usr/bin/env ruby

require 'Shellwords'

require_relative 'bundle/bundler/setup'
require 'repla'

require_relative 'lib/runner.rb'

command = ARGV[0]

exit 1 unless command

environment = ARGV[1]

puts "environment = #{environment}"
# runner = Repla::Server::Runner.new(command, environment)
# runner.run
