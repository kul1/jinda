module Jinda
  class Engine < ::Rails::Engine
    mattr_accessor :author_class
    isolate_namespace Jinda
  end
end
