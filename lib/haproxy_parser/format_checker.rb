require "tempfile"
require "systemu"

module HaproxyParser
  class FormatChecker
    FormatError = Class.new(StandardError)
    attr_accessor :result
    attr_reader :path
    def initialize(path)
      @path = path
    end

    def run
      check
      raise(FormatError, result) if result
    end

    def lines
      @lines ||= [].tap do |arr|
        File.open(path, "r") do |f|
          f.each_line do |line|
            next if /\s+(user|group)\s+/ =~ line
            arr << line
          end
        end
      end
    end

    def check
      # create file whose user, group is deleted. #
      tmp_file = Tempfile.open("haproxy_parser") do |tmp_f|
        lines.each do |line|
          tmp_f.print(line)
        end
        tmp_f
      end
      status,_,stderr = systemu "haproxy -c -f #{tmp_file.path}"
      tmp_file.unlink
      @result = stderr unless status.success?
    end
  end
end
