# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'lawyer/version'

Gem::Specification.new do |spec|
  spec.name          = "lawyer"
  spec.version       = Lawyer::VERSION
  spec.authors       = ["John Cinnamond"]
  spec.email         = ["jc@panagile.com"]
  spec.summary       = %q{Strong Duck Typing for Ruby}
  spec.homepage      = "http://github.com/jcinnamond/lawyer"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(spec)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec", "~> 3.1"
end
