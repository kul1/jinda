require 'rake/testtask'
require 'rubocop/rake_task'

# RuboCop task
RuboCop::RakeTask.new(:rubocop) do |task|
  task.options = ['--config', '.rubocop.yml']
  task.fail_on_error = true
end

# Test task
Rake::TestTask.new(:test) do |t|
  t.libs << 'test'
  t.libs << 'lib'
  t.test_files = FileList['test/**/*_test.rb']
  t.verbose = true
  t.warning = false
end

# Default task runs both rubocop and tests
task default: %i[rubocop test]

task :console do
  exec 'irb -r jinda -I ./lib'
end
