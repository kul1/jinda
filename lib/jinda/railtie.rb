# frozen_string_literal: true

require 'jinda'
require 'jinda/helpers'

module Jinda
  require 'rails'
  class Railtie < Rails::Railtie
    initializer 'testing' do |_app|
      ActiveSupport.on_load(:action_controller) { include Jinda::Helpers }
    end
    
    initializer 'jinda.omniauth', after: :load_config_initializers do |_app|
      # Ensure OmniAuth allows both GET and POST for callback routes
      OmniAuth.config.allowed_request_methods = [:post, :get] if defined?(OmniAuth)
    end
    
    rake_tasks do
      load 'tasks/jinda.rake'
    end
  end
end

module ApplicationHelper
  include Jinda::Helpers
end
