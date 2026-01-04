# Local Development Testing Guide

This guide explains how to run tests locally during Jinda gem development, matching the CI workflow.

## Quick Start

```bash
# Run all tests (recommended before push)
bundle exec rake

# Or step by step:
bundle exec rake test:unit        # Fast (2 seconds)
bundle exec rake test:installation # Slow (2-3 minutes)
bundle exec rake test:integration  # Slow (2-3 minutes)
```

## Test Structure

### 1. Unit Tests (Fast - No App Generation)
**Location**: `test/*_test.rb` (excluding integration_test.rb)
**Purpose**: Static analysis of templates, controllers, models
**Runtime**: ~2 seconds

```bash
bundle exec rake test:unit
```

**Files tested**:
- `test/jenkins_stage_test.rb` - Verify Jenkinsfile structure
- `test/note_model_test.rb` - Verify Note model templates
- `test/api_notes_controller_test.rb` - Verify API controller templates
- `test/note_validation_integration_test.rb` - Verify validation logic

### 2. Installation Tests (Slow - Generates Test App)
**Location**: `test/installation_test.rb`
**Purpose**: Tests full installation flow, generates app in `tmp/jinda_tests/`
**Runtime**: ~2-3 minutes

```bash
bundle exec rake test:installation
```

### 3. Integration Tests (Slow - Uses Generated App)
**Location**: `test/integration_test.rb`  
**Purpose**: Tests login, HTTP endpoints in generated app
**Runtime**: ~2-3 minutes

```bash
bundle exec rake test:integration
```

### 4. Generated App Tests (Manual - Uses test/dummy)
**Location**: `test/dummy/` (when manually created)
**Purpose**: Test the actual generated application with its own test suite

```bash
# This only works if test/dummy exists
bundle exec rake test:generated_app
```

## Working with test/dummy

The `test/dummy` directory is **NOT** committed to git. It's for local development testing.

### Creating test/dummy

```bash
cd test
rm -rf dummy  # Clean any old version

# Create new Rails app
rails new dummy -BOTJ

cd dummy

# Add Jinda gem (local path)
echo "gem 'jinda', path: '../../'" >> Gemfile

# Install
bundle install
rails g jinda:install
bundle install
rails g jinda:config
bundle install

# Configure MongoDB
# Edit config/mongoid.yml to use your MongoDB port

# Seed
rails jinda:seed

# Test
rails s
```

### Running tests in test/dummy

```bash
cd test/dummy

# If it has Minitest
bundle exec rake test

# If it has RSpec
bundle exec rspec

# Or use the Rake task from gem root
cd ../..
bundle exec rake test:generated_app
```

## Local Development Workflow

### Typical Development Cycle

```bash
# 1. Make changes to gem code (e.g., templates, generators)

# 2. Run fast unit tests
bundle exec rake test:unit

# 3. If unit tests pass, regenerate test/dummy
cd test
rm -rf dummy
rails new dummy -BOTJ
cd dummy
echo "gem 'jinda', path: '../../'" >> Gemfile
bundle install
rails g jinda:install
bundle install
rails g jinda:config
bundle install
cd ../..

# 4. Run tests in dummy app
cd test/dummy
rails s  # Manual testing
bundle exec rake test  # Automated tests
cd ../..

# 5. If all looks good, run full test suite
bundle exec rake test:all

# 6. Push to GitHub (CI will run same tests)
git push
```

### Quick Development Cycle (Without test/dummy)

```bash
# For quick iterations on templates:
bundle exec rake test:unit  # Fast feedback

# When ready for full validation:
bundle exec rake test:installation
bundle exec rake test:integration
```

## Rake Tasks Reference

### Available Tasks

```bash
# View all test tasks
bundle exec rake -T test

# Common tasks:
rake test                  # Run unit + installation tests (default)
rake test:unit            # Run unit tests only (fast)
rake test:installation    # Run installation tests
rake test:integration     # Run integration tests
rake test:generated_app   # Run tests in test/dummy (if exists)
rake test:gem             # Run gem-level tests (unit + installation)
rake test:all             # Run all tests (unit + installation + integration)
rake test_all             # Alias for test:all
```

### CI-Equivalent Commands

To match what CI runs:

```bash
# CI runs these in parallel:
bundle exec rake rubocop      # Code style
bundle exec rake test:unit    # Fast tests

# Then sequentially:
bundle exec rake test:installation
bundle exec rake test:integration
```

## Environment Variables

### MongoDB Configuration
```bash
# Use custom MongoDB port
MONGODB_PORT=27888 bundle exec rake test:installation

# Skip cleanup (for debugging)
SKIP_CLEANUP=true bundle exec rake test:installation
```

### Test App Location
```bash
# Use custom test directory
TEST_DIR=/tmp/my_tests bundle exec rake test:installation
```

### Keep Test Artifacts
```bash
# Keep generated app after tests
SKIP_CLEANUP=true bundle exec rake test:installation

# App will be at: tmp/jinda_tests/jinda_test_*
```

## Prerequisites

### Required Software
- Ruby 3.3.x
- Rails 7.0+
- MongoDB (Docker or local)
- Bundler

### Start MongoDB
```bash
# Using Docker (recommended)
docker run -d --name jinda_test_mongo -p 27017:27017 mongo

# Verify
docker ps | grep mongo
```

### Install Dependencies
```bash
bundle install
gem install minitest-reporters  # Better test output
```

## Troubleshooting

### MongoDB Connection Failed
```bash
# Check if MongoDB is running
docker ps | grep mongo

# Start if needed
docker run -d -p 27017:27017 mongo
```

### Port Already in Use
```bash
# Find process
lsof -i :3000

# Kill it
kill -9 <PID>
```

### test/dummy Issues
```bash
# Clean and recreate
cd test
rm -rf dummy
# Then follow "Creating test/dummy" steps above
```

### Bundle Install Failures
```bash
# Clean bundle cache
bundle clean --force
rm Gemfile.lock
bundle install
```

### Test Artifacts Remain
```bash
# Clean up
rm -rf tmp/jinda_tests
rm -rf test/dummy
```

## Syncing test/dummy Changes Back to Templates

When you make changes in `test/dummy` that should be in the gem templates:

```bash
# 1. Find the file in test/dummy
# Example: test/dummy/app/models/note.rb

# 2. Copy to template location
cp test/dummy/app/models/note.rb \
   lib/generators/jinda/templates/app/models/note.rb

# 3. Verify with unit tests
bundle exec rake test:unit

# 4. Verify by regenerating dummy
cd test
rm -rf dummy
# ... recreate dummy ...
# ... verify it still works ...
```

**Future Enhancement**: We'll add a rake task to automate this sync.

## CI vs Local Differences

| Aspect | Local | CI |
|--------|-------|-----|
| test/dummy | Manually created, not in git | Not used |
| Test apps | `tmp/jinda_tests/` or custom | `$WORKSPACE/tmp/jinda_tests/` |
| MongoDB | Docker on localhost | Docker container in CI |
| Cleanup | Optional (SKIP_CLEANUP) | Always cleanup |
| Parallel tests | Sequential by default | Parallel stages |

## Best Practices

### Before Committing
1. Run `bundle exec rake test:unit` (fast check)
2. Run `bundle exec rake test:installation` (full check)
3. Manually test in `test/dummy` if you changed generators

### During Development
1. Keep `test/dummy` up to date with your changes
2. Run unit tests frequently (they're fast)
3. Run installation tests before pushing

### Before Release
1. Run full test suite: `bundle exec rake test:all`
2. Test in fresh `test/dummy`
3. Verify CI passes

## Related Documentation

- `test/UNIT_TESTS_README.md` - Unit test details
- `ci/Jenkinsfile.simple` - CI configuration
- `Rakefile` - Test task definitions
- `README.md` - Gem installation guide

---

**Last Updated**: 2026-01-04  
**Ruby Version**: 3.3.x  
**Rails Version**: 7.0+
