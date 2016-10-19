module HaproxyParser
  module Builders
    class BindParser
      attr_reader :line
      def initialize(line)
        @line = if line.is_a?(Array)
                  line
                else
                  [] << line
                end
      end

      def ipaddress
        @address ||= line[0].split(":")[0]
      end

      def port
        @port ||= line[0].split(":")[1]
      end

      def ssl
        @ssl ||= line.include?("ssl")
      end
    end
  end
end
