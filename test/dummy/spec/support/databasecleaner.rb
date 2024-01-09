RSpec.configure do |config|
    config.before(:suite) do
    DatabaseCleaner[:mongoid].strategy = :deletion
  end

  config.before(:each) do
    DatabaseCleaner[:mongoid].start
  end

  config.after(:each) do
    DatabaseCleaner[:mongoid].clean
  end
end
