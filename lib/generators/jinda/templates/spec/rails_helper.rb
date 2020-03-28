# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f } # Add this at top of file
# Prevent database truncation if the environment is production
abort("The Rails environment is running in production mode!") if Rails.env.production?
require 'rspec/rails'
require 'spec_helper'
require 'support/factory_bot'
Dir[Rails.root.join('spec', 'support', '**', '*.rb')].each { |f| require f }

RSpec.configure  do |config|
  
  # Add create_and_sign_in_user
  config.include AuthenticationHelper, type: :controller

	# To include RequestSpecHelper
	config.include RequestSpecHelper, type: :request

	# config.infer_spec_type_from_file_location!

	# Filter lines from Rails gems in backtraces.
	config.filter_rails_from_backtrace!
	# arbitrary gems may also be filtered via:
	# config.filter_gems_from_backtrace("gem name")



	# Added to make factorybot work
	# FactoryBot.allow_class_lookup = false 
	config.use_transactional_fixtures = false
	config.include FactoryBot::Syntax::Methods
	config.before do
		FactoryBot.find_definitions
	end
	# configure shoulda matchers to use rspec as the test framework and full matcher libraries for rails
	Shoulda::Matchers.configure do |config|
		config.integrate do |with|
			with.test_framework :rspec
			with.library :rails
		end
	end

end
