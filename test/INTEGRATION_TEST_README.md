# Jinda Integration Tests

This directory contains two levels of testing for the Jinda gem:

1. **Installation Tests** (`installation_test.rb`) - Verify the gem generates a working Rails app
2. **Integration Tests** (`integration_test.rb`) - Verify the generated app actually works

## Test Flow

```
┌─────────────────────────────────────┐
│  1. installation_test.rb            │
│     - Creates Rails app             │
│     - Installs Jinda gem            │
│     - Runs generators               │
│     - Seeds database                │
│     - Verifies file structure       │
└──────────────┬──────────────────────┘
               │
               ▼
┌─────────────────────────────────────┐
│  2. integration_test.rb             │
│     - Starts Rails server           │
│     - Tests home page               │
│     - Tests login (admin/secret)    │
│     - Tests authenticated pages     │
│     - Verifies MongoDB connection   │
└─────────────────────────────────────┘
```

## Installation Test (`installation_test.rb`)

### What It Does

1. **Prerequisites Check** - Ruby, Rails, MongoDB
2. **Creates Rails App** - `rails new` with Jinda-specific options
3. **Adds Jinda Gem** - To Gemfile (local or git source)
4. **Bundle Install** - Initial dependencies
5. **jinda:install** - Runs the main generator
6. **Bundle Install** - Post-generator dependencies
7. **jinda:config** - Configures MongoDB, OmniAuth, etc.
8. **Updates MongoDB Config** - Sets correct port
9. **jinda:seed** - Creates admin user (username: admin, password: secret)
10. **Rails Environment** - Verifies it loads
11. **Rails Server** - Starts and responds to HTTP
12. **Verifies Files** - All required files exist

### Test App Location

Generated apps are created in: `~/tmp/jinda_tests/jinda_test_<timestamp>`

### Usage

```bash
# Run with local gem (default)
rake test_installation
# or
ruby test/installation_test.rb

# Run with git source
JINDA_GEM_SOURCE=git ruby test/installation_test.rb

# Run with specific branch
JINDA_GEM_SOURCE=git JINDA_GIT_BRANCH=jinda-0.8.0 ruby test/installation_test.rb

# Keep test app for debugging
SKIP_CLEANUP=true ruby test/installation_test.rb

# Custom MongoDB port
MONGODB_PORT=27017 ruby test/installation_test.rb
```

### Expected Output

```
12 runs, 33 assertions, 0 failures, 0 errors, 0 skips
```

## Integration Test (`integration_test.rb`)

### What It Does

Tests the **actual functionality** of the generated Jinda Rails application:

1. **Starts Rails Server** - In background on port 3000
2. **Home Page Loads** - Verifies HTTP 200/302
3. **Version Info Displayed** - Ruby, Rails, Jinda gem versions
4. **Installation Info** - Documentation section visible
5. **Login Page Accessible** - `/auth/identity` route works
6. **Admin Login** - Tests with username: "admin", password: "secret"
7. **Authenticated Dashboard** - Session cookie maintained
8. **Users Page** - Admin can access `/users`
9. **Articles Page** - Route responds correctly
10. **Logout Functionality** - Session cleanup
11. **MongoDB Connection** - Database accessible from Rails
12. **Admin User Exists** - Seeded data verified

### Content Verification

The test verifies the home page (based on your screenshot) contains:

- ✓ "Jinda" title
- ✓ "Dashboard" section
- ✓ "Ruby Version 3.3.0"
- ✓ "Rails Version 7.1.6"
- ✓ "gem jinda 0.9.0"
- ✓ "Recently tested with" section
- ✓ "Create New Rails" instructions
- ✓ "Installation" section

### Admin Credentials

The test uses credentials from `db/seeds.rb`:

- **Username**: `admin`
- **Password**: `secret`
- **Email**: `admin@test.com`

### Usage

```bash
# Run integration tests (requires existing test app)
rake test_integration
# or
ruby test/integration_test.rb

# Test specific app
TEST_APP_PATH=/path/to/app ruby test/integration_test.rb

# Keep server running after tests (for manual debugging)
KEEP_SERVER=true ruby test/integration_test.rb

# Custom port
TEST_PORT=3001 ruby test/integration_test.rb

# Custom MongoDB port
MONGODB_PORT=27888 ruby test/integration_test.rb
```

### Expected Output

```
=== Starting Rails server on port 3000 ===
✓ Server started (PID: 12345)
✓ Home page loads successfully
✓ Version information displayed correctly
✓ Installation information displayed
✓ Login page accessible
✓ Admin login successful
✓ Authenticated access works
✓ Users page accessible
✓ Articles page responds
✓ Logout functionality tested
✓ MongoDB connection verified
✓ Admin user verified in database

12 runs, 24 assertions, 0 failures, 0 errors, 0 skips
```

## Running Both Tests in Sequence

### Full Test Suite

```bash
# Run both installation and integration tests
rake test_all
```

This will:
1. Create a new Rails app with Jinda
2. Immediately test its functionality
3. Clean up afterward (unless `SKIP_CLEANUP=true`)

### Manual Sequence

```bash
# 1. Installation (creates app)
SKIP_CLEANUP=true rake test_installation

# 2. Find the app path
ls -lt ~/tmp/jinda_tests/

# 3. Integration (tests the app)
TEST_APP_PATH=~/tmp/jinda_tests/jinda_test_XXXXX rake test_integration

# 4. Manual cleanup when done
rm -rf ~/tmp/jinda_tests/jinda_test_XXXXX
```

## Debugging Failed Tests

### Installation Test Failures

```bash
# Keep the test app
SKIP_CLEANUP=true ruby test/installation_test.rb

# Navigate to it
cd ~/tmp/jinda_tests/jinda_test_XXXXX

# Investigate
ls -la app/controllers/
cat config/mongoid.yml
bundle exec rails console
```

### Integration Test Failures

```bash
# Keep server running
KEEP_SERVER=true ruby test/integration_test.rb

# In another terminal
curl http://localhost:3000
curl http://localhost:3000/auth/identity

# Check logs
cd ~/tmp/jinda_tests/jinda_test_XXXXX
tail -f log/development.log
tail -f log/test_server.log
```

### Common Issues

**MongoDB not running:**
```bash
docker run -d --name jinda_mongo -p 27888:27017 mongo:latest
# or
MONGODB_PORT=27017 ruby test/installation_test.rb
```

**Port already in use:**
```bash
# Find process
lsof -i :3000
# Kill it
kill -9 <PID>
# Or use different port
TEST_PORT=3001 ruby test/integration_test.rb
```

**Server won't start:**
```bash
cd ~/tmp/jinda_tests/jinda_test_XXXXX
cat log/test_server_error.log
bundle exec rails server  # Try manually
```

## CI/CD Integration

### GitHub Actions Workflows

**RuboCop Workflow** (`rubocop.yml`):
- Only runs code quality checks
- Does NOT run tests
- Fast feedback (~2 min)

**Jenkins Test Workflow** (`jenkins-test.yml`):
- Runs installation tests only
- Builds gem package
- Duration: ~5 min
- Why not integration? Server startup in CI is complex

### Jenkins Pipeline

**Jenkinsfile** (`ci/Jenkinsfile`):
- Runs RuboCop checks
- Runs installation tests
- Builds and validates gem
- Optional: Can be extended to run integration tests

To add integration tests to CI, add after installation tests:

```groovy
stage('Integration Tests') {
    steps {
        echo "=== Running integration tests ==="
        sh '''
            cd ${WORKSPACE}
            TEST_APP_PATH=${WORKSPACE}/tmp/jinda_tests/jinda_test_* \\
            TEST_PORT=3000 \\
            MONGODB_PORT=${MONGODB_PORT} \\
            ruby test/integration_test.rb
        '''
    }
}
```

## Test Maintenance

### Adding New Integration Tests

Add tests to `integration_test.rb`:

```ruby
def test_13_my_new_feature
  skip 'No session cookie from login' unless @@session_cookie

  uri = URI("#{@base_url}/my_feature")
  http = Net::HTTP.new(uri.host, uri.port)
  
  request = Net::HTTP::Get.new(uri.path)
  request['Cookie'] = @@session_cookie
  
  response = http.request(request)

  assert_equal 200, response.code.to_i, 'Feature should be accessible'
  assert_includes response.body, 'expected content'
  
  puts '✓ My feature works'
end
```

### Test Naming Convention

- `test_01_*` to `test_12_*` - Numbered tests run in order
- Tests are order-dependent (sequential workflow)
- Use descriptive names after the number

### Environment Variables

| Variable | Default | Description |
|----------|---------|-------------|
| `TEST_APP_PATH` | auto | Path to existing Jinda app |
| `TEST_PORT` | 3000 | Port for Rails server |
| `MONGODB_PORT` | 27888 | Port for MongoDB |
| `KEEP_SERVER` | false | Keep server running after tests |
| `SKIP_CLEANUP` | false | Don't delete test app |
| `JINDA_GEM_SOURCE` | local | Use 'git' for remote |
| `JINDA_GIT_URL` | github.com/kul1/jinda.git | Git repo URL |
| `JINDA_GIT_BRANCH` | default | Specific branch/tag |

## Architecture

### Test Independence

- Installation tests are self-contained
- Integration tests depend on installation tests creating an app
- Both can run independently if app exists

### Class Variables

Both test files use class variables (`@@`) to maintain state across tests:

- `@@test_app_path` - Location of test app
- `@@app_created` - Installation success flag
- `@@server_pid` - Rails server process
- `@@session_cookie` - Authentication state

### Cleanup Strategy

- Installation test: Cleanup in `Minitest.after_run`
- Integration test: Kills server in `Minitest.after_run`
- Both respect `SKIP_CLEANUP` and `KEEP_SERVER` flags

## Summary

| Test | Purpose | Duration | CI |
|------|---------|----------|-----|
| **installation_test.rb** | Generates working app | ~30s | ✓ |
| **integration_test.rb** | Tests app functionality | ~20s | Optional |
| **test_all** | Both in sequence | ~50s | Future |

**Quick Start:**
```bash
# Full test suite
rake test_all

# Just installation (CI default)
rake test

# Just integration (requires existing app)
rake test_integration
```
