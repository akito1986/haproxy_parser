require "active_support"
require "active_support/core_ext"

module HaproxyParser
  class SectionCollector
    SECTIONS = %w(defaults global frontend backend listen)
    attr_reader :path
    def initialize(path)
      @path = path
    end

    SECTIONS.each do |section_kind|
      define_method(section_kind.pluralize) do
        sections.select do |section|
          section_kind == section[0][0]
        end
      end
    end

    private

    def sections
      @sections ||= build_sections
    end

    def build_sections
      [].tap do |arr|
        section_indexes.each_with_index do |section_index, i|
          size = 0
          case i
          when section_indexes.size - 1
            size = lines.size - section_index
          else
            size = section_indexes[i + 1] - section_index
          end
          arr << lines[section_index, size]
        end
      end
    end

    def section_indexes
      @section_indexes ||= [].tap do |arr|
        index = 0
        lines.each do |line|
          arr << index if SECTIONS.include?(line[0])
          index += 1
        end
      end
    end

    def lines
      @lines ||= [].tap do |arr|
        File.open(path, "r") do |f|
          f.each_line do |line|
            line_list = line.strip.chomp.sub(/#.*/, "").split(/ +/)
            next if (line_list.size == 0) || unnecessary?(line_list)
            arr << line_list
          end
        end
      end
    end

    def unnecessary?(line)
      line.size == 1 && line[0].empty?
    end
  end
end
