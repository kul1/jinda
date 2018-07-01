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
	spec.files         = Dir['Rakefile', '{bin,lib,test}/**/*', 'README*', 'LICENSE*', 'lib/generators/jinda/templates/.env'] & `git ls-files -z`.split("\0")
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.16'
  spec.add_development_dependency 'rake', '~> 10.0'
	spec.add_development_dependency 'rspec', '~> 3.7', '~> 3.7.0'
	spec.add_development_dependency 'guard', '~> 0'
	spec.add_development_dependency 'guard-rspec', '~> 4.7', '>= 4.7.3'
	spec.add_development_dependency 'pry-byebug', '~> 3.4'
	spec.add_development_dependency 'activesupport','~> 4.1.11', '>= 4.1.11'
	spec.add_development_dependency 'mongoid', '~> 4.1.11', '>= 4.1.11'
	spec.add_development_dependency 'dotenv-rails', '~> 2.1', '>= 2.1.1'
end
