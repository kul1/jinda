# frozen_string_literal: true

require 'minitest/autorun'
require 'fileutils'
require 'open3'
require 'timeout'

# Test suite for generated Jinda application functionality
#
# This test verifies that generated Jinda applications:
# - Correctly install dependencies
# - Can start a Rails server
# - Have proper file structure
#
# Usage:
#   ruby test/generated_app_test.rb
#
# rubocop:disable Style/ClassVars
class GeneratedAppTest < Minitest::Test
  i_suck_and_my_tests_are_order_dependent!

  def self.test_order
    :alpha
  end

  JINDA_GEM_PATH = File.expand_path('..', __dir__)
  TEST_DIR = File.join(Dir.tmpdir, 'jinda_generated_app_test')
  MONGODB_PORT = ENV.fetch('MONGODB_PORT', '27017')
  TEST_APP_NAME = "test_app_#{Time.now.to_i}".freeze

  @@test_app_path = nil
  @@app_created = false

  def setup
    @@test_app_path ||= File.join(TEST_DIR, TEST_APP_NAME)
    @test_app_path = @@test_app_path
    FileUtils.mkdir_p(TEST_DIR)
  end

  Minitest.after_run do
    FileUtils.rm_rf(@@test_app_path) if @@test_app_path && File.exist?(@@test_app_path)
  end

  def test_01_create_test_rails_app
    Dir.chdir(TEST_DIR) do
      _, stderr, status = Open3.capture3(
        'rails', 'new', TEST_APP_NAME,
        '--skip-test', '--skip-bundle', '--skip-active-record'
      )

      assert_predicate status, :success?, "Rails app creation failed: #{stderr}"
      assert File.directory?(@test_app_path), 'App directory not created'
      @@app_created = true
    end
  end

  def test_02_add_jinda_to_gemfile
    skip 'App not created' unless @@app_created

    gemfile_path = File.join(@test_app_path, 'Gemfile')
    File.open(gemfile_path, 'a') do |f|
      f.puts "gem 'jinda', path: '#{JINDA_GEM_PATH}'"
    end

    content = File.read(gemfile_path)
    assert_includes content, "gem 'jinda'", 'Jinda not added to Gemfile'
  end

  def test_03_bundle_install_succeeds
    skip 'App not created' unless @@app_created

    Dir.chdir(@test_app_path) do
      stdout, stderr, status = Open3.capture3('bundle install')

      assert_predicate status, :success?, "Bundle install failed: #{stderr}\n#{stdout}"
      
      # Verify jinda gem is installed
      stdout, = Open3.capture3('bundle show jinda')
      assert_includes stdout, 'jinda', 'Jinda gem not found in bundle'
    end
  end

  def test_04_jinda_install_generator_runs
    skip 'App not created' unless @@app_created

    Dir.chdir(@test_app_path) do
      _, stderr, status = Open3.capture3('rails generate jinda:install')

      assert_predicate status, :success?, "jinda:install failed: #{stderr}"
    end
  end

  def test_05_generated_app_has_required_dependencies
    skip 'App not created' unless @@app_created

    gemfile_path = File.join(@test_app_path, 'Gemfile')
    content = File.read(gemfile_path)

    # Check for critical dependencies added by Jinda
    assert_includes content, 'mongoid', 'Should include mongoid'
    assert_includes content, 'omniauth', 'Should include omniauth'
  end

  def test_06_bundle_install_post_generator
    skip 'App not created' unless @@app_created

    Dir.chdir(@test_app_path) do
      _, stderr, status = Open3.capture3('bundle install')

      assert_predicate status, :success?, 
                       "Post-generator bundle install failed: #{stderr}"
    end
  end

  def test_07_jinda_config_generator_runs
    skip 'App not created' unless @@app_created

    Dir.chdir(@test_app_path) do
      _, stderr, status = Open3.capture3('rails generate jinda:config')

      assert_predicate status, :success?, "jinda:config failed: #{stderr}"
      
      # Verify config files created
      assert_path_exists 'config/mongoid.yml'
      assert_path_exists 'config/initializers/omniauth.rb'
      assert_path_exists 'config/initializers/jinda.rb'
    end
  end

  def test_08_bundle_install_post_config
    skip 'App not created' unless @@app_created

    Dir.chdir(@test_app_path) do
      _, stderr, status = Open3.capture3('bundle install')

      assert_predicate status, :success?,
                       "Final bundle install failed: #{stderr}"
    end
  end

  def test_09_configure_mongodb
    skip 'App not created' unless @@app_created

    mongoid_config = File.join(@test_app_path, 'config/mongoid.yml')
    content = File.read(mongoid_config)
    updated = content.gsub('localhost:27017', "localhost:#{MONGODB_PORT}")
    File.write(mongoid_config, updated)

    assert_includes File.read(mongoid_config), "localhost:#{MONGODB_PORT}"
  end

  def test_10_rails_environment_loads
    skip 'App not created' unless @@app_created

    Dir.chdir(@test_app_path) do
      stdout, stderr, status = Open3.capture3(
        'bundle', 'exec', 'rails', 'runner',
        'puts "Rails environment: #{Rails.env}"'
      )

      assert_predicate status, :success?, "Rails environment failed: #{stderr}"
      assert_includes stdout, 'Rails environment:', 
                      'Rails should load successfully'
    end
  end

  def test_11_rails_server_can_start
    skip 'App not created' unless @@app_created

    Dir.chdir(@test_app_path) do
      # Start server in daemon mode
      pid = spawn('bundle exec rails server -p 3002 -d',
                  out: '/dev/null', err: '/dev/null')
      Process.detach(pid)

      # Wait for server to start
      server_started = false
      Timeout.timeout(30) do
        loop do
          stdout, = Open3.capture3('lsof -i :3002')
          if stdout.include?('ruby')
            server_started = true
            break
          end
          sleep 1
        end
      end

      assert server_started, 'Rails server should start within 30 seconds'

      # Clean up
      if File.exist?('tmp/pids/server.pid')
        server_pid = File.read('tmp/pids/server.pid').strip
        Process.kill('TERM', server_pid.to_i) rescue nil
        File.delete('tmp/pids/server.pid')
      end
    end
  rescue Timeout::Error
    flunk 'Server failed to start within timeout'
  end

  def test_12_verify_generated_structure
    skip 'App not created' unless @@app_created

    required_files = [
      'app/controllers/admins_controller.rb',
      'app/controllers/users_controller.rb',
      'app/models/user.rb',
      'app/views/jinda/index.html.haml',
      'config/routes.rb'
    ]

    required_files.each do |file|
      path = File.join(@test_app_path, file)
      assert_path_exists path, "Required file missing: #{file}"
    end
  end

  def test_13_verify_dependencies_installed
    skip 'App not created' unless @@app_created

    Dir.chdir(@test_app_path) do
      # Check key gems are available
      %w[mongoid omniauth jinda].each do |gem_name|
        stdout, = Open3.capture3("bundle show #{gem_name}")
        assert_includes stdout, gem_name, "Gem #{gem_name} should be installed"
      end
    end
  end

  def test_14_bundle_audit_passes
    skip 'App not created' unless @@app_created
    skip 'bundler-audit not installed' unless system('which bundle-audit > /dev/null 2>&1')

    Dir.chdir(@test_app_path) do
      # Run bundle audit if available (security check)
      stdout, = Open3.capture3('bundle audit check 2>&1')
      
      # Should not have critical vulnerabilities
      refute_includes stdout, 'Critical Vulnerabilities',
                      'Should not have critical vulnerabilities'
    end
  end

  def test_15_assets_precompile_works
    skip 'App not created' unless @@app_created

    Dir.chdir(@test_app_path) do
      stdout, stderr, status = Open3.capture3(
        { 'RAILS_ENV' => 'production' },
        'bundle', 'exec', 'rails', 'assets:precompile'
      )

      # Assets should compile without errors
      assert_predicate status, :success?,
                       "Assets precompile failed: #{stderr}\n#{stdout}"
      assert_path_exists 'public/assets', 'Assets directory should be created'
    end
  end
end
# rubocop:enable Style/ClassVars
