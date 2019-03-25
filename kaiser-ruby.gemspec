# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'kaiser_ruby/version'

Gem::Specification.new do |spec|
  spec.name          = 'kaiser-ruby'
  spec.version       = KaiserRuby::VERSION
  spec.authors       = ['Marcin Ruszkiewicz']
  spec.email         = ['marcin.ruszkiewicz@polcode.net']

  spec.summary       = 'Transpiler of Rockstar language to Ruby'
  spec.homepage      = 'https://github.com/marcinruszkiewicz/kaiser-ruby'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(spec|examples)/})
  end
  spec.bindir        = 'exe'
  spec.executables   = ['kaiser-ruby']
  spec.require_paths = ['lib']

  spec.required_ruby_version = '>= 2.3'

  spec.add_development_dependency 'bundler', '~> 1.17.0'
  spec.add_development_dependency 'pry'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'rubocop'
  spec.add_dependency 'hashie'
  spec.add_dependency 'thor'
end
