require_relative '../bundle/bundler/setup'
require 'repla'
require_relative 'putter'

# Repla
module Repla
  module Server
    DEFAULT_DELAY = 0.5
    # Parent logger
    class ParentLogger
      attr_reader :logger

      def initialize(logger = nil, view = nil, config = nil)
        raise unless (logger.nil? && view.nil?) ||
                     (!logger.nil? && !view.nil?)

        @logger = logger || Repla::Server::Putter.new
        @view = view || Repla::View.new
        @loaded_url = false
        @config = config
      end

      def process_output(text)
        @logger.info(text)

        if @loaded_url && !@config.refresh_string.nil?
          found = self.class.string_found?(text, @config.refresh_string)
          @view.reload if found
        end

        return if @loaded_url

        url = url_from_line(text)

        return if url.nil?

        @loaded_url = true

        if @config.delay > 0
          Thread.new do
            sleep @config.delay
            @view.load_url(url, should_clear_cache: true)
          end
        else
          @view.load_url(url, should_clear_cache: true)
        end
      end

      def process_error(text)
        @logger.error(text)

        return if @loaded_url

        url = url_from_line(text)

        return if url.nil?

        @view.load_url(url, should_clear_cache: true)
        @loaded_url = true
      end

      def url_from_line(line)
        string_index = self.class.find_string(line, @config.url_string) unless
          @config.url_string_found

        unless string_index.nil?
          @config.url_string_found = true
          # Trim everything before the `@config.url_string` so that it isn't searched
          # for a URL
          line = line[string_index..-1]
        end

        return nil unless @config.url_string_found

        return @config.url unless @config.url.nil?

        self.class.url_from_line(line)
      end

      def self.find_string(text, string)
        raise if string.nil?

        text.index(string)
      end

      def self.string_found?(text, string)
        raise if string.nil?

        !find_string(text, string).nil?
      end

      require 'uri'
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
        result = line[Regexp.new(/port[^\d]?[^\d]?(\d+)/i)]
        unless result.nil?
          port = Regexp.last_match(1)
          return "http://localhost:#{port}"
        end

        nil
      end
    end
  end
end
