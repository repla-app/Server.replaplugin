#!/System/Library/Frameworks/Ruby.framework/Versions/2.3/usr/bin/ruby

require 'optparse'

require_relative 'bundle/bundler/setup'
require 'repla'

require_relative 'lib/runner'

options = {}
optparse = OptionParser.new do |opts|
  opts.banner = 'The server plugin runs a command and scans its output for a '\
    'URL and loads it.'
  opts.on('-p',
          '--port PORT',
          'Specify a PORT number. If a URL is also specified, then the PORT '\
          'and URL will be combined, otherwise localhost will be used. The '\
          'URL will be loaded after the first output unless a STRING is also '\
          'specified.') do |port|
    options[:port] = port
  end
  opts.on('-u',
          '--url URL',
          'Specify a URL. If a PORT is also specified, then the PORT and URL '\
          'will be combined, otherwise no port number will be used. The URL '\
          'will be loaded after the first output unless a STRING is also '\
          'specified.') do |url|
    options[:url] = url
  end
  opts.on('-s',
          '--string STRING',
          'Don\'t load a URL until the STRING is output.') do |string|
    options[:string] = string
  end
  opts.on('-h', '--help', 'Show options help.') do
    puts opts
    exit
  end
end

optparse.parse!
command = ARGV[0]

abort('No command specified.') if command.nil?

runner = Repla::Server::Runner.new(command, options)
trap 'SIGINT' do
  runner.stop
end

runner.run
