require "systemu"
require "haproxy_parser/section_collector"
require "haproxy_parser/format_checker"
require "haproxy_parser/builders"

module HaproxyParser
  class Config
    SECTIONS = %w(global defaults frontend backend)
    attr_reader :path, :servers
    def initialize(path)
      @path = path
    end

    def check_format!
      HaproxyParser::FormatChecker.new(
        path
      ).run
    end

    def parse
      check_format!
      build
      self
    end

    def global
      @global ||= build_global
    end

    def frontends
      @frontends ||= []
    end

    def backends
      @backends ||= []
    end

    private

    def build
      build_global
      build_frontend_backend
      build_servers
    end

    def build_global
      HaproxyParser::Builders::Global.new(
        section: global_sections[-1].items
      )
    end

    def build_frontend_backend
      frontend_sections.each do |frontend_section|
        built_frontend = HaproxyParser::Builders::Frontend.new(
          section: frontend_section.items,
          default: default_section_items
        )
        built_backend = build_backend(built_frontend)
        built_frontend.backend = built_backend
        frontends << built_frontend
      end
    end

    def build_servers
      @servers = [].tap do |arr|
        backends.each do |backend|
          arr += backend.servers
        end
        break arr
      end
    end

    def build_backend(frontend)
      name = frontend.backend_name
      return find_backend(name) if find_backend(name).present?
      built_backend = HaproxyParser::Builders::Backend.new(
        section: backend_section(name).items,
        default: default_section_items
      ).tap do |backend|
        backends << backend
      end
    end

    def find_backend(name)
      backends.select { |backend| backend.name == name }[0]
    end

    def default_section_items
      @default_section_items ||= default_sections[-1].items
    end

    def backend_section(name)
      backend_sections.select do |section|
        section.name == name
      end[0]
    end

    SECTIONS.each do |section|
      name = section.pluralize
      class_name = section.singularize
      method_name = "#{class_name}_sections"
      require "haproxy_parser/sections/#{class_name}"
      sym = "@#{method_name}".to_sym
      define_method(method_name) do
        if instance_variable_defined?(sym)
          instance_variable_get(sym)
        else
          data = section_collector.public_send(name).map do |item|
            "HaproxyParser::Sections::#{class_name.camelize}"
            .constantize
            .new(item)
          end
          instance_variable_set(sym, data)
        end
      end
    end

    def section_collector
      @section_collector ||= SectionCollector.new(
        path
      )
    end
  end
end
