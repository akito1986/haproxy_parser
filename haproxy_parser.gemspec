# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'haproxy_parser/version'

Gem::Specification.new do |spec|
  spec.name          = "haproxy_parser"
  spec.version       = HaproxyParser::VERSION
  spec.authors       = ["Akito Ueno"]
  spec.email         = ["aueno@idcf.jp"]

  spec.summary       = %q{This tool is a parser of haproxy.cfg.}
  spec.description   = %q{This tool parses haproxy.cfg, and gets parameters in sections which include frontend, backend, server.}
  spec.homepage      = "https://github.com/akito1986/haproxy_parser"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.12"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"

  spec.add_dependency "activesupport"
  spec.add_dependency "systemu"
end
