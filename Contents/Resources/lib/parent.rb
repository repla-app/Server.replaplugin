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
      # pipe = IO.popen(command)
      # while (line = pipe.gets)
      #   @delegate.process_line(line) unless @delegate.nil?
      # end

      Open3.popen3(command) do |stdin, stdout, stderr, thread|
        stdin.sync = true
        stdout.sync = true
        stderr.sync = true

        Thread.new do
          stdout.each do |l|
            @delegate.process_line(l) unless @delegate.nil?
          end
        end

        Thread.new do
          stderr.each do |l|
            puts "error l = #{l}"
          end
        end

        thread.join
      end
    end
  end
end
