require_relative 'parent'
require_relative 'parent_logger'

module Repla
  # Runner
  class Runner
    def initialize(command, environment)
      parent_logger = ParentLogger.new
      @parent = Parent.new(command, environment, parent_logger)
    end

    def run
      @parent.run
    end
  end
end
