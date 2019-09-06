#!/System/Library/Frameworks/Ruby.framework/Versions/2.3/usr/bin/ruby --disable-gems

require 'optparse'

require_relative 'bundle/bundler/setup'
require 'repla'

require_relative 'lib/runner'
require_relative 'lib/config'
require_relative 'lib/validator'

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
          'specified. Leading and trailing whitespace is removed from the '\
          'URL.') do |url|
    options[:url] = url
  end
  opts.on('-o',
          '--open FILE',
          'Specify a FILE. The FILE will be opened after the first output '\
          'unless a STRING is also specified. Leading and trailing whitespace '\
          'is removed from the FILE.') do |file|
    options[:file] = file
  end
  opts.on('-s',
          '--url-string STRING',
          'Don\'t load a URL until after the STRING is output. Leading and '\
          'trailing whitespace is removed from the STRING.') do |string|
    options[:url_string] = string
  end
  opts.on('-r',
          '--refresh-string STRING',
          'Refresh each time STRING is output. Has no effect until a URL is '\
          'loaded. Leading and trailing whitespace is removed from the '\
          'STRING.') do |string|
    options[:refresh_string] = string
  end
  opts.on('-d',
          '--delay DELAY',
          'Wait DELAY seconds before loading a url. If a string is also '\
          'specified, the delay happens after the string is found. The '\
          'default DELAY is 0.5, the DELAY can be set to 0.') do |delay|
    options[:delay] = delay.to_f
  end
  opts.on('-h', '--help', 'Show options help.') do
    puts opts
    exit
  end
end

optparse.parse!
command = ARGV[0]

abort('No command specified.') if command.nil?

config = Repla::Server::Config.new(options)
error = Repla::Server::Validator.validate(config)
unless error.nil?
  STDERR.puts error
  exit 1
end

runner = Repla::Server::Runner.new(command, config)
trap 'SIGINT' do
  runner.stop
end

runner.run
