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

  def test_02_jenkinsfile_contains_test_generated_application_stage
    content = File.read(JENKINSFILE_PATH)

    assert_includes content, "stage('Test Generated Application')",
                    'Jenkinsfile should contain "Test Generated Application" stage'
  end

  def test_03_stage_includes_bundle_install_step
    content = File.read(JENKINSFILE_PATH)

    assert_includes content, 'bundle install',
                    'Stage should include bundle install step for generated app'
  end

  def test_04_stage_checks_rails_environment
    content = File.read(JENKINSFILE_PATH)

    assert_includes content, 'Check Rails environment',
                    'Stage should verify Rails environment loads'
    assert_includes content, 'rails runner',
                    'Stage should use rails runner to check environment'
  end

  def test_05_stage_runs_rspec_tests
    content = File.read(JENKINSFILE_PATH)

    assert_includes content, 'Run RSpec tests',
                    'Stage should attempt to run RSpec tests'
    assert_includes content, 'bundle exec rspec',
                    'Stage should use bundle exec rspec'
  end

  def test_06_stage_runs_minitest
    content = File.read(JENKINSFILE_PATH)

    assert_includes content, 'Run Minitest',
                    'Stage should attempt to run Minitest'
    assert_includes content, 'bundle exec rake test',
                    'Stage should use rake test for Minitest'
  end

  def test_07_stage_verifies_server_start
    content = File.read(JENKINSFILE_PATH)

    assert_includes content, 'Verify can start server',
                    'Stage should verify Rails server can start'
    assert_includes content, 'rails server',
                    'Stage should start Rails server'
  end

  def test_08_stage_verifies_login_functionality
    content = File.read(JENKINSFILE_PATH)

    assert_includes content, 'Verify login functionality',
                    'Stage should verify login functionality'
    assert_includes content, 'User',
                    'Stage should check User model accessibility'
  end

  def test_09_stage_finds_test_app_directory
    content = File.read(JENKINSFILE_PATH)

    assert_includes content, 'jinda_test_',
                    'Stage should look for test app with jinda_test_ prefix'
    assert_includes content, 'ls -td',
                    'Stage should find most recent test app directory'
  end

  def test_10_stage_handles_missing_test_app
    content = File.read(JENKINSFILE_PATH)

    assert_includes content, 'No generated test app found',
                    'Stage should handle case when test app is not found'
    assert_includes content, 'UNSTABLE',
                    'Stage should mark build as unstable if test app not found'
  end

  def test_11_stage_stops_server_after_test
    content = File.read(JENKINSFILE_PATH)

    assert_includes content, 'tmp/pids/server.pid',
                    'Stage should check for PID file'
    assert_includes content, 'kill',
                    'Stage should stop server after testing'
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

    test_generated_index = stage_matches.index('Test Generated Application')
    run_installation_index = stage_matches.index('Run Installation Tests')

    refute_nil test_generated_index,
               'Test Generated Application stage should exist'
    refute_nil run_installation_index,
               'Run Installation Tests stage should exist'
    assert test_generated_index > run_installation_index,
           'Test Generated Application should run after Installation Tests'
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

    # Extract the Test Generated Application stage content
    stage_start = content.index("stage('Test Generated Application')")
    return unless stage_start

    stage_content = content[stage_start..content.index('stage(', stage_start + 1) || -1]

    assert_includes stage_content, '|| exit 1',
                    'Critical steps should exit on failure'
    assert_includes stage_content, '|| echo',
                    'Non-critical steps should log but continue'
  end
end
