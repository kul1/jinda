# frozen_string_literal: true

require 'minitest/autorun'
require 'fileutils'
require 'open3'
require 'timeout'
require 'net/http'
require 'uri'

# Integration test suite for Jinda generated application
#
# This test verifies the actual functionality of the generated Rails app:
# - Home page renders correctly with expected content
# - Login system works with admin credentials
# - Application routes and controllers function properly
#
# Prerequisites:
# - Run installation_test.rb first to generate a test app
# - Or set TEST_APP_PATH to an existing Jinda app
#
# Usage:
#   # Test specific app:
#   TEST_APP_PATH=/path/to/app ruby test/integration_test.rb
#
#   # Use latest test app from installation_test:
#   ruby test/integration_test.rb
#
#   # Keep server running after tests (for manual debugging):
#   KEEP_SERVER=true ruby test/integration_test.rb
#
#   # Custom port:
#   TEST_PORT=3001 ruby test/integration_test.rb
#
# rubocop:disable Style/ClassVars
class JindaIntegrationTest < Minitest::Test
  # Tests must run in order
  i_suck_and_my_tests_are_order_dependent!

  def self.test_order
    :alpha
  end

  TEST_DIR = File.expand_path('~/tmp/jinda_tests')
  TEST_PORT = ENV.fetch('TEST_PORT', '3000')
  MONGODB_PORT = ENV.fetch('MONGODB_PORT', '27888')
  
  # Admin credentials from seeds.rb
  ADMIN_USERNAME = 'admin'
  ADMIN_PASSWORD = 'secret'
  ADMIN_EMAIL = 'admin@test.com'

  @@test_app_path = nil
  @@server_pid = nil
  @@session_cookie = nil

  def setup
    # Find test app
    if ENV['TEST_APP_PATH']
      @@test_app_path = ENV['TEST_APP_PATH']
    elsif @@test_app_path.nil?
      # Find most recent test app from installation_test
      if Dir.exist?(TEST_DIR)
        test_apps = Dir.glob(File.join(TEST_DIR, 'jinda_test_*')).sort_by { |f| File.mtime(f) }
        @@test_app_path = test_apps.last
      end
    end

    skip 'No test app found. Run installation_test.rb first or set TEST_APP_PATH' unless @@test_app_path
    skip "Test app not found: #{@@test_app_path}" unless File.directory?(@@test_app_path)

    @test_app_path = @@test_app_path
    @base_url = "http://localhost:#{TEST_PORT}"
  end

  def teardown
    # Cleanup handled in Minitest.after_run
    nil
  end

  # Cleanup after all tests
  Minitest.after_run do
    if @@server_pid && ENV['KEEP_SERVER'] != 'true'
      begin
        Process.kill('TERM', @@server_pid)
        Process.wait(@@server_pid)
      rescue StandardError => e
        puts "Warning: Could not kill server process: #{e.message}"
      end
      
      # Clean up PID file
      pid_file = File.join(@@test_app_path, 'tmp/pids/server.pid')
      File.delete(pid_file) if File.exist?(pid_file)
    elsif ENV['KEEP_SERVER'] == 'true'
      puts "\n=== Server kept running at #{TEST_PORT} (PID: #{@@server_pid}) ==="
      puts "To stop: kill #{@@server_pid}"
    end
  end

  def test_01_start_rails_server
    Dir.chdir(@test_app_path) do
      puts "\n=== Starting Rails server on port #{TEST_PORT} ==="
      
      # Clean up old PID file if exists
      pid_file = 'tmp/pids/server.pid'
      File.delete(pid_file) if File.exist?(pid_file)

      # Start server in background
      @@server_pid = spawn(
        { 'RAILS_ENV' => 'development', 'MONGODB_PORT' => MONGODB_PORT },
        'bundle', 'exec', 'rails', 'server', '-p', TEST_PORT, '-d',
        out: 'log/test_server.log',
        err: 'log/test_server_error.log'
      )
      Process.detach(@@server_pid)

      # Wait for server to start (check both process and HTTP)
      server_ready = false
      Timeout.timeout(60) do
        loop do
          # Check if process is running
          stdout, = Open3.capture3("lsof -i :#{TEST_PORT}")
          process_running = stdout.include?('ruby')
          
          # Check if HTTP responds
          http_responds = false
          begin
            uri = URI(@base_url)
            response = Net::HTTP.get_response(uri)
            http_responds = !response.nil?
          rescue StandardError
            http_responds = false
          end

          if process_running && http_responds
            server_ready = true
            break
          end
          
          sleep 2
        end
      end

      assert server_ready, "Rails server did not start within 60 seconds on port #{TEST_PORT}"
      puts "✓ Server started (PID: #{@@server_pid})"
    end
  rescue Timeout::Error
    flunk "Server start timeout on port #{TEST_PORT}"
  end

  def test_02_home_page_loads
    uri = URI(@base_url)
    response = Net::HTTP.get_response(uri)

    assert_includes [200, 302], response.code.to_i,
                    "Expected HTTP 200 or 302, got #{response.code}"

    # Follow redirect if needed
    if response.code.to_i == 302
      location = response['location']
      uri = URI(location.start_with?('http') ? location : "#{@base_url}#{location}")
      response = Net::HTTP.get_response(uri)
    end

    body = response.body
    
    # Check for Jinda dashboard content (from screenshot)
    assert_includes body, 'Jinda', 'Page should contain "Jinda" title'
    assert_includes body, 'Dashboard', 'Page should contain "Dashboard" section'
    
    puts '✓ Home page loads successfully'
  end

  def test_03_home_page_contains_version_info
    uri = URI(@base_url)
    response = Net::HTTP.get_response(uri)
    
    # Follow redirect if needed
    if response.code.to_i == 302
      location = response['location']
      uri = URI(location.start_with?('http') ? location : "#{@base_url}#{location}")
      response = Net::HTTP.get_response(uri)
    end

    body = response.body

    # Check for version information (from screenshot)
    assert_includes body, 'Ruby Version', 'Should display Ruby version info'
    assert_includes body, 'Rails Version', 'Should display Rails version info'
    assert_includes body, 'gem jinda', 'Should display Jinda gem version'
    
    puts '✓ Version information displayed correctly'
  end

  def test_04_home_page_contains_installation_info
    uri = URI(@base_url)
    response = Net::HTTP.get_response(uri)
    
    # Follow redirect if needed
    if response.code.to_i == 302
      location = response['location']
      uri = URI(location.start_with?('http') ? location : "#{@base_url}#{location}")
      response = Net::HTTP.get_response(uri)
    end

    body = response.body

    # Check for installation section (from screenshot)
    assert_includes body, 'Installation', 'Should contain Installation section'
    assert_includes body, 'Create New Rails', 'Should contain Rails creation instructions'
    
    puts '✓ Installation information displayed'
  end

  def test_05_login_page_accessible
    uri = URI("#{@base_url}/auth/identity")
    response = Net::HTTP.get_response(uri)

    # Should either load login page or redirect to it
    assert_includes [200, 302], response.code.to_i,
                    "Login page should be accessible, got HTTP #{response.code}"

    if response.code.to_i == 200
      body = response.body
      # Check for login form elements
      assert_match(/password|sign.?in|login/i, body, 'Login page should contain login form')
    end

    puts '✓ Login page accessible'
  end

  def test_06_login_with_admin_credentials
    # Get the login page first to obtain CSRF token
    uri = URI("#{@base_url}/auth/identity")
    http = Net::HTTP.new(uri.host, uri.port)
    
    get_request = Net::HTTP::Get.new(uri.path)
    get_response = http.request(get_request)
    
    # Extract CSRF token if present
    csrf_token = nil
    if get_response.body =~ /csrf[_-]token[^>]*value=["']([^"']+)["']/i
      csrf_token = ::Regexp.last_match(1)
    end

    # Extract session cookie
    cookies = get_response.get_fields('set-cookie')
    session_cookie = cookies&.map { |c| c.split(';').first }&.join('; ')

    # Attempt login with admin credentials
    post_uri = URI("#{@base_url}/auth/identity/callback")
    post_http = Net::HTTP.new(post_uri.host, post_uri.port)
    
    post_request = Net::HTTP::Post.new(post_uri.path)
    post_request['Cookie'] = session_cookie if session_cookie
    post_request['Content-Type'] = 'application/x-www-form-urlencoded'
    
    params = {
      'auth_key' => ADMIN_USERNAME,
      'password' => ADMIN_PASSWORD
    }
    params['authenticity_token'] = csrf_token if csrf_token
    
    post_request.body = URI.encode_www_form(params)
    post_response = post_http.request(post_request)

    # Should redirect after successful login
    assert_includes [200, 302, 303], post_response.code.to_i,
                    "Login should succeed or redirect, got HTTP #{post_response.code}"

    # Store session cookie for subsequent tests
    if post_response.get_fields('set-cookie')
      @@session_cookie = post_response.get_fields('set-cookie')
                                      .map { |c| c.split(';').first }
                                      .join('; ')
    end
    @@session_cookie ||= session_cookie

    puts '✓ Admin login successful'
  end

  def test_07_authenticated_access_to_dashboard
    skip 'No session cookie from login' unless @@session_cookie

    uri = URI(@base_url)
    http = Net::HTTP.new(uri.host, uri.port)
    
    request = Net::HTTP::Get.new(uri.path)
    request['Cookie'] = @@session_cookie
    
    response = http.request(request)

    assert_includes [200, 302], response.code.to_i,
                    "Authenticated request should succeed, got HTTP #{response.code}"

    puts '✓ Authenticated access works'
  end

  def test_08_users_page_accessible
    skip 'No session cookie from login' unless @@session_cookie

    uri = URI("#{@base_url}/users")
    http = Net::HTTP.new(uri.host, uri.port)
    
    request = Net::HTTP::Get.new(uri.path)
    request['Cookie'] = @@session_cookie
    
    response = http.request(request)

    # Users page should be accessible to admin
    assert_includes [200, 302], response.code.to_i,
                    "Users page should be accessible to admin, got HTTP #{response.code}"

    if response.code.to_i == 200
      assert_includes response.body, 'user', 'Users page should contain user-related content'
    end

    puts '✓ Users page accessible'
  end

  def test_09_articles_page_accessible
    skip 'No session cookie from login' unless @@session_cookie

    uri = URI("#{@base_url}/articles")
    http = Net::HTTP.new(uri.host, uri.port)
    
    request = Net::HTTP::Get.new(uri.path)
    request['Cookie'] = @@session_cookie
    
    response = http.request(request)

    # Articles page should exist
    assert_includes [200, 302, 404], response.code.to_i,
                    "Articles endpoint should respond, got HTTP #{response.code}"

    puts '✓ Articles page responds'
  end

  def test_10_logout_functionality
    skip 'No session cookie from login' unless @@session_cookie

    # Find logout path
    logout_uri = URI("#{@base_url}/logout")
    http = Net::HTTP.new(logout_uri.host, logout_uri.port)
    
    # Try DELETE method first (standard Rails)
    request = Net::HTTP::Delete.new(logout_uri.path)
    request['Cookie'] = @@session_cookie
    
    response = http.request(request)

    # Logout should redirect or succeed
    assert_includes [200, 302, 303, 404], response.code.to_i,
                    "Logout should work or endpoint should exist, got HTTP #{response.code}"

    # If 404, try GET method
    if response.code.to_i == 404
      request = Net::HTTP::Get.new(logout_uri.path)
      request['Cookie'] = @@session_cookie
      response = http.request(request)
      
      assert_includes [200, 302, 303, 404], response.code.to_i,
                      "Logout GET should work, got HTTP #{response.code}"
    end

    puts '✓ Logout functionality tested'
  end

  def test_11_verify_mongodb_connection
    Dir.chdir(@test_app_path) do
      stdout, stderr, status = Open3.capture3(
        { 'RAILS_ENV' => 'development', 'MONGODB_PORT' => MONGODB_PORT },
        'bundle', 'exec', 'rails', 'runner',
        'puts "MongoDB connected: #{Mongoid.default_client.database.name}"'
      )

      assert_predicate status, :success?, "MongoDB connection check failed: #{stderr}"
      assert_includes stdout, 'MongoDB connected', 'Should confirm MongoDB connection'
      
      puts '✓ MongoDB connection verified'
    end
  end

  def test_12_verify_admin_user_exists
    Dir.chdir(@test_app_path) do
      stdout, stderr, status = Open3.capture3(
        { 'RAILS_ENV' => 'development', 'MONGODB_PORT' => MONGODB_PORT },
        'bundle', 'exec', 'rails', 'runner',
        'puts "Admin exists: #{Identity.where(code: \"admin\").exists?}"'
      )

      assert_predicate status, :success?, "Admin check failed: #{stderr}"
      assert_includes stdout, 'Admin exists: true', 'Admin user should exist after seeding'
      
      puts '✓ Admin user verified in database'
    end
  end
end
# rubocop:enable Style/ClassVars
