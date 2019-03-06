require_relative '../bundle/bundler/setup.rb'
# require 'repla'
require 'repla/logger'

# Repla
module Repla
  attr_reader :logger

  # Parent lgoger
  class ParentLogger
    def initiliaze
      @logger = Repla::Logger.new
    end

    def process_output(text)
      @logger.info(text)
    end

    def process_error(text)
      @logger.error(text)
    end
  end
end
