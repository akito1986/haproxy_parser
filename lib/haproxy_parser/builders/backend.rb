require "haproxy_parser/builders/base"
require "haproxy_parser/builders/server_parser"

module HaproxyParser
  module Builders
    class Backend < Base
      def mode
        @mode ||= dig_data("mode")
      end

      def balance
        @balance ||= dig_data("balance")
      end

      def servers
        @servers ||= [].tap do |arr|
          if line_servers[0].is_a?(Array)
            line_servers.each do |line_server|
              arr << ServerParser.new(
                line: line_server,
                backend_name: name
              )
            end
          else
            arr << ServerParser.new(
              line: line_servers,
              backend_name: name
            )
          end
        end
      end

      private

      def default_values
        {
          mode: "tcp"
        }
      end

      def line_servers
        @line_servers ||= dig_data("server")
      end
    end
  end
end
