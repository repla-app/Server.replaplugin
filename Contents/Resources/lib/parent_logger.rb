require_relative '../bundle/bundler/setup'
require 'repla'
require 'repla/logger'

# Repla
module Repla
  # Parent logger
  class ParentLogger
    attr_reader :logger

    def initialize
      @logger = Repla::Logger.new
      @view = Repla::View(@logger.window_id)
    end

    def process_output(text)
      # TODO: Needs to look for URL here
      @logger.info(text)
    end

    def process_error(text)
      # TODO: Needs to look for URL here
      @logger.error(text)
    end

    require 'uri'
    def self.process_line(line)
      if string.scan(URI.regexp)

      end
    end
  end
end
