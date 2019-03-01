#!/System/Library/Frameworks/Ruby.framework/Versions/2.3/usr/bin/ruby

require_relative '../../../../../../lib/repla'
require_relative '../../../../../../lib/repla/logger'

logger = Repla::Logger.new
logger.info('Testing log message')
puts 'Testing print to standard input'
STDERR.puts 'Testing print to standard error'
window = Repla::Window.new
window.do_javascript('document.body.innerHTML = "test";')
logger.error('Testing log error')
logger.show
