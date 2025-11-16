# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'jinda/version'

Gem::Specification.new do |spec|
  spec.name          = 'jinda'
  spec.version       = Jinda::VERSION
  spec.authors       = ['Prateep Kul', 'Korakot Leemakdej']
  spec.email         = ['1.0@kul.asia']

  spec.summary       = %q{Rails workflow from mind map: Freemind}
  spec.description   = %q{Generate Rails workflow from mind map: Freemind}
  spec.homepage      = 'https://github.com/kul1/jinda'
  spec.license       = 'MIT'
  spec.files         = Dir['Rakefile', '{app,config,bin,lib,test}/**/*', 'README*', 'LICENSE*', 'lib/generators/jinda/templates/.env'] & `git ls-files -z`.split("\0")
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']
  
  # Updated for Ruby 3.1+ and Rails 7.0+
  spec.required_ruby_version = '>= 3.1.0'
  
  # Development dependencies
  spec.add_development_dependency 'mongoid', '~> 7.5'
  spec.add_development_dependency 'mongoid-rspec', '~> 2.1.0'
  
  # Runtime dependencies - Updated for Rails 7
  spec.add_runtime_dependency 'rails', '~> 7.0.0'
  spec.add_runtime_dependency 'rexml', '~> 3.2'
  spec.add_runtime_dependency 'nokogiri', '~> 1.13.0'
  spec.add_runtime_dependency 'bson', '~> 4.15'
  spec.add_runtime_dependency 'psych', '~> 5.0'
end
