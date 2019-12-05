module Repla
  module Server
    EXPRESS_PORT = 3000
    JUPYTER_SUFFIX = ' --no-browser'.freeze
    # Customizer
    class Customizer
      def self.customize(command, options = {})
        command = command.dup
        options = options.dup
        if customizable_express?(command)
          options[:port] = 3000 if options[:port].nil? && options[:url].nil?
        elsif customizable_jupyter?(command)
          command << JUPYTER_SUFFIX
        end
        [command, options]
      end

      def self.customizable_express?(command)
        /npm\s*start$/.match?(command)
      end

      def self.customizable_jupyter?(command)
        /jupyter\s*notebook$/.match?(command)
      end
    end
  end
end
