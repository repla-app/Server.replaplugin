#!/usr/bin/env ruby --disable-gems

require_relative '../../../../../lib/repla'

require_relative 'lib/controller'

# Controller
controller = Repla::Data::Controller.new

PATH_KEY = 'Path'.freeze
path = Dir.pwd.to_s
controller.add_key_value(PATH_KEY, path)

ARGUMENTS_KEY = 'Arguments'.freeze
arguments = ARGV.join(' ')
controller.add_key_value(ARGUMENTS_KEY, arguments)

# Debugging
path_value = controller.value_for_key(PATH_KEY)
puts 'path_value = ' + path_value.to_s

arguments_value = controller.value_for_key(ARGUMENTS_KEY)
puts 'arguments_value = ' + arguments_value.to_s
