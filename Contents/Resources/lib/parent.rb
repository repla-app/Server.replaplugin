require 'Shellwords'

module Repla
  # Parent
  class Parent
    attr_writer :delegate
    def initialize(delegate)
      @delegate = delegate
    end

    def run_command(command, environment)
      return if command.nil?

      command = command.to_s
      unless env.nil?
        command = "env #{Shellwords.escape(environment)}"\
          " #{command}"
      end
      pipe = IO.popen(command)
      while (line = pipe.gets)
        @delegate.process_line(line) unless @delegate.nil?
      end
    end
  end
end
