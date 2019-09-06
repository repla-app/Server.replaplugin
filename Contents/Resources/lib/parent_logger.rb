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
        @url_string_found = @config.nil? ||
                            @config&.url_string.nil? ||
                            @config&.url_string&.empty?
      end

      def file
        @config&.file
      end

      def use_file
        !file.nil?
      end

      def delay
        @config&.delay || DEFAULT_DELAY
      end

      def process_output(text)
        @logger.info(text)

        refresh_string = @config&.refresh_string
        if @loaded_url && !refresh_string.nil?
          found = self.class.string_found?(text, refresh_string)
          @view.reload if found
        end

        return if @loaded_url

        file = nil
        url = nil
        if use_file
          file = file_from_line(text)
        else
          url = url_from_line(text)
        end

        return if url.nil? && file.nil?

        @loaded_url = true

        if !delay.nil? && delay > 0
          Thread.new do
            sleep delay
            if use_file
              @view.load_file(file)
            else
              @view.load_url(url, should_clear_cache: true)
            end
          end
        elsif use_file
          @view.load_file(file)
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
        updated_line = update_string_found(line)

        return nil unless @url_string_found

        url = @config&.url
        return url unless url.nil?

        self.class.url_from_line(updated_line)
      end

      def file_from_line(line)
        update_string_found(line)

        return nil unless @url_string_found

        file = @config&.file
        return file unless file.nil?
      end

      def update_string_found(line)
        string_index = self.class.find_string(line, @config&.url_string) unless
          @url_string_found
        return line if string_index.nil?

        @url_string_found = true
        # Trim everything before the `@config&.url_string` so that it isn't
        # searched for a URL
        line[string_index..-1]
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
