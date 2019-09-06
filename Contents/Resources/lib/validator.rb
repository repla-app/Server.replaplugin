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
      def validate(options)
        nil
      end
    end
  end
end

