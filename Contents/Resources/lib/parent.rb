require 'Shellwords'

# Repla
module Repla
  module Server
    # Parent
    class Parent
      def initialize(command, delegate)
        @delegate = delegate
        @command = command
      end

      def run
        return if @command.nil?

        # Using `PTY`, we lose the `STDOUT` vs. `STDERR` distinction, and we
        # have to handle escape codes, but this seems to automatically prevent
        # any `STDOUT` buffering issues
        require 'pty'
        PTY.spawn(@command) do |stdout, stdin, pid|
          stdin.sync = true
          stdout.sync = true

          output_thread = Thread.new do
            stdout.each do |line|
              @delegate.process_output(line) unless @delegate.nil?
            end
          end

          @pid = pid
          # Make sure all output gets processed before existing
          stdout.flush
          output_thread.join
        end

        # Using `open3`, we get `STDERR` and escape codes are automatically
        # removed, by this introduces `STDOUT` buffering issues.
        # require 'open3'
        # Open3.popen3(@command) do |stdin, stdout, stderr, wait_thr|
        #   stdin.sync = true
        #   stdout.sync = true
        #   stderr.sync = true

        #   output_thread = Thread.new do
        #     stdout.each do |line|
        #       @delegate.process_output(line) unless @delegate.nil?
        #     end
        #   end

        #   error_thread = Thread.new do
        #     stderr.each do |line|
        #       @delegate.process_error(line) unless @delegate.nil?
        #     end
        #   end
        #   @pid = wait_thr.pid
        #   wait_thr.value
        #   # Make sure all output gets processed before existing
        #   stdout.flush
        #   stderr.flush
        #   output_thread.join
        #   error_thread.join
        # end
      end

      def stop
        Process.kill(:TERM, @pid)
      end
    end
  end
end
