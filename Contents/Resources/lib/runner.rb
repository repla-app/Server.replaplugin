require_relative 'parent'
require_relative 'parent_logger'

module Repla
  module Server
    # Runner
    class Runner
      def initialize(command, config = nil)
        parent_logger = ParentLogger.new(nil, nil, config)
        @parent = Parent.new(command, parent_logger)
      end

      def run
        @parent.run
      end

      def stop
        @parent.stop
      end
    end
  end
end
