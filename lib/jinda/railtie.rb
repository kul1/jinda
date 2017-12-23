require 'jinda'
require 'jinda/helpers'

module Jinda
  require 'rails'
  class Railtie < Rails::Railtie
    initializer "testing" do |app|
      ActionController::Base.send :include, Jinda::Helpers
    end
    rake_tasks do
      load "tasks/jinda.rake"
    end
  end
end

module ApplicationHelper
  include Jinda::Helpers
end
