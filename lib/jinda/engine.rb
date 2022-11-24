require 'jinda/version'
require 'jinda/railtie'
require 'jinda/engine'

module Jinda
  class Engine < ::Rails::Engine
    isolate_namespace Jinda
  end
end
