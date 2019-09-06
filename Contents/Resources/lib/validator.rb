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
      def self.validate(options)
        return nil if options.nil?
      end
    end
  end
end
