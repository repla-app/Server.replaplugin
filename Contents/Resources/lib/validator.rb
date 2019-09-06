module Repla
  module Server
    # Invalid
    class Invalid
      attr_reader :message
      def initialize(message)
        @message = message
      end
    end

    # Logger to standard out
    class Validator
      FILE_AND_URL = 'ERROR: Both a file and URL were specified.'.freeze
      FILE_AND_PORT = 'ERROR: Both a file and port were specified.'.freeze
      FILE_MISSING = 'ERROR: The specified file doesn\'t exist.'.freeze
      def self.validate(config)
        return nil if config.nil?

        return FILE_AND_URL if !config.url.nil? && !config.file.nil?

        return FILE_AND_PORT if !config.port.nil? && !config.file.nil?

        return FILE_MISSING if !config.file.nil? && !File.exist?(config.file)
      end
    end
  end
end
