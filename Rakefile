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

# Unit tests - fast static analysis tests (no app generation)
Rake::TestTask.new(:test_unit) do |t|
  t.libs << 'test'
  t.libs << 'lib'
  t.test_files = FileList[
    'test/jenkins_stage_test.rb',
    'test/note_model_test.rb',
    'test/api_notes_controller_test.rb',
    'test/note_validation_integration_test.rb'
  ]
  t.verbose    = true
  t.warning    = false
end

# Test groups for parallel CI execution
namespace :test do
  desc 'Run unit tests (static analysis - fast)'
  task :unit do
    Rake::Task['test_unit'].invoke
  end

  desc 'Run installation tests (generates test app)'
  task :installation do
    Rake::Task['test_installation'].invoke
  end

  desc 'Run integration tests (uses generated app from installation test)'
  task :integration do
    Rake::Task['test_integration'].invoke
  end

  desc 'Run generated app tests (tests in test/dummy if exists)'
  task :generated_app do
    dummy_path = File.expand_path('test/dummy', __dir__)
    if File.directory?(dummy_path)
      puts "=== Running tests in generated app: #{dummy_path} ==="
      Dir.chdir(dummy_path) do
        sh 'bundle exec rake test' if File.exist?('Rakefile')
        sh 'bundle exec rspec' if File.directory?('spec')
      end
    else
      puts "⚠️  No test/dummy directory found. Run generators first."
      puts "   To create test/dummy: cd test && rails new dummy -BOTJ && cd dummy && [run generators]"
    end
  end

  desc 'Run gem-level tests (unit + installation)'
  task gem: %i[unit installation]

  desc 'Run all tests including generated app'
  task all: %i[unit installation integration]
end

# Default test task (unit + installation for quick local feedback)
task test: %i[test_unit test_installation]

# Convenience task for full test suite
task test_all: ['test:all']

# Default task - only includes rubocop if available
if defined?(RUBOCOP_AVAILABLE) && RUBOCOP_AVAILABLE
  task default: %i[rubocop test]
else
  task default: :test
end

task console: :environment do
  exec 'irb -r jinda -I ./lib'
end
