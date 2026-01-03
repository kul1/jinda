# CI Configuration

This directory contains continuous integration configuration files for the Jinda gem.

## Jenkinsfile

The `Jenkinsfile` defines a complete CI/CD pipeline for building, testing, and validating the Jinda gem.

### Prerequisites

- Jenkins server with:
  - Ruby installed (version 3.3.0 or compatible)
  - Docker installed (for MongoDB tests)
  - Git plugin
  - Pipeline plugin

### Pipeline Configuration

In your Jenkins job configuration:

1. **Pipeline Definition**: Pipeline script from SCM
2. **SCM**: Git
3. **Repository URL**: Your Jinda repository URL
4. **Script Path**: `ci/Jenkinsfile`
5. **Branch**: `jinda-0.8.0` (or your target branch)

### Pipeline Stages

The pipeline executes the following stages:

1. **Setup** - Verify Ruby/gem environment
2. **Checkout** - Clone repository and show commit info
3. **Install Dependencies** - Install required gems (bundler, minitest-reporters, rubocop, etc.)
4. **RuboCop - Root** - Run RuboCop on root project files (36 files)
5. **RuboCop - Generators** - Run RuboCop on generator implementation files (4 files)
6. **RuboCop - Templates** - Run RuboCop on template files (63 files)
7. **Start MongoDB** - Launch MongoDB Docker container for tests
8. **Run Tests** - Execute installation_test.rb
9. **Build Gem** - Create .gem package
10. **Validate Gem** - Verify gem structure

### Environment Variables

You can customize the pipeline behavior by setting these environment variables in Jenkins:

| Variable | Default | Description |
|----------|---------|-------------|
| `RUBY_VERSION` | 3.3.0 | Ruby version for documentation |
| `RAILS_VERSION` | 7.1.0 | Rails version for documentation |
| `MONGODB_PORT` | 27017 | Port for MongoDB container |
| `SKIP_CLEANUP` | false | Set to "true" to skip cleanup of test artifacts |

### Artifacts

The pipeline archives:

- `rubocop-root.json` - RuboCop results for root files
- `rubocop-generators.json` - RuboCop results for generators
- `rubocop-templates.json` - RuboCop results for templates
- `jinda-*.gem` - Built gem package

### Post-Build Actions

**Always:**
- Archives RuboCop JSON results
- Archives built gem package
- Stops and removes MongoDB Docker container
- Cleans up test artifacts (unless `SKIP_CLEANUP=true`)

**On Success:**
- Prints success message (can be extended with notifications)

**On Failure:**
- Prints failure message (can be extended with notifications)

### Local Testing

To test the pipeline stages locally:

```bash
cd /Users/kul/mygem/jinda

# Test RuboCop (all three zones)
rubocop --config .rubocop.yml
cd lib/generators/jinda && rubocop --config .rubocop.yml *.rb
cd templates && rubocop --config .rubocop.yml

# Start MongoDB
docker run -d --name jinda_mongodb_local -p 27017:27017 mongo:latest

# Run tests
MONGODB_PORT=27017 ruby test/installation_test.rb

# Build gem
gem build jinda.gemspec

# Cleanup
docker stop jinda_mongodb_local
docker rm jinda_mongodb_local
```

### Troubleshooting

**MongoDB container already exists:**
The pipeline checks if a MongoDB container is already running and reuses it if available.

**RuboCop failures:**
The pipeline uses `|| true` to make RuboCop non-blocking. Review the archived JSON files for details.

**Test failures:**
The pipeline uses `|| true` for tests to make them non-blocking. Review the console output for test results.

### Integration with GitHub Actions

This project also uses GitHub Actions (`.github/workflows/ci.yml`). The Jenkinsfile provides an alternative CI/CD option for organizations using Jenkins infrastructure.

**Key differences:**
- Jenkinsfile uses Docker for MongoDB (GitHub Actions uses service containers)
- Jenkinsfile archives artifacts (GitHub Actions uses artifact upload actions)
- Jenkinsfile supports custom environment variables for flexibility
