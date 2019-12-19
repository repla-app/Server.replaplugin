module Repla
  module Server
    EXPRESS_PORT = 3000
    JUPYTER_SUFFIX = ' --no-browser'.freeze
    # Customizer
    class Customizer
      def self.customize(command, options = {})
        command = command.dup
        options = options.dup
        options[:file_refresh] = false if disable_file_refresh?(options,
                                                                pwd,
                                                                home)
        command << JUPYTER_SUFFIX if customizable_jupyter?(command)
        [command, options]
      end

      def self.customizable_jupyter?(command)
        /jupyter\s*notebook$/.match?(command)
      end

      def self.disable_file_refresh?(options, pwd, home)
        return false unless options[:file_refresh].nil?

        return true if pwd == home

        return true if pwd == File.join(home, 'Library')
      end
    end
  end
end
