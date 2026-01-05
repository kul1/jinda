require_relative "boot"

require "rails"
# Pick the frameworks you want:
require "active_model/railtie"
require "active_job/railtie"
# require "active_record/railtie"
# require "active_storage/engine"
require "action_controller/railtie"
require "action_mailer/railtie"
# require "action_mailbox/engine"
# require "action_text/engine"
require "action_view/railtie"
require "action_cable/engine"
# require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Dummy
  class Application < Rails::Application

    # Jinda default
    config.generators do |g|
      g.orm             :mongoid
      g.template_engine :haml
      g.test_framework  :rspec
      g.integration_tool :rspec
    end

    # config time zone
    config.time_zone = "Central Time (US & Canada)"

    # gmail config
    # config.action_mailer.delivery_method = :smtp
    # config.action_mailer.smtp_settings = {
    #   :address              => "smtp.gmail.com",
    #   :port                 => 587,
    #   :user_name            => 'user@gmail.com',
    #   :password             => 'secret',
    #   :authentication       => 'plain',
    #   :enable_starttls_auto => true  }
    # config.action_mailer.raise_delivery_errors = true
    # config.action_mailer.perform_deliveries = true
            
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.1

    # Please, add to the `ignore` list any other `lib` subdirectories that do
    # not contain `.rb` files, or that should not be reloaded or eager loaded.
    # Common ones are `templates`, `generators`, or `middleware`, for example.
    config.autoload_lib(ignore: %w(assets tasks))

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")

    # Don't generate system test files.
    config.generators.system_tests = nil
  end
end
