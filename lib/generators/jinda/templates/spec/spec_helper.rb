# https://www.natashatherobot.com/rails-test-omniauth-sessions-controller/
# spec_helper.rb
require 'rubygems'
require 'capybara/rspec' 
# Set up the mock  
require 'support/omniauth_macros'
require 'valid_attribute'

# See http://rubydoc.info/gems/rspec-core/RSpec/Core/Configuration
RSpec.configure do |config|
  # config.include SpecTestHelper, :type => :controller
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
    expectations.syntax = [:expect, :should]
  end
  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end
  config.shared_context_metadata_behavior = :apply_to_host_groups

# https://github.com/DatabaseCleaner/database_cleaner #
#  config.use_transactional_fixtures = false
	# https://stackoverflow.com/questions/15148585/undefined-method-visit-when-using-rspec-and-capybara-in-rails
	config.include Capybara::DSL

	# https://stackoverflow.com/questions/21445164/set-chrome-as-default-browser-for-rspec-capybara/30551595
	Capybara.register_driver :chrome do |app|
		  Capybara::Selenium::Driver.new(app, :browser => :chrome)
	end
	Capybara.javascript_driver = :chrome

  config.before(:suite) do
    if config.use_transactional_fixtures?
      raise(<<-MSG)
        Delete line `config.use_transactional_fixtures = true` from rails_helper.rb
        (or set it to false) to prevent uncommitted transactions being used in
        JavaScript-dependent specs.

        During testing, the app-under-test that the browser driver connects to
        uses a different database connection to the database connection used by
        the spec. The app's database connection would not be able to access
        uncommitted transaction data setup over the spec's database connection.
      MSG
    end
    DatabaseCleaner.clean_with(:truncation)
  end

  config.before(:each, :js => true) do
    #DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.strategy = :truncation
  end

  config.before(:each, type: :feature) do
    # :rack_test driver's Rack app under test shares database connection
    # with the specs, so continue to use transaction strategy for speed.
    driver_shares_db_connection_with_specs = Capybara.current_driver == :rack_test

    unless driver_shares_db_connection_with_specs
      # Driver is probably for an external browser with an app
      # under test that does *not* share a database connection with the
      # specs, so use truncation strategy.
      # DatabaseCleaner.strategy = :truncation
      DatabaseCleaner[:mongoid].strategy = :truncation

    end
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.append_after(:each) do
    DatabaseCleaner.clean
  end
#  https://github.com/DatabaseCleaner/database_cleaner #

end
