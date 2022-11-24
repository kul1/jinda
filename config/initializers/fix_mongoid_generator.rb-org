require 'rails/generators'
require 'rails/generators/mongoid/config/config_generator'

if Gem::Version.new(Mongoid::VERSION) >= Gem::Version.new('7.3.0')
  warn("You may need not this file: #{__FILE__}\nAfter https://github.com/mongodb/mongoid/pull/4953 is released.")
end
Mongoid::Generators::ConfigGenerator.class_eval do
  def app_name
    # Rails::Application.subclasses.first.parent.to_s.underscore
    #   No more Module#parent
    #   See https://github.com/rails/rails/commit/167b4153cac0069a21e0bb9689cb16f34f6abbaa
    Rails::Application.subclasses.first.module_parent_name.underscore
  end
end
