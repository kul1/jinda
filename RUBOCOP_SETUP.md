# RuboCop Integration - Complete Setup

## ✅ What Was Configured

### 1. RuboCop Configuration (`.rubocop.yml`)
- **Target Ruby:** 3.3
- **Target Rails:** 7.1
- **Plugins:** rails, performance, minitest
- **Excludes:** templates, test/dummy, vendor, tmp

### 2. Rake Integration (`Rakefile`)
```ruby
task default: [:rubocop, :test]  # Runs both by default
```

### 3. CI Integration (`.github/workflows/ci.yml`)
- RuboCop runs **before** tests
- Must pass for PR to be mergeable
- Separate step for visibility

## Local Usage

### Run RuboCop

```bash
# Check code style
rubocop

# Auto-fix safe issues
rubocop -a

# Auto-fix all issues (including unsafe)
rubocop -A

# Check specific files
rubocop lib/jinda.rb

# Show offenses summary
rubocop --format offenses
```

### Run via Rake

```bash
# Run RuboCop only
rake rubocop

# Run both RuboCop and tests
rake
```

## CI Usage

When you push to GitHub:
1. CI installs RuboCop gems
2. Runs `rubocop --config .rubocop.yml`
3. If fails → PR cannot merge
4. If passes → Proceeds to tests

## Development Workflow

### Before Committing

```bash
# 1. Auto-fix what can be fixed
rubocop -a

# 2. Review remaining issues
rubocop

# 3. Fix manually if needed
# Edit files...

# 4. Run tests
rake test

# 5. Or run everything
rake
```

### During Code Review

If RuboCop fails in CI:
```bash
# Pull latest changes
git pull

# Fix style issues
rubocop -a

# Commit and push
git add .
git commit -m "Fix RuboCop offenses"
git push
```

## RuboCop Configuration Details

### What's Enabled

✅ **Style checks**
- String literals (prefer single quotes)
- Frozen string literals
- Documentation (disabled for this project)

✅ **Layout checks**
- Line length (max 120)
- Method call indentation
- Trailing whitespace

✅ **Metrics**
- Method length (max 50, relaxed for tests)
- Block length (relaxed for tests/Rakefile)
- Class length (max 200)

✅ **Rails-specific**
- Rails best practices
- Output/Exit handling in generators

✅ **Performance**
- Case comparisons
- Other performance improvements

✅ **Minitest**
- Multiple assertions (max 10)
- Test formatting

### What's Excluded

- `vendor/**/*` - Third-party code
- `test/dummy/**/*` - Test fixtures
- `lib/generators/jinda/templates/**/*` - User templates
- `bin/**/*` - Scripts
- `db/**/*` - Database files

## GitHub Branch Protection

### Requirements for Merging to Main

After configuring branch protection (see `GITHUB_BRANCH_PROTECTION.md`):

1. ✅ RuboCop must pass
2. ✅ Tests must pass
3. ✅ Your approval required
4. ✅ All conversations resolved

### CI Status Checks

In PR, you'll see:
```
✓ Run RuboCop
✓ Run installation tests  
```

Both must be green to merge.

## Common RuboCop Issues & Fixes

### Issue: String Literals

```ruby
# Bad
puts "Hello world"

# Good  
puts 'Hello world'
```

**Fix:** `rubocop -a` auto-fixes this

### Issue: Frozen String Literal

```ruby
# Bad
# (missing at top of file)

# Good
# frozen_string_literal: true
```

**Fix:** `rubocop -A` (uppercase A) can add this

### Issue: Line Too Long

```ruby
# Bad
def very_long_method_name_with_many_parameters(param1, param2, param3, param4, param5, param6)

# Good
def very_long_method_name_with_many_parameters(
  param1, param2, param3,
  param4, param5, param6
)
```

**Fix:** Manual refactoring needed

### Issue: Method Too Long

```ruby
# Bad
def huge_method
  # 100 lines of code
end

# Good
def well_factored_method
  helper_method_1
  helper_method_2
  helper_method_3
end
```

**Fix:** Extract methods, manual refactoring

## Ignoring Specific Offenses

### Inline Disable

```ruby
# rubocop:disable Metrics/MethodLength
def legitimately_long_method
  # Complex logic that can't be easily split
end
# rubocop:enable Metrics/MethodLength
```

### File-level Disable

Add to `.rubocop.yml`:
```yaml
Metrics/MethodLength:
  Exclude:
    - 'lib/specific_file.rb'
```

### Cop-specific Disable

```ruby
# rubocop:disable Style/Documentation
class UndocumentedClass
end
# rubocop:enable Style/Documentation
```

## Updating RuboCop Configuration

### Adding New Rules

Edit `.rubocop.yml`:
```yaml
Style/MyNewRule:
  Enabled: true
  EnforcedStyle: my_preference
```

### Relaxing Rules

```yaml
Metrics/ClassLength:
  Max: 300  # Increase from 200
```

### Disabling Rules

```yaml
Style/SomeRule:
  Enabled: false
```

## Integration with Git Hooks

### Pre-commit Hook

Create `.git/hooks/pre-commit`:

```bash
#!/bin/bash

echo "Running RuboCop..."
rubocop --config .rubocop.yml

if [ $? -ne 0 ]; then
  echo ""
  echo "❌ RuboCop failed!"
  echo "Fix with: rubocop -a"
  exit 1
fi

echo "✅ RuboCop passed!"
```

Make executable:
```bash
chmod +x .git/hooks/pre-commit
```

## Troubleshooting

### RuboCop Not Found

```bash
gem install rubocop
gem install rubocop-rails
gem install rubocop-performance
gem install rubocop-minitest
```

### Config Not Loading

```bash
# Check config is valid
rubocop --show-cops

# Use explicit config
rubocop --config .rubocop.yml
```

### Too Many Offenses

```bash
# Fix incrementally
rubocop -a  # Fix safe issues first
git add . && git commit -m "Fix safe RuboCop offenses"

rubocop -A  # Fix remaining auto-fixable
git add . && git commit -m "Fix all auto-fixable offenses"

# Review and fix manually
rubocop --format offenses
```

### CI Passes Locally But Fails on GitHub

```bash
# Ensure same Ruby version
ruby -v

# Use exact same command as CI
rubocop --config .rubocop.yml

# Check git tracked files
git status
```

## Benefits

✅ **Consistent Code Style** - All code follows same conventions
✅ **Catch Issues Early** - Before code review
✅ **Auto-fixable** - Most issues fixed automatically  
✅ **CI Enforced** - Can't merge bad code
✅ **Less Bike-shedding** - Style is automated

## Quick Reference

```bash
# Local development
rubocop              # Check style
rubocop -a           # Auto-fix safe issues
rubocop -A           # Auto-fix all
rake rubocop         # Via Rake
rake                 # RuboCop + tests

# CI (automatic on push)
# - Runs rubocop --config .rubocop.yml
# - Must pass to merge
```

## Next Steps

1. **Run initial cleanup:**
   ```bash
   rubocop -A
   git add .
   git commit -m "Fix RuboCop offenses"
   ```

2. **Configure GitHub branch protection** (see `GITHUB_BRANCH_PROTECTION.md`)

3. **Push to GitHub:**
   ```bash
   git push origin jinda-0.8.0
   ```

4. **Verify CI runs RuboCop** in GitHub Actions

Now your code quality is protected both locally and in CI! 🎉
