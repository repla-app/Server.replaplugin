require_relative 'parent'
require_relative 'parent_logger'

module Repla
  # Runner
  class Runner
    def initialize
      parent_logger = ParentLogger.new
      @parent = Parent.new(parent_logger)
    end

    def run_command(command, environment)
      @parent.run_command(command, environment)
    end
  end
end
