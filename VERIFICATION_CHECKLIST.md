# Setup Verification Checklist

## ✅ Complete This Before Pushing

### 1. Files Exist
- [ ] `.rubocop.yml` exists
- [ ] `.github/workflows/ci.yml` exists
- [ ] `test/installation_test.rb` exists
- [ ] `Rakefile` has rubocop task
- [ ] `.ruby-version` is 3.3.0

### 2. Local Commands Work
```bash
# Check each command:
rubocop --version        # Should show version
rake rubocop            # Should check code
rake test               # Should run tests
rake                    # Should run both
```

### 3. Test Results
Run: `rake test`

Expected output:
```
12 runs, 33 assertions, 0 failures, 0 errors, 0 skips
```

### 4. RuboCop Check
Run: `rubocop`

Fix issues if needed:
```bash
rubocop -a   # Auto-fix
```

### 5. Git Status Clean
```bash
git status
# Commit any changes before pushing
```

### 6. Push to GitHub
```bash
git push origin jinda-0.8.0
```

### 7. Verify CI Runs
1. Go to GitHub repository
2. Click "Actions" tab
3. See latest workflow run
4. Verify both steps pass:
   - ✓ Run RuboCop
   - ✓ Run installation tests

### 8. Configure Branch Protection
Follow: `GITHUB_BRANCH_PROTECTION.md`

1. Go to Settings → Branches
2. Add rule for `main`
3. Require status checks:
   - Run RuboCop
   - test
4. Require pull request reviews: 1
5. Restrict push access to your username
6. Save changes

### 9. Test Branch Protection
```bash
git checkout -b test/protection
echo "test" >> README.md
git add README.md
git commit -m "Test protection"
git push origin test/protection
```

Create PR on GitHub → Verify CI must pass before merge

## Quick Commands Reference

```bash
# Local development
rake                    # Run everything
rake rubocop           # Check style only
rake test              # Run tests only
rubocop -a             # Fix style issues

# Fix and test
rubocop -a && rake test

# Git workflow
git checkout -b feature/name
# make changes
rake                   # Verify locally
git add .
git commit -m "message"
git push origin feature/name
# Create PR on GitHub
```

## Success Criteria

✅ All local commands work
✅ Tests pass (12/12)
✅ RuboCop passes or issues fixed
✅ CI runs on GitHub
✅ Branch protection configured
✅ Test PR blocked until CI passes

## Next Steps After Verification

1. Start normal development workflow
2. Create feature branches
3. Run `rake` before pushing
4. CI validates automatically
5. Merge when green ✓

You're all set! 🎉
