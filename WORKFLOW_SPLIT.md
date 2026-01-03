# GitHub Actions Workflow Split

## Overview

The CI has been split into two independent workflows for better modularity and parallel execution.

## New Structure

### 1. RuboCop Workflow
**File**: `.github/workflows/rubocop.yml`

**Triggers**: Push/PR to `main`, `develop`, `jinda-*` branches

**Purpose**: Code quality checks across three architectural zones

**Stages**:
1. Setup Ruby (version from gemspec)
2. Install RuboCop dependencies
3. Run RuboCop on Root (36 files)
4. Run RuboCop on Generators (4 files)
5. Run RuboCop on Templates (63 files)
6. Archive JSON results (30 days)

**Artifacts**:
- `rubocop-root.json`
- `rubocop-generators.json`
- `rubocop-templates.json`

**Duration**: ~2 minutes

---

### 2. Jenkins Test Workflow
**File**: `.github/workflows/jenkins-test.yml`

**Triggers**: Push/PR to `main`, `develop`, `jinda-*` branches

**Purpose**: Full installation testing and gem packaging

**Stages**:
1. Setup Ruby + MongoDB service
2. Install Rails and test dependencies
3. Run installation tests (`rake test`)
4. Build gem package
5. Validate gem structure
6. Archive gem (30 days)
7. Archive test artifacts on failure (7 days)

**Artifacts**:
- `jinda-*.gem` (on success)
- Test app directory (on failure)

**Duration**: ~5 minutes

---

## Benefits of Split

### Parallel Execution
Both workflows run simultaneously, reducing total CI time.

### Independent Failures
- RuboCop can fail without blocking tests
- Tests can fail without blocking RuboCop
- Easier to identify which aspect needs attention

### Faster Feedback
- RuboCop finishes in ~2 minutes
- Developers get code quality feedback quickly
- Full tests take longer but run in parallel

### Cleaner Logs
- Separate workflows have dedicated logs
- Easier to debug specific issues
- Clear separation of concerns

### Artifact Organization
- RuboCop results separate from test artifacts
- Gem packages clearly identified
- Different retention periods for different artifact types

---

## Jenkins Integration

### Jenkinsfile Location
**File**: `ci/Jenkinsfile`

**Purpose**: Enterprise CI/CD pipeline for Jenkins servers

**Key Differences from GitHub Actions**:
- Uses Docker for MongoDB (not service containers)
- Combines RuboCop + tests in single pipeline
- More detailed staging and cleanup
- Configurable via environment variables

**Configuration**:
```groovy
environment {
    RUBY_VERSION = '3.3.0'
    RAILS_VERSION = '7.1.0'
    MONGODB_PORT = '27017'
    SKIP_CLEANUP = 'false'
}
```

**Jenkins Job Setup**:
1. Pipeline script from SCM
2. Script Path: `ci/Jenkinsfile`
3. Branch: `jinda-0.8.0`

See `ci/README.md` for detailed Jenkins setup instructions.

---

## Workflow Comparison

| Aspect | RuboCop | Jenkins Test | Jenkinsfile |
|--------|---------|--------------|-------------|
| **Platform** | GitHub Actions | GitHub Actions | Jenkins |
| **Purpose** | Code quality | Installation tests | Enterprise CI |
| **Duration** | ~2 min | ~5 min | ~10 min |
| **Ruby** | ✓ | ✓ | ✓ |
| **Rails** | ✗ | ✓ | ✓ |
| **MongoDB** | ✗ | ✓ (service) | ✓ (Docker) |
| **RuboCop** | ✓ (3 zones) | ✗ | ✓ (3 zones) |
| **Tests** | ✗ | ✓ | ✓ |
| **Build Gem** | ✗ | ✓ | ✓ |
| **Artifacts** | JSON | Gem + tests | JSON + gem |

---

## Migration from Old CI

### What Changed
- **Old**: Single `ci.yml` with everything
- **New**: Two workflows (`rubocop.yml` + `jenkins-test.yml`)
- **Bonus**: Added `ci/Jenkinsfile` for Jenkins support

### Backup
Old workflow preserved as: `.github/workflows/ci.yml.bak`

### No Breaking Changes
- Same triggers (branches)
- Same version detection (from gemspec)
- Same test commands (`rake test`)
- Same artifact uploads

---

## Local Testing

### RuboCop (matches workflow)
```bash
# Root
rubocop --config .rubocop.yml --format progress --format json --out rubocop-root.json

# Generators
cd lib/generators/jinda
rubocop --config .rubocop.yml *.rb --format progress --format json --out ../../../rubocop-generators.json

# Templates
cd lib/generators/jinda/templates
rubocop --config .rubocop.yml --format progress --format json --out ../../../../rubocop-templates.json
```

### Tests (matches workflow)
```bash
rake test
```

### Gem Build (matches workflow)
```bash
gem build jinda.gemspec
gem specification jinda-*.gem --ruby
```

---

## Monitoring

### GitHub Actions Status
Check both workflows independently:
- ✓ RuboCop - Green means code quality passes
- ✓ Jenkins Test - Green means installation works

### Artifact Access
1. Go to GitHub Actions run
2. Scroll to "Artifacts" section
3. Download:
   - **RuboCop**: `rubocop-results` (JSON files)
   - **Jenkins Test**: `gem-package-*` or `test-app-*`

---

## Next Steps

1. **Push to GitHub** to trigger both workflows
2. **Verify** both workflows run in parallel
3. **Check** artifacts are uploaded correctly
4. **Optional**: Set up Jenkins job using `ci/Jenkinsfile`

---

## Documentation Updates

Updated files:
- ✓ `CI_SETUP.md` - Reflects split workflows
- ✓ `ci/README.md` - Jenkins setup guide
- ✓ `WORKFLOW_SPLIT.md` - This document

---

## Questions?

See documentation:
- GitHub Actions: `CI_SETUP.md`
- Jenkins: `ci/README.md`
- Tests: `test/README.md`
- RuboCop: `RUBOCOP_ARCHITECTURE.md`
