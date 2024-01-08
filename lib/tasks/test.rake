namespace :custom_tests do
  desc "Run all tests"
  task :run_tests do
    system("bundle exec rails test")
  end
end

task run_tests: ['custom_tests:run_tests']

