# Jinda Gem Testing

## Quick Start

### Run Tests Locally

**Recommended** - Using Rake (same as CI):

```bash
cd ~/mygem/jinda
rake test
# or simply:
rake
```

Alternatively, run directly:

```bash
ruby test/installation_test.rb
```

### Prerequisites

1. **MongoDB must be running:**
   ```bash
   docker ps | grep mongo
   ```
   If not running:
   ```bash
   docker run -d --name jinda_test_mongodb -p 27888:27017 mongo:latest
   ```

2. **Required gems:**
   ```bash
   gem install minitest-reporters
   ```

## What Gets Tested

✅ Complete installation workflow from dashboard instructions:
1. Ruby/Rails/MongoDB prerequisites
2. `rails new` app creation
3. Add Jinda to Gemfile
4. `bundle install`
5. `rails generate jinda:install`
6. `rails generate jinda:config`
7. `rails jinda:seed`
8. Rails server starts on port 3000
9. HTTP request returns 200
10. All required files exist

## Environment Variables

- `MONGODB_PORT=27888` - MongoDB port (default: 27888)
- `SKIP_CLEANUP=true` - Preserve test app for debugging

## GitHub CI

Tests run automatically on push to:
- `main`
- `develop`
- `jinda-*` branches

**No version hardcoding** - CI reads Ruby/Rails versions directly from `jinda.gemspec`

## Debugging Failed Tests

```bash
# Preserve test app
SKIP_CLEANUP=true ruby test/installation_test.rb

# Inspect the test app
cd ~/tmp/jinda_tests/jinda_test_XXXXX
rails server
```

## Full Documentation

See `test/README.md` for complete documentation.
