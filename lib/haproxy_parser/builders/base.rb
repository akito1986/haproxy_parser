require "haproxy_parser/digger"
module HaproxyParser
  module Builders
    class Base
      attr_reader :section, :default
      def initialize(section:, default: {})
        @section = section
        @default = default
      end

      def attributes
        raise(NotImplementedError)
      end

      def name
        @name ||= dig_data("name")
      end

      private

      def section_digger
        @section_digger ||= Digger.new(data: section)
      end

      def defalut_digger
        @defalut_digger ||= Digger.new(data: default)
      end

      def default_values_digger
        @default_values_digger ||= Digger.new(data: default_values)
      end

      def default_values
        raise(NotImplementedError)
      end

      def dig_data(attr)
        [
          section_digger.value(attr),
          defalut_digger.value(attr),
          default_values_digger.value(attr)
        ].select { |value| value}[0]
      end
    end
  end
end
