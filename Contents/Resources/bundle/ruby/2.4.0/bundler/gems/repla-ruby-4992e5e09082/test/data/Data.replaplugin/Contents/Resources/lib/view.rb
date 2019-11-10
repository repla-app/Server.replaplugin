module Repla
  module Data
    class View < Repla::View
      ROOT_ACCESS_DIRECTORY = File.join(__dir__,
                                        '../../../../../../')
      HTML_DIRECTORY = File.join(__dir__, '../html/')
      VIEW_TEMPLATE = File.join(HTML_DIRECTORY, 'index.html')

      def initialize
        super
        self.root_access_directory_path = File.expand_path(
          ROOT_ACCESS_DIRECTORY
        )
        load_file(VIEW_TEMPLATE)
      end

      ADD_KEY_VALUE_JAVASCRIPT_FUNCTION = 'addKeyValue'.freeze
      def add_key_value(key, value)
        do_javascript_function(ADD_KEY_VALUE_JAVASCRIPT_FUNCTION, [key, value])
      end

      VALUE_FOR_KEY_JAVASCRIPT_FUNCTION = 'valueForKey'.freeze
      def value_for_key(key)
        value = do_javascript_function(VALUE_FOR_KEY_JAVASCRIPT_FUNCTION, [key])
        value.chomp! if value
        value
      end
    end
  end
end
