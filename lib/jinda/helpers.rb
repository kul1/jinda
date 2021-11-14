# -*- encoding : utf-8 -*-
require 'active_support'
require 'active_support/core_ext'

module Jinda
  module Helpers
    require "rexml/document"
    include REXML
    require_relative 'date_helpers'
    require_relative 'gen_helpers'
    require_relative 'gen_class'
    require_relative 'gen_freemind'
    require_relative 'gem_helpers'
    require_relative 'refresh'
    require_relative 'init_vars'
    require_relative 'themes'
    require_relative 'gen_xmain'
    require_relative 'gen_models'
    require_relative 'date_helpers'
    require_relative 'rake_views'
    require_relative 'gen_runseq'
    require_relative 'gen_services'
    require_relative 'gen_controller'
    require_relative 'get_app'
    require_relative 'gen_modules'
  end
end

