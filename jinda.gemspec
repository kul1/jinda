# frozen_string_literal: true

lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "jinda/version"

Gem::Specification.new do |spec|
  spec.name          = "jinda"
  spec.version       = Jinda::VERSION
  spec.authors       = ["Prateep Kul", "Korakot Leemakdej"]
  spec.email         = ["1.0@kul.asia"]

  spec.summary       = "Rails workflow from mind map: Freemind"
  spec.description   = "Generate Rails workflow from mind map: Freemind"
  spec.homepage      = "https://github.com/kul1/jinda"
  spec.license       = "MIT"
  spec.files         = Dir["Rakefile", "{app,config,bin,lib,test}/**/*", "README*", "LICENSE*",
                           "lib/generators/jinda/templates/.env"] & `git ls-files -z`.split("\0")
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # Updated for Ruby 3.3+ and Rails 7.1+
  spec.required_ruby_version = ">= 3.3.0"

  # Development dependencies
  spec.add_development_dependency "mongoid", "~> 7.5"
  spec.add_development_dependency "mongoid-rspec", "~> 2.1.0"
  spec.add_development_dependency "rubocop", ">= 1.60"
  spec.add_development_dependency "rubocop-minitest"
  spec.add_development_dependency "rubocop-performance"
  spec.add_development_dependency "rubocop-rails"

  # Runtime dependencies - Updated for Rails 7.1
  spec.add_dependency "bson", "~> 4.15"
  spec.add_dependency "nokogiri", "~> 1.16"
  spec.add_dependency "psych", "~> 5.0"
  spec.add_dependency "rails", "~> 7.1.0"
  spec.add_dependency "rexml", "~> 3.2"
  spec.metadata["rubygems_mfa_required"] = "true"
end
