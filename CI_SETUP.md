# Jinda CI/CD Test Setup - Final Configuration

## ✅ Complete Setup

### Local Testing
```bash
cd ~/mygem/jinda
rake test
# or simply:
rake
```

### GitHub CI Testing
Tests run **automatically** when you push to:
- `main` branch
- `develop` branch  
- Any `jinda-*` branch (e.g., `jinda-0.9.0`)

## How It Works

### 1. Rakefile Configuration
```ruby
require 'rake/testtask'

Rake::TestTask.new(:test) do |t|
  t.libs << 'test'
  t.libs << 'lib'
  t.test_files = FileList['test/**/*_test.rb']
  t.verbose = true
  t.warning = false
end

task default: :test  # Makes 'rake' alone run tests
```

### 2. GitHub Actions Workflow
**File**: `.github/workflows/ci.yml`

**Key Features**:
- ✅ **No hardcoded versions** - Reads from `jinda.gemspec`
- ✅ **MongoDB service** - Automatically provided
- ✅ **Rake integration** - Uses `rake test` (same as local)
- ✅ **Artifact upload** - Test apps saved on failure

**Workflow steps**:
1. Checkout code
2. Read Ruby version from gemspec
3. Set up Ruby
4. Read Rails version from gemspec  
5. Install Rails
6. Install dependencies (bundler, minitest-reporters, rake)
7. Display versions
8. **Run `rake test`**
9. Upload artifacts if failed

### 3. Test Execution
```bash
# CI runs:
MONGODB_PORT=27888 SKIP_CLEANUP=false rake test

# Same as local:
rake test
```

## Version Management

### Automatic Version Detection
The CI workflow automatically detects versions from `jinda.gemspec`:

```yaml
# Read Ruby version
RUBY_VERSION=$(grep 'required_ruby_version' jinda.gemspec | grep -oE '[0-9]+\.[0-9]+\.[0-9]+')

# Read Rails version
RAILS_VERSION=$(grep "add_runtime_dependency 'rails'" jinda.gemspec | grep -oE '[0-9]+\.[0-9]+\.[0-9]+')
```

**This means**: When you update `jinda.gemspec`, CI automatically uses new versions!

Example in gemspec:
```ruby
spec.required_ruby_version = '>= 3.3.0'
spec.add_runtime_dependency 'rails', '~> 7.1.0'
```

CI will use: Ruby 3.3.0 and Rails 7.1.0

## Test Suite

### 12 Sequential Tests
1. **Prerequisites** - Ruby, Rails, MongoDB
2. **Create Rails app** - `rails new`
3. **Add Jinda gem** - Append to Gemfile
4. **Bundle install** - Initial install
5. **jinda:install** - Run generator
6. **Bundle install** - Post-generator
7. **jinda:config** - Configuration generator
8. **Update MongoDB** - Port configuration
9. **jinda:seed** - Seed database
10. **Rails environment** - Load test
11. **Rails server** - Start and HTTP test
12. **Verify files** - All files exist

### Test Order Enforcement
```ruby
class JindaInstallationTest < Minitest::Test
  # Tests must run in order (installation workflow)
  i_suck_and_my_tests_are_order_dependent!
  
  def self.test_order
    :alpha
  end
end
```

## Commands Reference

### Local Development
```bash
# Run all tests
rake test
rake  # same as above

# Run with cleanup disabled
SKIP_CLEANUP=true rake test

# Run with custom MongoDB port
MONGODB_PORT=27017 rake test

# Run directly (not recommended)
ruby test/installation_test.rb
```

### CI Behavior
```bash
# What CI runs:
MONGODB_PORT=27888 SKIP_CLEANUP=false rake test
```

## Maintenance

### Updating Ruby/Rails Versions
1. Update `jinda.gemspec`:
   ```ruby
   spec.required_ruby_version = '>= 3.4.0'  # New version
   spec.add_runtime_dependency 'rails', '~> 7.2.0'  # New version
   ```

2. Update dashboard view:
   ```haml
   %li Ruby 3.4.0+
   %li Rails 7.2.0+
   ```

3. Push to GitHub
   ```bash
   git add jinda.gemspec lib/generators/jinda/templates/app/views/jinda/index.html.haml
   git commit -m "Update to Ruby 3.4.0 and Rails 7.2.0"
   git push
   ```

4. **CI automatically uses new versions** - No workflow changes needed!

### Adding New Tests
```ruby
def test_13_my_new_feature
  skip "App not created yet" unless @@app_created
  
  # Test code here
  assert something, "Error message"
end
```

## Troubleshooting

### Local Test Failures
```bash
# Keep test app for debugging
SKIP_CLEANUP=true rake test

# Navigate to test app
cd ~/tmp/jinda_tests/jinda_test_XXXXX

# Investigate manually
ls -la app/controllers/
rails server
```

### CI Failures
1. Check GitHub Actions logs
2. Download test artifacts (preserved for 7 days)
3. Check versions match gemspec
4. Verify MongoDB service is healthy

## Files Created

1. **test/installation_test.rb** - 12 sequential tests
2. **test/test_helper.rb** - Test configuration
3. **test/README.md** - Detailed documentation
4. **Rakefile** - Test task with default
5. **.github/workflows/ci.yml** - CI workflow (no hardcoded versions)
6. **TESTING.md** - Quick reference
7. **.ruby-version** - Ruby 3.3.0
8. **CI_SETUP.md** - This file

## Benefits

✅ **Zero Maintenance** - Versions auto-read from gemspec  
✅ **Consistent** - Same command locally and CI (`rake test`)  
✅ **Complete Coverage** - Full installation workflow tested  
✅ **Fast Feedback** - Runs on every push  
✅ **Debuggable** - Test artifacts preserved on failure  
✅ **Standard** - Uses Rake (Ruby standard)  

## Success Metrics

When everything works:
```
Run options: --seed 45866

# Running:

............

Finished in 27.91s, 0.43 runs/s, 1.18 assertions/s.

12 runs, 33 assertions, 0 failures, 0 errors, 0 skips
```

## Conclusion

The CI/CD pipeline is **production-ready** and **zero-maintenance**:
- Tests run automatically on push
- Versions update automatically from gemspec
- Same experience locally and in CI
- Complete installation workflow validated

Just run `rake test` locally, and push to GitHub for automatic CI validation!
