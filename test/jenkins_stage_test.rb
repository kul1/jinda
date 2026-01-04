# frozen_string_literal: true

require 'minitest/autorun'
require 'fileutils'
require 'open3'

# Test suite for Jenkins CI pipeline stages
#
# This test verifies that the "Test Generated Application" Jenkins stage
# executes successfully and performs the expected operations.
#
# Usage:
#   ruby test/jenkins_stage_test.rb
#
class JenkinsStageTest < Minitest::Test
  JINDA_ROOT = File.expand_path('..', __dir__)
  JENKINSFILE_PATH = File.join(JINDA_ROOT, 'ci/Jenkinsfile')

  def test_01_jenkinsfile_exists
    assert File.exist?(JENKINSFILE_PATH),
           'Jenkinsfile should exist at ci/Jenkinsfile'
  end

  def test_02_jenkinsfile_contains_required_test_stages
    content = File.read(JENKINSFILE_PATH)

    # New simplified Jenkinsfile uses Rake tasks
    assert_includes content, "stage('Unit Tests')",
                    'Jenkinsfile should contain "Unit Tests" stage'
    assert_includes content, "stage('Installation Tests')",
                    'Jenkinsfile should contain "Installation Tests" stage'
    assert_includes content, "stage('Integration Tests')",
                    'Jenkinsfile should contain "Integration Tests" stage'
  end

  def test_03_stage_includes_bundle_install_step
    content = File.read(JENKINSFILE_PATH)

    assert_includes content, 'bundle install',
                    'Stage should include bundle install step for generated app'
  end

  def test_04_stage_uses_rake_tasks
    content = File.read(JENKINSFILE_PATH)

    assert_includes content, 'rake test:unit',
                    'Should use rake test:unit'
    assert_includes content, 'rake test:installation',
                    'Should use rake test:installation'
    assert_includes content, 'rake test:integration',
                    'Should use rake test:integration'
  end

  def test_05_stage_runs_tests_in_parallel
    content = File.read(JENKINSFILE_PATH)

    assert_includes content, 'parallel {',
                    'Should have parallel test execution'
    assert_includes content, "stage('RuboCop - Root')",
                    'Should run RuboCop in parallel'
    assert_includes content, "stage('Unit Tests')",
                    'Should run unit tests in parallel'
  end

  def test_06_stage_installs_dependencies
    content = File.read(JENKINSFILE_PATH)

    assert_includes content, 'gem install bundler',
                    'Should install bundler'
    assert_includes content, 'gem install rubocop',
                    'Should install rubocop'
  end

  def test_07_stage_builds_gem
    content = File.read(JENKINSFILE_PATH)

    assert_includes content, "stage('Build Gem')",
                    'Should have Build Gem stage'
    assert_includes content, 'gem build jinda.gemspec',
                    'Should build gem'
  end

  def test_08_stage_validates_gem
    content = File.read(JENKINSFILE_PATH)

    assert_includes content, "stage('Validate Gem')",
                    'Should have Validate Gem stage'
    assert_includes content, 'gem specification',
                    'Should validate gem specification'
  end

  def test_09_stage_starts_mongodb
    content = File.read(JENKINSFILE_PATH)

    assert_includes content, "stage('Start MongoDB')",
                    'Should have Start MongoDB stage'
    assert_includes content, 'docker run',
                    'Should start MongoDB in Docker'
  end

  def test_10_stage_handles_cleanup
    content = File.read(JENKINSFILE_PATH)

    assert_includes content, 'post {',
                    'Should have post-build actions'
    assert_includes content, 'docker stop',
                    'Should stop MongoDB container'
    assert_includes content, 'docker rm',
                    'Should remove MongoDB container'
  end

  def test_11_stage_archives_artifacts
    content = File.read(JENKINSFILE_PATH)

    assert_includes content, 'archiveArtifacts',
                    'Should archive artifacts'
    assert_includes content, 'jinda-*.gem',
                    'Should archive gem file'
  end

  def test_12_jenkinsfile_syntax_valid
    # Test that Jenkinsfile has valid Groovy syntax structure
    content = File.read(JENKINSFILE_PATH)

    assert_includes content, 'pipeline {',
                    'Jenkinsfile should start with pipeline block'
    assert_includes content, 'stages {',
                    'Jenkinsfile should contain stages block'
    assert_includes content, 'post {',
                    'Jenkinsfile should contain post block'

    # Count braces to ensure they're balanced
    open_braces = content.scan('{').count
    close_braces = content.scan('}').count

    assert_equal open_braces, close_braces,
                 'Jenkinsfile should have balanced braces'
  end

  def test_13_stage_executes_in_correct_order
    content = File.read(JENKINSFILE_PATH)

    # Extract stage order
    stage_matches = content.scan(/stage\('([^']+)'\)/).flatten

    unit_index = stage_matches.index('Unit Tests')
    installation_index = stage_matches.index('Installation Tests')
    integration_index = stage_matches.index('Integration Tests')

    refute_nil unit_index, 'Unit Tests stage should exist'
    refute_nil installation_index, 'Installation Tests stage should exist'
    refute_nil integration_index, 'Integration Tests stage should exist'
    
    assert installation_index > unit_index,
           'Installation should run after Unit Tests'
    assert integration_index > installation_index,
           'Integration should run after Installation'
  end

  def test_14_stage_uses_correct_environment_variables
    content = File.read(JENKINSFILE_PATH)

    assert_includes content, '${WORKSPACE}',
                    'Stage should use WORKSPACE environment variable'
    assert_includes content, 'tmp/jinda_tests',
                    'Stage should use standard test directory'
  end

  def test_15_stage_has_error_handling
    content = File.read(JENKINSFILE_PATH)

    # Check error handling in post blocks and cleanup
    post_content = content[/post \{.*?\}/m]

    assert_includes content, 'always {',
                    'Should have always block for cleanup'
    assert_includes content, '|| true',
                    'Cleanup steps should not fail build'
    assert_includes content, 'success {',
                    'Should have success handler'
    assert_includes content, 'failure {',
                    'Should have failure handler'
  end
end
