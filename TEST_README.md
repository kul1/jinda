# Jinda Development Test Suite

## Overview
This test suite validates the complete Jinda gem installation process, ensuring all setup steps work correctly and the Rails application can start and serve requests.

## Test Script
`test_jinda_installation.sh` - Comprehensive installation test

## What It Tests

### 1. Prerequisites Check
- Ruby version (3.3.0+)
- Rails installation
- MongoDB availability

### 2. Rails Application Creation
- Creates a new Rails app with proper flags
- Verifies app structure

### 3. Gemfile Configuration
- Adds Jinda gem to Gemfile
- Validates gem path reference

### 4. Bundle Installation
- Initial bundle install
- Post-generator bundle install
- Verifies all dependencies resolve

### 5. Jinda Installation Steps
Following the dashboard instructions:
- `rails generate jinda:install`
- `bundle install`
- `rails generate jinda:config`
- `rails jinda:seed`

### 6. Application Validation
- Rails environment initialization
- Database connectivity
- Admin user creation (admin/secret)

### 7. Server Testing
- Starts Rails server on port 3000
- Tests HTTP response
- Verifies server is accessible
- Clean shutdown

### 8. File Verification
Confirms key files are created:
- Controllers (admins, articles, etc.)
- Models (User, Identity, etc.)
- Views (jinda dashboard)
- Initializers (jinda.rb, omniauth.rb)
- Configuration (mongoid.yml)
- Seeds

## Running the Tests

### Basic Usage
```bash
cd ~/mygem/jinda
./test_jinda_installation.sh
```

### Keep Test App (Skip Cleanup)
```bash
SKIP_CLEANUP=true ./test_jinda_installation.sh
```

### With Custom MongoDB Port
```bash
MONGODB_PORT=27017 ./test_jinda_installation.sh
```

## Prerequisites

### Required
- Ruby 3.3.0 or higher
- Rails 7.1.0 or higher
- Docker (for MongoDB)
- curl (for HTTP testing)
- lsof (for port checking)

### MongoDB Setup
The test expects MongoDB to be running on port 27888 (default) or will attempt to start a Docker container.

To start MongoDB manually:
```bash
docker run -d --name jinda_test_mongodb -p 27888:27017 mongo:latest
```

Or use the existing container:
```bash
docker start jindaapp-mongodb-1
```

## Test Output

The script provides color-coded output:
- 🟢 **Green [✓]** - Test passed
- 🔴 **Red [✗]** - Test failed
- 🟡 **Yellow [i]** - Information

### Example Output
```
==========================================
Jinda Gem Installation Test Suite
==========================================

Test 1: Checking prerequisites...
-----------------------------------
[✓] Ruby version: 3.3.0
[✓] Rails version: 7.1.6
[✓] MongoDB container is running

Test 2: Creating new Rails application...
-----------------------------------
[✓] Rails app created: jinda_test_app_1735362442

... (continues through all tests)

==========================================
Test Summary
==========================================
[✓] All tests passed successfully!

Installation steps verified:
  1. ✓ Prerequisites checked
  2. ✓ Rails app created
  3. ✓ Jinda gem added to Gemfile
  4. ✓ Bundle install successful
  5. ✓ rails generate jinda:install
  6. ✓ Bundle install (post-generator)
  7. ✓ rails generate jinda:config
  8. ✓ rails jinda:seed
  9. ✓ Rails environment initialized
  10. ✓ Rails server starts and responds
  11. ✓ Key files verified
```

## Test Location
Test apps are created in: `~/tmp/jinda_tests/`

By default, test apps are cleaned up after the test completes. Use `SKIP_CLEANUP=true` to preserve the test app for manual inspection.

## Troubleshooting

### MongoDB Connection Issues
If MongoDB connection fails:
1. Check if MongoDB container is running: `docker ps | grep mongo`
2. Verify port 27888 is not in use: `lsof -i :27888`
3. Check logs: `docker logs jindaapp-mongodb-1`

### Rails Server Issues
If the server test fails:
1. Check port 3000 is free: `lsof -i :3000`
2. Review server logs in the test app directory
3. Manually test: `SKIP_CLEANUP=true ./test_jinda_installation.sh` then `cd` to test app

### Bundle Install Failures
If bundle install fails:
1. Ensure ~/mygem/jinda path is correct
2. Check Gemfile for conflicts
3. Run `bundle update` manually

### Generator Failures
If generators fail:
1. Check for missing dependencies in the gem
2. Verify install_generator.rb syntax
3. Check for Gemfile duplicate gem warnings

## Manual Testing After Script

To manually test the created application:
```bash
# Preserve test app
SKIP_CLEANUP=true ./test_jinda_installation.sh

# Navigate to test app (check output for path)
cd ~/tmp/jinda_tests/jinda_test_app_XXXXX

# Start server
rails server

# Visit in browser
open http://localhost:3000

# Login with:
# Username: admin
# Password: secret
```

## CI/CD Integration

This script can be integrated into CI/CD pipelines:
```yaml
test:
  script:
    - cd ~/mygem/jinda
    - ./test_jinda_installation.sh
```

## Continuous Development Testing

Run this test after making changes to:
- `install_generator.rb`
- `config_generator.rb`
- Gem dependencies in `jinda.gemspec`
- Dashboard views
- Core functionality

## Exit Codes
- `0` - All tests passed
- `1` - Test failed (specific test will show error)

## Future Enhancements
- [ ] RSpec integration testing
- [ ] Minitest setup validation
- [ ] Theme installation testing (adminlte, adminbsb)
- [ ] Freemind integration tests
- [ ] User authentication flow tests
- [ ] API endpoint tests
- [ ] Performance benchmarks
