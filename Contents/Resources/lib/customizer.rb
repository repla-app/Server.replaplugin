module Repla
  module Server
    # Customizer
    class Customizer
      def self.customize(command, options)
        if customizable_express(command)
          puts 'Express'
        elsif customizable_jupyter(command)
          puts 'Jupyter'
        end
      end

      def self.customizable_express?(command)
        /npm start/.match?(command)
      end

      def self.customizable_jupyter?(command)
        /jupyter notebook/.match?(command)
      end
    end
  end
end
