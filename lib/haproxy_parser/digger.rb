require "active_support"
require "active_support/core_ext"
module HaproxyParser
  class Digger
    attr_reader :data, :delimter
    def initialize(data:, delimter: ".")
      @data = data.with_indifferent_access
      @delimter = delimter
    end

    def value(attr)
      digged_data = data
      attr.split(delimter).each do |key|
        unless digged_data.key?(key)
          digged_data = nil
          break
        end
        digged_data = digged_data[key]
      end
      digged_data
    end
  end
end
