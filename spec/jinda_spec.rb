# frozen_string_literal: true

require_relative "../lib/jinda/gem_helpers"
require_relative "../lib/generators/jinda/templates/app/models/jinda/module"
require_relative "../lib/generators/jinda/templates/app/models/jinda/service"
Dir["#{File.dirname(__FILE__)}./lib/generators/jinda/templates/app/models/jinda"].each { |file| puts file }
require "dotenv"
Dotenv.load
