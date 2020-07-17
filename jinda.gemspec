# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'jinda/version'

Gem::Specification.new do |spec|
  spec.name          = 'jinda'
  spec.version       = Jinda::VERSION
  spec.authors       = ['Prateep Kul']
  spec.email         = ['1.0@kul.asia']

  spec.summary       = %q{Rails workflow from mind map: Freemind}
  spec.description   = %q{Generate Rails workflow from mind map: Freemind}
  spec.homepage      = 'https://github.com/kul1/jinda'
  spec.license       = 'MIT'
	spec.files         = Dir['Rakefile', '{app,config,db,lib}/**/*', 'README*',  'Rakefile', 'LICENSE*', 'lib/generators/jinda/templates/.env'] & `git ls-files -z`.split("\0")
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']
  spec.required_ruby_version = '>= 2.5.0'
  spec.add_development_dependency 'mongoid', '~> 4.1.11', '>= 4.1.11'
  spec.add_development_dependency 'rails', '~> 6.0.3', '>= 6.0.3.2'
end
