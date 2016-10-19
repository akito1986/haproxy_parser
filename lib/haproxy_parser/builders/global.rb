require "haproxy_parser/builders/base"

module HaproxyParser
  module Builders
    class Global < Base
      def nbproc
        @nbproc ||= dig_data("nbproc")
      end

      def maxconn
        @maxconn ||= dig_data("maxconn")
      end

      def stats
        @stats ||= dig_data("stats")
      end

      def default_values
        {
          nbproc: 1,
          maxconn: 2000
        }
      end
    end
  end
end
