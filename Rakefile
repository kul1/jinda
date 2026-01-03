# frozen_string_literal: true

require 'rake/testtask'

# RuboCop task (optional - only loads if gem is available)
# This makes the Rakefile work in CI environments where RuboCop may not be installed yet
begin
  require 'rubocop/rake_task'
  RuboCop::RakeTask.new(:rubocop) do |task|
    task.options       = ['--config', '.rubocop.yml']
    task.fail_on_error = true
  end
  RUBOCOP_AVAILABLE = true
rescue LoadError
  # RuboCop not available - will be skipped in default task
  RUBOCOP_AVAILABLE = false
end

# Installation test task (runs first)
Rake::TestTask.new(:test_installation) do |t|
  t.libs << 'test'
  t.libs << 'lib'
  t.test_files = FileList['test/installation_test.rb']
  t.verbose    = true
  t.warning    = false
end

# Integration test task (runs after installation)
Rake::TestTask.new(:test_integration) do |t|
  t.libs << 'test'
  t.libs << 'lib'
  t.test_files = FileList['test/integration_test.rb']
  t.verbose    = true
  t.warning    = false
end

# All tests task (runs both in sequence)
task test_all: %i[test_installation test_integration]

# Default test task (installation only for CI)
Rake::TestTask.new(:test) do |t|
  t.libs << 'test'
  t.libs << 'lib'
  t.test_files = FileList['test/installation_test.rb']
  t.verbose    = true
  t.warning    = false
end

# Default task - only includes rubocop if available
# In CI, separate workflows handle RuboCop and tests independently
if defined?(RUBOCOP_AVAILABLE) && RUBOCOP_AVAILABLE
  task default: %i[rubocop test]
else
  # RuboCop not installed - just run tests
  task default: :test
end

task console: :environment do
  exec 'irb -r jinda -I ./lib'
end
