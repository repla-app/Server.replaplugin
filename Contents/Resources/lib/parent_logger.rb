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
      url = self.class.url_from_line(line)
      @view.load_url(url) unless url.empty?
      @logger.info(text)
    end

    def process_error(text)
      url = self.class.url_from_line(line)
      @view.load_url(url) unless url.empty?
      @logger.error(text)
    end

    require 'uri'
    private_class_method def self.url_from_line(line)
      line[URI::DEFAULT_PARSER.make_regexp]
    end
  end
end
