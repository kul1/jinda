# Jinda Gem Test Suite

This directory contains the Minitest-based test suite for the Jinda gem installation and functionality.

## Overview

The test suite validates the complete Jinda gem installation process, ensuring:
- All installation steps work correctly
- The Rails application starts successfully
- The dashboard is accessible on localhost:3000
- All required files are created

## Test Files

- `installation_test.rb` - Complete installation workflow test
- `test_helper.rb` - Test configuration and reporters

## Running Tests Locally

### Prerequisites

Ensure you have:
- Ruby 3.3.0+ (as specified in `jinda.gemspec`)
- Rails 7.1.0+ (as specified in `jinda.gemspec`)
- MongoDB running (Docker or local)

### Start MongoDB

```bash
# Using Docker
docker run -d --name jinda_test_mongodb -p 27888:27017 mongo:latest

# Or use existing container
docker start jindaapp-mongodb-1
```

### Run All Tests

```bash
cd ~/mygem/jinda
ruby test/installation_test.rb
```

Or using Rake:

```bash
rake test
```

### Run with Custom MongoDB Port

```bash
MONGODB_PORT=27017 ruby test/installation_test.rb
```

### Keep Test App for Debugging

```bash
SKIP_CLEANUP=true ruby test/installation_test.rb
```

The test app will be preserved at: `~/tmp/jinda_tests/jinda_test_<timestamp>`

### Run Specific Test

```bash
ruby test/installation_test.rb --name test_05_jinda_install_generator
```

## Test Execution Order

Tests run sequentially and build on each other:

1. **test_01_prerequisites** - Checks Ruby, Rails, MongoDB
2. **test_02_create_rails_app** - Creates new Rails app
3. **test_03_add_jinda_to_gemfile** - Adds Jinda gem
4. **test_04_bundle_install_initial** - Initial bundle install
5. **test_05_jinda_install_generator** - Runs `rails g jinda:install`
6. **test_06_bundle_install_post_generator** - Bundle after generator
7. **test_07_jinda_config_generator** - Runs `rails g jinda:config`
8. **test_08_update_mongodb_config** - Updates MongoDB port
9. **test_09_jinda_seed** - Runs `rails jinda:seed`
10. **test_10_rails_environment_loads** - Tests Rails initialization
11. **test_11_rails_server_starts_and_responds** - Tests server & HTTP
12. **test_12_verify_installation_files** - Verifies all files exist

If any test fails, subsequent tests are skipped.

## GitHub CI Integration

The test suite runs automatically on GitHub Actions when you push to:
- `main` branch
- `develop` branch
- Any `jinda-*` branch (e.g., `jinda-0.9.0`)

### CI Configuration

The CI workflow (`.github/workflows/ci.yml`):
- Automatically reads Ruby and Rails versions from `jinda.gemspec`
- Sets up MongoDB service
- Runs all tests
- Uploads test artifacts on failure

### No Hardcoded Versions

The CI dynamically reads versions from your gemspec:
```yaml
- name: Read Ruby version from gemspec
  run: grep 'required_ruby_version' jinda.gemspec | grep -oE '[0-9]+\.[0-9]+\.[0-9]+'

- name: Read Rails version from gemspec
  run: grep "add_runtime_dependency 'rails'" jinda.gemspec | grep -oE '[0-9]+\.[0-9]+\.[0-9]+'
```

This means when you update versions in `jinda.gemspec`, CI automatically uses them.

## Test Output

### Successful Run
```
Run options: --seed 12345

# Running:

JindaInstallationTest
  test_01_prerequisites                             PASS (0.15s)
  test_02_create_rails_app                          PASS (12.34s)
  test_03_add_jinda_to_gemfile                      PASS (0.02s)
  test_04_bundle_install_initial                    PASS (25.67s)
  test_05_jinda_install_generator                   PASS (8.90s)
  test_06_bundle_install_post_generator             PASS (15.23s)
  test_07_jinda_config_generator                    PASS (3.45s)
  test_08_update_mongodb_config                     PASS (0.01s)
  test_09_jinda_seed                                PASS (2.34s)
  test_10_rails_environment_loads                   PASS (5.67s)
  test_11_rails_server_starts_and_responds          PASS (12.89s)
  test_12_verify_installation_files                 PASS (0.05s)

Finished in 86.72s
12 tests, 23 assertions, 0 failures, 0 errors, 0 skips
```

### With Skipped Tests (MongoDB not running)
```
JindaInstallationTest
  test_01_prerequisites                             SKIP
    MongoDB container not running - start with: docker run -d -p 27888:27017 mongo
```

## Troubleshooting

### Test Hangs on Server Start
If test_11 hangs:
1. Check if port 3000 is already in use: `lsof -i :3000`
2. Kill any processes on that port
3. Run with `SKIP_CLEANUP=true` to debug

### Bundle Install Fails
Check that `~/mygem/jinda` path exists and contains valid gem code.

### MongoDB Connection Errors
1. Verify MongoDB is running: `docker ps | grep mongo`
2. Check port is correct: `MONGODB_PORT=27888`
3. Test connection: `mongosh --host localhost --port 27888`

### Permission Errors
Ensure `~/tmp/jinda_tests` is writable:
```bash
mkdir -p ~/tmp/jinda_tests
chmod 755 ~/tmp/jinda_tests
```

## Development Workflow

### After Making Changes

Run tests after modifying:
- `lib/generators/jinda/install_generator.rb`
- `lib/generators/jinda/config_generator.rb`
- `jinda.gemspec` dependencies
- Dashboard views
- Core gem functionality

### Quick Test Cycle

```bash
# Make changes to gem
vim lib/generators/jinda/install_generator.rb

# Run tests
ruby test/installation_test.rb

# If test fails, preserve app for debugging
SKIP_CLEANUP=true ruby test/installation_test.rb

# Manually inspect test app
cd ~/tmp/jinda_tests/jinda_test_XXXXX
```

### Before Pushing to GitHub

```bash
# Run full test suite
rake test

# If all pass, push to GitHub
git push origin jinda-0.9.0
```

GitHub Actions will automatically run the same tests in CI.

## Adding New Tests

To add a new test:

1. Add test method to `installation_test.rb`:
```ruby
def test_13_my_new_test
  skip unless File.directory?(@test_app_path)
  
  # Your test logic here
  assert something, "Error message"
end
```

2. Follow naming convention: `test_##_descriptive_name`
3. Use `skip unless File.directory?(@test_app_path)` to chain tests
4. Run locally to verify
5. Push to GitHub to run in CI

## Environment Variables

- `MONGODB_PORT` - MongoDB port (default: 27888)
- `SKIP_CLEANUP` - Keep test app after run (default: false)

## Future Enhancements

- [ ] Test theme installation (adminlte, adminbsb)
- [ ] Test Freemind integration
- [ ] Test user authentication flows
- [ ] Test API endpoints
- [ ] Performance benchmarks
- [ ] Multi-version testing (Ruby 3.3.x matrix)
