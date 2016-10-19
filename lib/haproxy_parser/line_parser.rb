module HaproxyParser
  class LineParser
    attr_reader :list
    def initialize(list)
      @list = list
    end

    def value(attr)
      nil.tap do |ret|
        list.each_with_index do |v, i|
          ret = list[i+1] if attr == v
        end
        break ret
      end
    end
  end
end
