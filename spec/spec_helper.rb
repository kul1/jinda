require 'active_support/core_ext/regexp'
require 'mongoid'
require_relative '../lib/generators/jinda/templates/app/models/jinda/module.rb'
require_relative '../lib/generators/jinda/templates/app/models/jinda/service.rb'
#Dir[File.dirname(__FILE__) + './lib/generators/jinda/templates/app/models/jinda'].each {|file| puts file}
require 'dotenv'
Dotenv.load
Mongoid.load!('./mongoid.yml')
