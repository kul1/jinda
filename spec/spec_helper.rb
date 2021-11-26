require 'pry'
require 'rails'
require 'active_support/core_ext/regexp'
require 'mongoid-rspec'
Mongoid.load!('./spec/config/mongoid.yml')
require_relative 'jinda_spec'
require_relative 'jindamind_spec'
