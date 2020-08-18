require 'etc'

module Repla
  module Server
    EXPRESS_PORT = 3000
    JUPYTER_SUFFIX = ' --no-browser'.freeze
    # Customizer
    class Customizer
      def initialize(pwd = Dir.pwd, home = Etc.getpwuid.dir)
        @pwd = pwd
        @home = home
      end

      def customize(command, options = {})
        command = command.dup
        options = options.dup
        options[:file_refresh] = false if Customizer.disable_file_refresh?(
          command,
          options,
          @pwd,
          @home
        )
        [command, options]
      end

      def self.disable_file_refresh?(_command, options, pwd, home)
        return false unless options[:file_refresh].nil?

        return true if File.realpath(pwd) == File.realpath(home)

        return true if File.realpath(pwd) == File.realpath(File.join(home,
                                                                     'Library'))

        false
      end
    end
  end
end
