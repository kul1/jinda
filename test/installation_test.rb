# frozen_string_literal: true

require 'minitest/autorun'
require 'fileutils'
require 'open3'
require 'timeout'

# Test suite for Jinda gem installation process
#
# Usage:
#   Test with local gem:
#     ruby test/installation_test.rb
#
#   Test with remote git repository (default branch):
#     JINDA_GEM_SOURCE=git ruby test/installation_test.rb
#
#   Test with remote git repository (specific branch):
#     JINDA_GEM_SOURCE=git JINDA_GIT_BRANCH=main ruby test/installation_test.rb
#
#   Test with custom git URL:
#     JINDA_GEM_SOURCE=git JINDA_GIT_URL=https://github.com/user/fork.git ruby test/installation_test.rb
#
#   Skip cleanup after tests (for debugging):
#     SKIP_CLEANUP=true ruby test/installation_test.rb
#
#   Use custom MongoDB port:
#     MONGODB_PORT=27017 ruby test/installation_test.rb
# rubocop:disable Style/ClassVars
class JindaInstallationTest < Minitest::Test
  # Make tests run in order - these tests are order-dependent by design
  # as they test a sequential installation workflow
  i_suck_and_my_tests_are_order_dependent!

  def self.test_order
    :alpha
  end

  JINDA_GEM_PATH = File.expand_path('..', __dir__)
  TEST_DIR       = ENV.fetch('TEST_DIR', File.join(Dir.pwd, 'tmp', 'jinda_tests'))
  MONGODB_PORT   = ENV.fetch('MONGODB_PORT', '27017')
  TEST_APP_NAME  = "jinda_test_#{Time.now.to_i}".freeze

  # Gem source configuration
  # Set JINDA_GEM_SOURCE env var to:
  # - 'local' (default): use local path
  # - 'git': use git repository with optional branch/tag
  # Set JINDA_GIT_URL env var for custom git URL (default: https://github.com/kul1/jinda.git)
  # Set JINDA_GIT_BRANCH env var for specific branch/tag (optional)
  JINDA_GEM_SOURCE = ENV.fetch('JINDA_GEM_SOURCE', 'local')
  JINDA_GIT_URL    = ENV.fetch('JINDA_GIT_URL', 'https://github.com/kul1/jinda.git')
  JINDA_GIT_BRANCH = ENV.fetch('JINDA_GIT_BRANCH', nil)

  # Class variable to maintain test app path across all tests
  @@test_app_path = nil
  @@app_created   = false

  def setup
    @@test_app_path ||= File.join(TEST_DIR, TEST_APP_NAME)
    @test_app_path    = @@test_app_path
    FileUtils.mkdir_p(TEST_DIR)
  end

  def teardown
    # Only cleanup after the last test
    nil if ENV['SKIP_CLEANUP'] == 'true'
    # Clean up is handled by test runner end
  end

  # Cleanup after all tests complete
  Minitest.after_run do
    return if ENV['SKIP_CLEANUP'] == 'true'

    FileUtils.rm_rf(@@test_app_path) if @@test_app_path && File.exist?(@@test_app_path)
  end

  def test_01_prerequisites
    # Display test configuration
    puts "\n=== Jinda Installation Test Configuration ==="
    puts "Gem source: #{JINDA_GEM_SOURCE}"
    if JINDA_GEM_SOURCE == 'git'
      puts "Git URL: #{JINDA_GIT_URL}"
      puts "Git branch: #{JINDA_GIT_BRANCH || 'default'}" if JINDA_GIT_BRANCH
    else
      puts "Local path: #{JINDA_GEM_PATH}"
    end
    puts "Test directory: #{TEST_DIR}"
    puts "MongoDB port: #{MONGODB_PORT}"
    puts "==========================================\n\n"

    # Check Ruby version
    ruby_version = RUBY_VERSION

    assert ruby_version.start_with?('3.3.'), "Expected Ruby 3.3.x, got #{ruby_version}"

    # Check Rails
    _, stderr, status = Open3.capture3('rails', '-v')

    assert_predicate status, :success?, "Rails not found: #{stderr}"

    # Check MongoDB (Docker or local)
    stdout, = Open3.capture3("docker ps | grep mongo || echo 'no_docker'")

    skip "MongoDB container not running - start with: docker run -d -p #{MONGODB_PORT}:27017 mongo" if stdout.include?('no_docker')
  end

  def test_02_create_rails_app
    Dir.chdir(TEST_DIR) do
      _, stderr, status = Open3.capture3(
        'rails', 'new', TEST_APP_NAME,
        '--skip-test', '--skip-bundle', '--skip-active-record'
      )

      assert_predicate status, :success?, "Rails app creation failed: #{stderr}"
      assert File.directory?(@test_app_path), 'App directory not created'
      assert_path_exists File.join(@test_app_path, 'Gemfile'), 'Gemfile not found'
      @@app_created = true
    end
  end

  def test_03_add_jinda_to_gemfile
    skip 'App not created yet' unless @@app_created

    gemfile_path = File.join(@test_app_path, 'Gemfile')
    File.open(gemfile_path, 'a') do |f|
      case JINDA_GEM_SOURCE
      when 'git'
        if JINDA_GIT_BRANCH
          f.puts "gem 'jinda', git: '#{JINDA_GIT_URL}', branch: '#{JINDA_GIT_BRANCH}'"
        else
          f.puts "gem 'jinda', git: '#{JINDA_GIT_URL}'"
        end
      else # 'local' or default
        f.puts "gem 'jinda', path: '#{JINDA_GEM_PATH}'"
      end
    end

    gemfile_content = File.read(gemfile_path)

    assert_includes gemfile_content, "gem 'jinda'", 'Jinda gem not added to Gemfile'
  end

  def test_04_bundle_install_initial
    skip 'App not created yet' unless @@app_created

    Dir.chdir(@test_app_path) do
      stdout, stderr, status = Open3.capture3('bundle install')

      assert_predicate status, :success?, "Bundle install failed: #{stderr}\n#{stdout}"

      stdout, = Open3.capture3('bundle show jinda')

      assert_includes stdout, 'jinda', 'Jinda gem not found in bundle'
    end
  end

  def test_05_jinda_install_generator
    skip 'App not created yet' unless @@app_created

    Dir.chdir(@test_app_path) do
      stdout, stderr, status = Open3.capture3('rails generate jinda:install')

      assert_predicate status, :success?, "jinda:install generator failed: #{stderr}\n#{stdout}"

      # Check key files were created
      assert_path_exists 'app/controllers/admins_controller.rb', 'admins_controller not created'
      assert_path_exists 'app/models/user.rb', 'User model not created'
      assert_path_exists 'app/views/jinda/index.html.haml', 'Jinda index view not created'
    end
  end

  def test_06_bundle_install_post_generator
    skip 'App not created yet' unless @@app_created

    Dir.chdir(@test_app_path) do
      _, stderr, status = Open3.capture3('bundle install')

      assert_predicate status, :success?, "Post-generator bundle install failed: #{stderr}"
    end
  end

  def test_07_jinda_config_generator
    skip 'App not created yet' unless @@app_created

    Dir.chdir(@test_app_path) do
      stdout, stderr, status = Open3.capture3('rails generate jinda:config')

      assert_predicate status, :success?, "jinda:config generator failed: #{stderr}\n#{stdout}"

      assert_path_exists 'config/mongoid.yml', 'mongoid.yml not created'
      assert_path_exists 'config/initializers/omniauth.rb', 'omniauth.rb not created'
      assert_path_exists 'config/initializers/jinda.rb', 'jinda.rb not created'
    end
  end

  def test_08_update_mongodb_config
    skip 'App not created yet' unless @@app_created

    mongoid_config  = File.join(@test_app_path, 'config/mongoid.yml')
    content         = File.read(mongoid_config)
    updated_content = content.gsub('localhost:27017', "localhost:#{MONGODB_PORT}")
    File.write(mongoid_config, updated_content)

    assert_includes File.read(mongoid_config), "localhost:#{MONGODB_PORT}",
                    'MongoDB config not updated'
  end

  def test_09_jinda_seed
    skip 'App not created yet' unless @@app_created

    Dir.chdir(@test_app_path) do
      stdout, stderr, status = Open3.capture3('rails jinda:seed')

      assert_predicate status, :success?, "jinda:seed failed: #{stderr}\n#{stdout}"
    end
  end

  def test_10_rails_environment_loads
    skip 'App not created yet' unless @@app_created

    Dir.chdir(@test_app_path) do
      stdout, stderr, status = Open3.capture3(
        'bundle', 'exec', 'rails', 'runner',
        'puts "Environment loaded: #{Rails.env}"'
      )

      assert_predicate status, :success?, "Rails environment failed to load: #{stderr}"
      assert_includes stdout, 'Environment loaded', 'Rails environment not properly initialized'
    end
  end

  def test_11_rails_server_starts_and_responds
    skip 'App not created yet' unless @@app_created

    Dir.chdir(@test_app_path) do
      # Start server in background
      pid = spawn('bundle exec rails server -p 3000 -d',
                  out: '/dev/null', err: '/dev/null')
      Process.detach(pid)

      # Wait for server to start
      server_started = false
      Timeout.timeout(30) do
        loop do
          stdout, = Open3.capture3('lsof -i :3000')
          if stdout.include?('ruby')
            server_started = true
            break
          end
          sleep 1
        end
      end

      assert server_started, 'Rails server did not start within 30 seconds'

      # Test HTTP response
      # rubocop:disable Style/FormatStringToken
      stdout,   = Open3.capture3("curl -s -o /dev/null -w '%{http_code}' http://localhost:3000")
      # rubocop:enable Style/FormatStringToken
      http_code = stdout.strip

      assert_includes %w[200 302 404], http_code,
                      "Expected HTTP 200, 302, or 404, got #{http_code}"

      # Stop server
      if File.exist?('tmp/pids/server.pid')
        server_pid = File.read('tmp/pids/server.pid').strip
        begin
          Process.kill('TERM', server_pid.to_i)
        rescue StandardError
          nil
        end
        File.delete('tmp/pids/server.pid')
      end
    end
  rescue Timeout::Error
    flunk 'Server start timeout'
  end

  def test_12_verify_installation_files
    skip 'App not created yet' unless @@app_created

    required_files = [
      'app/controllers/admins_controller.rb',
      'app/controllers/articles_controller.rb',
      'app/controllers/users_controller.rb',
      'app/models/user.rb',
      'app/models/identity.rb',
      'app/views/jinda/index.html.haml',
      'config/initializers/jinda.rb',
      'config/initializers/omniauth.rb',
      'config/mongoid.yml',
      'db/seeds.rb'
    ]

    required_files.each do |file|
      file_path = File.join(@test_app_path, file)

      assert_path_exists file_path, "Required file missing: #{file}"
    end
  end
end
# rubocop:enable Style/ClassVars
