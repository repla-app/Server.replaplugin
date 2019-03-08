require 'Shellwords'

require 'open3'

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
      command = "env #{environment} #{command}" unless environment.nil?

      Open3.popen3(command) do |stdin, stdout, stderr, thread|
        stdin.sync = true
        stdout.sync = true
        stderr.sync = true

        Thread.new do
          stdout.each do |l|
            @delegate.process_output(l) unless @delegate.nil?
          end
        end

        Thread.new do
          stderr.each do |l|
            @delegate.process_error(l) unless @delegate.nil?
          end
        end
      end
    end
  end
end
