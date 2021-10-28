require 'pry'
require 'rails'
require 'active_support/core_ext/regexp'
require 'mongoid-rspec'
# require 'rails/mongoid'
Mongoid.load!('./spec/config/mongoid.yml')
# require_relative '../lib/generators/jinda/templates/app/models/jinda/module.rb'
# require_relative '../lib/generators/jinda/templates/app/models/jinda/service.rb'
#Dir[File.dirname(__FILE__) + './lib/generators/jinda/templates/app/models/jinda'].each {|file| puts file}
require 'dotenv'
Dotenv.load
