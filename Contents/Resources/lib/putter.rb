module Repla
  module Server
    # Logger to standard out
    class Putter
      def info(text)
        puts text
        STDOUT.flush
      end

      def error(text)
        STDERR.puts text
      end
    end
  end
end
