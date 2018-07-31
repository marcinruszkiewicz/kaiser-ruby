
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "kaiser_ruby/version"

Gem::Specification.new do |spec|
  spec.name          = "kaiser-ruby"
  spec.version       = KaiserRuby::VERSION
  spec.authors       = ["Marcin Ruszkiewicz"]
  spec.email         = ["marcin.ruszkiewicz@polcode.net"]

  spec.summary       = %q{Transpiler of Rockstar language to Ruby}
  spec.homepage      = "https://github.com/marcinruszkiewicz/kaiser-ruby"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "pry"
  spec.add_dependency "parslet"
end
