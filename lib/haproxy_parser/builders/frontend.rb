require "haproxy_parser/builders/base"
require "haproxy_parser/builders/bind_parser"
module HaproxyParser
  module Builders
    class Frontend < Base
      attr_accessor :backend
      def initialize(section:, default: nil, backend: nil)
        super(section: section, default: default)
        @backend = backend
      end

      def backend_name
        @backend_name ||= if dig_data("use_backend")
          dig_data("use_backend")
        else
          dig_data("default_backend")
        end
      end

      def ipaddress
        @ipaddress ||= bind_parser.ipaddress
      end

      def port
        @port ||= bind_parser.port
      end

      def ssl
        @ssl ||= bind_parser.ssl
      end

      def mode
        @mode ||= dig_data("mode")
      end

      private

      def bind_parser
        @bind_parser ||= BindParser.new(line_of_bind)
      end

      def default_values
        {
          mode: "tcp"
        }
      end

      def line_of_bind
        @line_of_bind ||= dig_data("bind")
      end
    end
  end
end
