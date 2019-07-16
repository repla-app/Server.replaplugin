#!/usr/bin/env ruby
# frozen_string_literal: true

require 'webrick'

web_server = WEBrick::HTTPServer.new(Port: 3000,
                                     DocumentRoot: Dir.pwd)

Thread.new do
  web_server.start
end

trap('INT') do
  web_server.shutdown
  exit 0
end

POLLING_INTERVAL = 0.5
def block_until_with_timeout(timeout,
                             polling_interval = POLLING_INTERVAL)
  cycles = [timeout / polling_interval, 1].max
  count = 0
  until yield || count >= cycles
    sleep(POLLING_INTERVAL)
    count += 1
  end
end

TIMEOUT = 5
def block_until(&block)
  block_until_with_timeout(TIMEOUT, &block)
end

server_thread = nil
STDIN.each_line do |line|
  Thread.new do
    web_server&.shutdown
  end
  block_until do
    port_is_open = begin
                     Socket.tcp(host, port, connect_timeout: 5) { true }
                   rescue StandardError
                     false
                   end
    port_is_open
  end
  filename = line.strip!
  server_thread = Thread.new do
    web_server = WEBrick::HTTPServer.new(Port: 3000,
                                         DocumentRoot: Dir.pwd,
                                         DirectoryIndex: [filename])
    web_server.start
  end
end

server_thread.join
