require_relative '../bundle/bundler/setup'
require 'repla'
require_relative 'putter'

# Repla
module Repla
  module Server
    # Parent logger
    class ParentLogger
      attr_reader :logger

      def initialize(logger = nil, view = nil)
        raise unless (logger.nil? && view.nil?) ||
                     (!logger.nil? && !view.nil?)

        @logger = logger || Repla::Server::Putter.new
        @view = view || Repla::View.new
        @loaded_url = false
      end

      def process_output(text)
        url = self.class.url_from_line(text)
        if !url.nil? && !@loaded_url
          @view.load_url(url, should_clear_cache: true)
          @loaded_url = true
        end
        @logger.info(text)
      end

      def process_error(text)
        url = self.class.url_from_line(text)
        if !url.nil? && !@loaded_url
          @view.load_url(url, should_clear_cache: true)
          @loaded_url = true
        end
        @logger.error(text)
      end

      require 'uri'
      # `private_class_method`
      def self.url_from_line(line)
        # This is more correct, but it makes has false positives for our use
        # case like `address:` line[URI::DEFAULT_PARSER.make_regexp]
        result = line[Regexp.new(%r{https?://[\S]+})]
        return result unless result.nil?

        # Handle `tcp`
        # Rails uses the format `tcp://localhost:3000`
        result = line[Regexp.new(%r{tcp://[\S]+})]
        return result.gsub(/^tcp/, 'http') unless result.nil?

        # Handle Port
        result = line[Regexp.new(/Port[^\d]?[^\d]?(\d+)/, Regexp::IGNORECASE)]
        return Regexp.last_match(1) unless result.nil?

        nil
      end
    end
  end
end
