require 'listen'

module Repla
  module Server
    # Watcher
    class Watcher
      def initialize(delegate)
        @delegate = delegate
        @listener = Listen.to('.') do |_modified, _added, _removed|
          @delegate.process_file_event
        end
      end

      def start
        @listener.start
      end
    end
  end
end
