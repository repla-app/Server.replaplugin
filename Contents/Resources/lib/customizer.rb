module Repla
  module Server
    EXPRESS_PORT = 3000
    JUPYTER_SUFFIX = ' --no-browser'.freeze
    # Customizer
    class Customizer
      def self.customize(command, options = {})
        command = command.dup
        options = options.dup
        options[:file_refresh] = false if disable_file_refresh?(command,
                                                                options,
                                                                Dir.pwd,
                                                                Dir.home)
        command << JUPYTER_SUFFIX if customizable_jupyter?(command)
        [command, options]
      end

      def self.customizable_jupyter?(command)
        /jupyter\s*notebook$/.match?(command)
      end

      def self.disable_file_refresh?(command, options, pwd, home)
        return false unless options[:file_refresh].nil?

        return true if customizable_jupyter?(command)

        return true if File.realpath(pwd) == File.realpath(home)

        return true if File.realpath(pwd) == File.realpath(File.join(home,
                                                                     'Library'))

        false
      end
    end
  end
end
