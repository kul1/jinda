# frozen_string_literal: true

require 'rake/testtask'
begin
  require 'rubocop/rake_task'
  # RuboCop task
  RuboCop::RakeTask.new(:rubocop) do |task|
    task.options       = ['--config', '.rubocop.yml']
    task.fail_on_error = true
  end
rescue LoadError
  task :rubocop do
    puts 'RuboCop not installed. Skipping rubocop task.'
  end
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

# Default task runs both rubocop and installation tests
task default: %i[rubocop test]

task console: :environment do
  exec 'irb -r jinda -I ./lib'
end
