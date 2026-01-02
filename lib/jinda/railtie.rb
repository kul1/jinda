# frozen_string_literal: true

require 'jinda'
require 'jinda/helpers'

module Jinda
  require 'rails'
  class Railtie < Rails::Railtie
    initializer 'testing' do |_app|
      ActiveSupport.on_load(:action_controller) { include Jinda::Helpers }
    end
    rake_tasks do
      load 'tasks/jinda.rake'
    end
  end
end

module ApplicationHelper
  include Jinda::Helpers
end
