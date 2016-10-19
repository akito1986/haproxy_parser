require "active_support"
require "active_support/core_ext"

module HaproxyParser
  module Sections
    class Base
      attr_reader :name, :attr_lines
      def initialize(lines)
        @name = lines[0][1]
        @attr_lines = lines[1..-1]
      end

      def items
        @items ||= {}.tap do |data|
          counter = {}
          attr_lines.each do |line|
            if data.key?(line[0])
              if 1 == counter[line[0]]
                data[line[0]] = [] << data[line[0]] << attr_value(line)
              else
                data[line[0]] << attr_value(line)
              end
            else
              data[line[0]] = attr_value(line)
            end
            counter[line[0]] ? counter[line[0]] += 1 : counter[line[0]] = 1
          end
          data[:name] = name
          break data
        end
      end

      def attr_value(line)
        case line.size
        when 1
          ""
        when 2
          line[1]
        else
          line[1..-1]
        end
      end
    end
  end
end
