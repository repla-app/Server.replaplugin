#!/System/Library/Frameworks/Ruby.framework/Versions/2.3/usr/bin/ruby

require 'Shellwords'

require_relative 'bundle/bundler/setup'
require 'repla'

require_relative 'lib/runner'

command = ARGV[0]

exit 1 unless command

runner = Repla::Server::Runner.new(command)
trap 'SIGINT' do
  runner.stop
end

runner.run
