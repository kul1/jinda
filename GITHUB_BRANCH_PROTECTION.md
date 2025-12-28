# GitHub Branch Protection Configuration

This guide shows how to configure branch protection rules for the Jinda repository to ensure code quality and proper review process.

## Requirements

Before merging to `main`:
1. ✅ RuboCop must pass
2. ✅ All tests must pass
3. ✅ Only authorized user can approve/merge
4. ✅ CI workflow must complete successfully

## Setting Up Branch Protection

### Step 1: Navigate to Settings

1. Go to your GitHub repository: `https://github.com/YOUR_USERNAME/jinda`
2. Click **Settings** (top menu)
3. Click **Branches** (left sidebar under "Code and automation")
4. Click **Add rule** or **Add branch protection rule**

### Step 2: Configure Protection Rules

#### Branch Name Pattern
```
main
```

#### Protection Rules to Enable

**1. Require a pull request before merging**
- ☑ Enable this option
- Set "Required number of approvals before merging" to **1**
- ☑ **Dismiss stale pull request approvals when new commits are pushed**
- ☑ **Require review from Code Owners** (optional)

**2. Require status checks to pass before merging**
- ☑ Enable this option
- ☑ **Require branches to be up to date before merging**
- Add required status checks:
  - `test` (from CI workflow)
  - `Run RuboCop` (from CI workflow)
  
  *Note: Status checks appear in the list after the first CI run*

**3. Require conversation resolution before merging**
- ☑ Enable this option (all review comments must be resolved)

**4. Restrict who can push to matching branches**
- ☑ Enable this option
- Add your GitHub username to "Restrict pushes that create matching branches"
- This ensures only you can push directly to main (emergency only)

**5. Allow force pushes**
- ☐ **Leave disabled** (prevent force pushes to main)

**6. Allow deletions**
- ☐ **Leave disabled** (prevent branch deletion)

**7. Require signed commits** (recommended)
- ☑ Enable if you want commit signature verification

### Step 3: Save Rules

Click **Create** or **Save changes** at the bottom

## Workflow After Configuration

### Creating Pull Requests

```bash
# Create feature branch
git checkout -b feature/my-new-feature

# Make changes and commit
git add .
git commit -m "Add new feature"

# Push to GitHub
git push origin feature/my-new-feature
```

Then on GitHub:
1. Create Pull Request from `feature/my-new-feature` to `main`
2. Wait for CI to run (RuboCop + Tests)
3. If CI passes, you can approve and merge
4. If CI fails, fix issues and push new commits

### CI Status Checks

The CI will automatically run:

```yaml
Jobs:
  1. Run RuboCop ← Must pass
  2. Run installation tests ← Must pass
```

### Review Process

**For Your Own PRs:**
- GitHub will require at least 1 approval
- You can approve your own PRs (as repository owner)
- But you should still review changes carefully

**For Collaborators (if any):**
- Only you (repository owner) can approve merges
- Collaborators can submit PRs but cannot merge

## Alternative: Protecting Without Pull Requests

If you want to push directly to main but still run checks:

1. **Don't enable** "Require a pull request before merging"
2. **Enable** "Require status checks to pass before merging"
   - Add: `test` and `Run RuboCop`
3. Push directly:
   ```bash
   git push origin main  # Will be rejected if CI fails on server
   ```

*Note: This is less safe as you won't see CI results before pushing*

## Setting Up Code Owners (Optional)

Create `.github/CODEOWNERS` file:

```
# Repository ownership
* @YOUR_GITHUB_USERNAME

# Specific directories
/lib/generators/ @YOUR_GITHUB_USERNAME
/test/ @YOUR_GITHUB_USERNAME
/.github/ @YOUR_GITHUB_USERNAME
```

This automatically requests your review on all PRs.

## Verification

After setup, test the protection:

```bash
# Try to push without CI passing
git checkout main
echo "test" > test.txt
git add test.txt
git commit -m "Test protection"
git push origin main
```

You should see:
- ❌ **Push rejected** if status checks not passed
- ✅ Or needs to go through PR process

## Bypassing Protection (Emergency)

As repository owner, you can:
1. Temporarily disable branch protection
2. Push emergency fix
3. Re-enable protection

**Better approach:**
```bash
# Create emergency hotfix branch
git checkout -b hotfix/critical-issue
# Fix and push
git push origin hotfix/critical-issue
# Create PR with "urgent" label
# Merge after quick CI check
```

## Local Development Workflow

### Before Committing

```bash
# Run RuboCop locally
rubocop

# Auto-fix issues
rubocop -a

# Run tests
rake test

# Or run both
rake  # Runs rubocop + test
```

### Pre-commit Hook (Optional)

Create `.git/hooks/pre-commit`:

```bash
#!/bin/bash

echo "Running RuboCop..."
rubocop --config .rubocop.yml

if [ $? -ne 0 ]; then
  echo "RuboCop failed. Fix issues before committing."
  exit 1
fi

echo "Running tests..."
rake test

if [ $? -ne 0 ]; then
  echo "Tests failed. Fix before committing."
  exit 1
fi
```

Make it executable:
```bash
chmod +x .git/hooks/pre-commit
```

## Troubleshooting

### Status Checks Not Appearing

**Problem:** Required status checks don't show in the list

**Solution:**
1. Push a branch and create a PR
2. Wait for CI to run once
3. Go back to branch protection settings
4. The status checks should now appear in the dropdown

### CI Failing on RuboCop

**Problem:** RuboCop fails with violations

**Solution:**
```bash
# Check locally first
rubocop

# Auto-fix what can be fixed
rubocop -a

# Review remaining issues
rubocop --format offenses
```

### Can't Merge Own PR

**Problem:** GitHub won't let you merge even though you're the owner

**Solution:**
- Check "Allow specified actors to bypass required pull requests" in settings
- Add yourself to the bypass list
- Or temporarily disable "Require pull request" for emergency

## Summary

After configuration:
- ✅ All code goes through CI (RuboCop + Tests)
- ✅ Only you can approve/merge to main
- ✅ Force pushes blocked
- ✅ Branch deletion blocked
- ✅ History protected

This ensures code quality and prevents accidental breaking changes!

## Quick Reference Commands

```bash
# Check code locally before pushing
rubocop                    # Check style
rubocop -a                 # Auto-fix issues  
rake test                  # Run tests
rake                       # Run RuboCop + tests

# Create feature branch
git checkout -b feature/name
git push origin feature/name

# Create PR on GitHub, wait for CI, merge when green
```
