require 'Shellwords'

require 'open3'

# Repla
module Repla
  module Server
    # Parent
    class Parent
      def initialize(command, environment, delegate)
        @delegate = delegate

        @command = command.to_s
        @command = "env #{environment} #{command}" unless environment.nil?
      end

      def run
        return if @command.nil?

        Open3.popen3(@command) do |stdin, stdout, stderr, wait_thr|
          stdin.sync = true
          stdout.sync = true
          stderr.sync = true

          output_thread = Thread.new do
            stdout.each do |line|
              @delegate.process_output(line) unless @delegate.nil?
            end
          end

          error_thread = Thread.new do
            stderr.each do |line|
              @delegate.process_error(line) unless @delegate.nil?
            end
          end
          @pid = wait_thr.pid
          wait_thr.value
          # Make sure all output gets processed before existing
          stdout.flush
          stderr.flush
          output_thread.join
          error_thread.join
        end
      end

      def stop
        Process.kill(:TERM, @pid)
      end
    end
  end
end
