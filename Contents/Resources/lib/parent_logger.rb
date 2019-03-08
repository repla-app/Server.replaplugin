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
      @view = Repla::View.new(@logger.window_id)
    end

    def process_output(text)
      url = self.class.url_from_line(text)
      @view.load_url(url) if url.nil?
      @logger.info(text)
    end

    def process_error(text)
      url = self.class.url_from_line(text)
      @view.load_url(url) if url.nil?
      @logger.error(text)
    end

    require 'uri'
    # `private_class_method`
    def self.url_from_line(line)
      line[URI::DEFAULT_PARSER.make_regexp]
    end
  end
end
