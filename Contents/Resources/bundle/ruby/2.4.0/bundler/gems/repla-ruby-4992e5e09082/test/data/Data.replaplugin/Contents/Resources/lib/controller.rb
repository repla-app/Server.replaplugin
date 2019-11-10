require_relative 'view'

module Repla
  module Data
    class Controller < Repla::Controller
      def initialize
        @view = View.new
      end

      def add_key_value(key, value)
        value = value.dup
        value.chomp! if value
        @view.add_key_value(key, value)
      end

      def value_for_key(key)
        @view.value_for_key(key)
      end
    end
  end
end
