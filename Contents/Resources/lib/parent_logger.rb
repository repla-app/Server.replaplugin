require_relative '../bundle/bundler/setup'
require 'repla'
require 'repla/logger'

# Repla
module Repla
  module Server
    # Parent logger
    class ParentLogger
      attr_reader :logger

      def initialize(logger = nil, view = nil)
        @logger = logger || Repla::Logger.new
        @view = view || Repla::View.new(@logger.window_id)
        @loaded_url = false
      end

      def process_output(text)
        url = self.class.url_from_line(text)
        if !url.nil? && !@loaded_url
          @view.load_url(url)
          @loaded_url = true
        end
        @logger.info(text)
      end

      def process_error(text)
        url = self.class.url_from_line(text)
        if !url.nil? && !@loaded_url
          @view.load_url(url)
          @loaded_url = true
        end
        @logger.error(text)
      end

      require 'uri'
      # `private_class_method`
      def self.url_from_line(line)
        # This is more correct, but it makes has false positives for our use
        # case like `address:` line[URI::DEFAULT_PARSER.make_regexp]
        line[Regexp.new(%r{https?://[\S]+})]
      end
    end
  end
end
