module Repla
  module Server
    EXPRESS_PORT = 3000
    JUPYTER_SUFFIX = ' --no-browser'.freeze
    # Customizer
    class Customizer
      def self.customize(command, options = {})
        command = command.dup
        options = options.dup
        command << JUPYTER_SUFFIX if customizable_jupyter?(command)
        [command, options]
      end

      def self.customizable_jupyter?(command)
        /jupyter\s*notebook$/.match?(command)
      end
    end
  end
end
