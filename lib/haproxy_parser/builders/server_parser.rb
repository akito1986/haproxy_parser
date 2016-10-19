require "active_support"
require "active_support/core_ext"
require "haproxy_parser/line_parser"
module HaproxyParser
  module Builders
    class ServerParser
      attr_reader :line, :frontend_port
      def initialize(line:, frontend_port:)
        @line = line
        @frontend_port = frontend_port
      end

      def name
        @name ||= line[0]
      end

      def ipaddress
        @ipaddress ||= line[1].split(":")[0]
      end

      def port
        @port ||=
          if line[1].split(":")[1]
            line[1].split(":")[1]
          else
            frontend_port
          end
      end

      %w(inter rise fall).each do |attr|
        define_method(attr) do
          if line_parser.value(attr)
            line_parser.value(attr)
          else
            default_values[attr]
          end
        end
      end

      private

      def line_parser
        @line_parser ||= HaproxyParser::LineParser.new(
          line
        )
      end

      def default_values
        {
          inter: "2000ms",
          fall: 3,
          rise: 2
        }.with_indifferent_access
      end
    end
  end
end
