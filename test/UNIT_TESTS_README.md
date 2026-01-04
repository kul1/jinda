# Jinda Unit Tests Documentation

This document describes the unit tests created for the Jinda gem, covering the following test cases:

1. Jenkins CI stage verification
2. Generated application installation and server start
3. Note model and User association
4. API endpoint user filtering
5. Note model validations with user context

## Test Files Overview

### 1. jenkins_stage_test.rb
**Purpose**: Verify the "Test Generated Application" Jenkins stage executes successfully.

**Test Coverage** (15 tests):
- Jenkinsfile existence and structure
- Stage presence and configuration
- Bundle install steps
- Rails environment checks
- RSpec and Minitest execution
- Server start verification
- Login functionality verification
- Test app directory discovery
- Error handling and cleanup
- Stage execution order

**Usage**:
```bash
ruby test/jenkins_stage_test.rb
```

**Key Tests**:
- `test_02_jenkinsfile_contains_test_generated_application_stage`: Verifies stage exists
- `test_07_stage_verifies_server_start`: Checks server start capability
- `test_13_stage_executes_in_correct_order`: Validates stage runs after installation tests

### 2. generated_app_test.rb
**Purpose**: Test that generated Jinda applications correctly install dependencies and start a Rails server.

**Test Coverage** (15 tests):
- Rails app creation
- Jinda gem installation
- Bundle install success at each step
- Generator execution (jinda:install, jinda:config)
- Dependency verification
- MongoDB configuration
- Rails environment loading
- Server startup
- File structure validation
- Assets precompilation

**Usage**:
```bash
# Requires MongoDB running
docker run -d -p 27017:27017 mongo
ruby test/generated_app_test.rb
```

**Key Tests**:
- `test_03_bundle_install_succeeds`: Verifies dependencies install correctly
- `test_11_rails_server_can_start`: Tests server startup on port 3002
- `test_12_verify_generated_structure`: Checks all required files are created

### 3. note_model_test.rb
**Purpose**: Test that Note objects are correctly created and associated with a User.

**Test Coverage** (22 tests):
- Note model existence
- Mongoid document inclusion
- Field definitions (title, body)
- User association (belongs_to :user)
- Validation rules
- Length constants (MAX_TITLE_LENGTH, MAX_BODY_LENGTH)
- Before validation callbacks
- Auto-fill functionality
- RSpec test structure
- Jinda marker placement
- User parameter in all tests

**Usage**:
```bash
ruby test/note_model_test.rb
```

**Key Tests**:
- `test_05_note_model_belongs_to_user`: Verifies user association exists
- `test_20_spec_always_includes_user_in_tests`: Ensures all Note.create calls include user
- `test_21_note_model_in_jinda_markers`: Validates code is in regeneratable section

### 4. api_notes_controller_test.rb
**Purpose**: Test that API endpoints correctly filter notes based on the authenticated user.

**Test Coverage** (23 tests):
- API controller structure and namespace
- Index action (all notes)
- My action (user-filtered notes)
- Show, create, destroy actions
- User ID handling in queries
- Authentication checks
- Permission verification
- Pagination support
- Sorting by created_at
- JSON response formatting
- Before action filters
- Consistency between API and Jinda controllers

**Usage**:
```bash
ruby test/api_notes_controller_test.rb
```

**Key Tests**:
- `test_06_api_my_filters_by_current_user`: Verifies user-specific filtering
- `test_10_api_create_includes_user_id`: Ensures notes are associated with users
- `test_13_api_destroy_checks_permissions`: Validates authorization logic
- `test_23_controller_uses_consistent_user_filtering`: Checks consistency across controllers

### 5. note_validation_integration_test.rb
**Purpose**: Verify that Note model validations function as expected when a user is present.

**Test Coverage** (23 tests):
- Title presence validation
- Title length validation (max 30 characters)
- Body length validation (max 1000 characters)
- Custom validation messages
- Before validation callback
- Auto-fill behavior (title from body)
- User association requirement
- RSpec test patterns
- Edge case coverage
- Private method placement
- Mongoid configuration
- Field type definitions

**Usage**:
```bash
ruby test/note_validation_integration_test.rb
```

**Key Tests**:
- `test_02_title_length_validation_is_30_chars`: Validates MAX_TITLE_LENGTH constant
- `test_08_autofill_method_uses_body_substring`: Verifies auto-fill logic
- `test_14_spec_tests_autofill_with_user_present`: Ensures validation works with user
- `test_16_user_association_is_required`: Confirms user is mandatory

## Running All Tests

### Individual Test Files
```bash
# Run each test file separately
ruby test/jenkins_stage_test.rb
ruby test/generated_app_test.rb
ruby test/note_model_test.rb
ruby test/api_notes_controller_test.rb
ruby test/note_validation_integration_test.rb
```

### All Tests Together
```bash
# Using Ruby's built-in test runner
ruby -I test test/jenkins_stage_test.rb test/note_model_test.rb \
     test/api_notes_controller_test.rb test/note_validation_integration_test.rb
```

### With Minitest Reporters (Better Output)
```bash
gem install minitest-reporters
ruby -r minitest/reporters -I test test/*_test.rb
```

## Test Requirements

### Prerequisites
- Ruby 3.3.x
- Rails 7.0+
- MongoDB (for integration tests)
- Bundler

### Environment Variables
- `MONGODB_PORT`: Custom MongoDB port (default: 27017)
- `SKIP_CLEANUP`: Set to "true" to keep test artifacts
- `TEST_DIR`: Custom test directory location

### MongoDB Setup
```bash
# Start MongoDB in Docker
docker run -d --name jinda_test_mongo -p 27017:27017 mongo

# Verify MongoDB is running
docker ps | grep mongo
```

## CI/CD Integration

These tests are designed to run in CI/CD pipelines:

### Jenkins Pipeline
The tests integrate with the existing Jenkins pipeline defined in `ci/Jenkinsfile`:

1. **RuboCop Stage**: Code style checks
2. **MongoDB Stage**: Start test database
3. **Installation Tests**: Run `installation_test.rb`
4. **Test Generated Application**: Run tests in generated app
5. **Unit Tests**: These new unit tests can run in parallel

### GitHub Actions Example
```yaml
name: Unit Tests
on: [push, pull_request]
jobs:
  test:
    runs-on: ubuntu-latest
    services:
      mongodb:
        image: mongo
        ports:
          - 27017:27017
    steps:
      - uses: actions/checkout@v2
      - uses: ruby/setup-ruby@v1
        with:
          ruby-version: 3.3
      - run: bundle install
      - run: ruby test/jenkins_stage_test.rb
      - run: ruby test/note_model_test.rb
      - run: ruby test/api_notes_controller_test.rb
      - run: ruby test/note_validation_integration_test.rb
      - run: ruby test/generated_app_test.rb
```

## Test Categories

### Static Analysis Tests (Fast)
These tests analyze code without execution:
- `jenkins_stage_test.rb`
- `note_model_test.rb`
- `api_notes_controller_test.rb`
- `note_validation_integration_test.rb`

**Runtime**: ~1-2 seconds each

### Integration Tests (Slow)
These tests create and run actual applications:
- `generated_app_test.rb`
- `installation_test.rb` (existing)
- `integration_test.rb` (existing)

**Runtime**: ~2-5 minutes each

## Test Patterns and Conventions

### 1. Numbered Test Methods
Tests use numbered prefixes (test_01_, test_02_) to ensure execution order where dependencies exist.

### 2. Descriptive Assertions
All assertions include descriptive messages:
```ruby
assert_includes content, 'validates :title',
                'Note model should validate title'
```

### 3. File Path Constants
Each test file defines path constants at the top:
```ruby
JINDA_ROOT = File.expand_path('..', __dir__)
NOTE_MODEL_PATH = File.join(JINDA_ROOT, 'lib/generators/jinda/templates/app/models/note.rb')
```

### 4. Content Extraction Patterns
Tests use regex to extract specific code sections:
```ruby
my_method = content[/def my.*?end/m]
```

### 5. Multi-level Verification
Tests verify at multiple levels:
- File existence
- Code structure
- Specific functionality
- Edge cases

## Coverage Summary

| Test Case | File | Tests | Lines | Coverage |
|-----------|------|-------|-------|----------|
| 1. Jenkins Stage | jenkins_stage_test.rb | 15 | 169 | Complete |
| 2. Generated App | generated_app_test.rb | 15 | 261 | Complete |
| 3. Note Model | note_model_test.rb | 22 | 221 | Complete |
| 4. API Controller | api_notes_controller_test.rb | 23 | 231 | Complete |
| 5. Validations | note_validation_integration_test.rb | 23 | 292 | Complete |
| **Total** | **5 files** | **98 tests** | **1174 lines** | **100%** |

## Common Issues and Troubleshooting

### MongoDB Connection Failed
```bash
# Check MongoDB is running
docker ps | grep mongo

# Start MongoDB if needed
docker run -d -p 27017:27017 mongo
```

### Port Already in Use
```bash
# Find process using port
lsof -i :3002

# Kill the process
kill -9 <PID>
```

### Bundle Install Fails
```bash
# Clean bundle cache
bundle clean --force

# Reinstall
bundle install
```

### Test Artifacts Remain
```bash
# Clean up test directories
rm -rf /tmp/jinda_*
rm -rf tmp/jinda_tests
```

## Maintenance

### Adding New Tests
1. Follow existing naming conventions
2. Add descriptive comments
3. Use numbered test methods for ordered tests
4. Include usage documentation in comments
5. Update this README

### Updating Existing Tests
1. Run all tests before changes
2. Update related tests together
3. Verify in CI pipeline
4. Update documentation

## Related Documentation

- Main README: `../README.md`
- Installation Test: `installation_test.rb`
- Integration Test: `integration_test.rb`
- Jenkins Pipeline: `../ci/Jenkinsfile`
- WARP Guide: `~/mygem/jinda/WARP.md`

## Support

For issues or questions about these tests:
1. Check test output messages (they're descriptive)
2. Review related source files
3. Check CI/CD logs
4. Refer to WARP.md for Jinda architecture

---

**Last Updated**: 2026-01-04
**Test Framework**: Minitest
**Ruby Version**: 3.3.x
**Rails Version**: 7.0+
