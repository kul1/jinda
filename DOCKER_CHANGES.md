# Docker Configuration Standardization - Summary

## Problem Statement
The Dockerfile in the generator template was set up to copy the entire application, but Docker configurations were using non-standard MongoDB ports (27071, 27888) and contained personal paths. This created conflicts for:
- CI/CD pipelines (Jenkinsfile, GitHub Actions)
- Test scripts (test_jinda_installation.sh)
- Installation tests (test/installation_test.rb)

## Changes Made

### 1. Docker Compose Files Standardized

#### `docker-compose.yml`
- **Before**: Port 27071:27017
- **After**: Port 27017:27017 (standard)

#### `docker-compose-mongodb.yml`
- **Before**: Port 27888:27017
- **After**: Port 27017:27017 (standard)
- **Purpose**: MongoDB-only for development and CI (recommended)

#### `docker-compose-web.yml`
- **Before**: Port 27888:27017, personal paths (`/Users/kul/mygem/...`)
- **After**: 
  - Port 27017:27017 (standard)
  - Personal paths removed
  - Added comments/TODOs for developers to add their own paths
  - Added proper volume configuration
  - Added container name and volume name

### 2. Dockerfile Enhanced
- Added clarifying comments explaining purpose
- Documented that it's for full stack deployment with docker-compose-web.yml
- Noted that CI should use docker-compose-mongodb.yml for MongoDB only
- Improved structure with better comments

### 3. Generator Updates (`config_generator.rb`)
- Updated finish message to explain Docker options clearly
- Added DOCKER.md to generated files
- Better instructions for MongoDB-only vs full stack usage

### 4. CI Configuration Updates

#### GitHub Actions (`.github/workflows/jenkins-test.yml`)
- **Before**: MongoDB port 27888
- **After**: MongoDB port 27017 (standard)

#### Jenkinsfile (`ci/Jenkinsfile`)
- Already uses port 27017 (correct)
- Confirms this is the standard for CI

### 5. Test Scripts Updated

#### `test_jinda_installation.sh`
- **Before**: Hardcoded MONGODB_PORT=27888
- **After**: MONGODB_PORT=${MONGODB_PORT:-27017} (uses env var or defaults to standard)

#### `test/installation_test.rb`
- Already flexible with MONGODB_PORT env var (defaults to 27017)
- No changes needed

### 6. Documentation Created

#### New file: `DOCKER.md` (copied to generated apps)
- Comprehensive Docker usage guide
- Explains all Docker files and their purposes
- Step-by-step instructions for MongoDB-only vs full stack
- CI/CD guidelines
- Troubleshooting section
- Best practices

## Standard Port Policy

**All Docker configurations now use MongoDB port 27017 (the standard port)**

### Benefits:
1. **Consistency**: Same port across dev, test, and CI
2. **Compatibility**: Works with standard MongoDB clients
3. **No Special Config**: mongoid.yml uses default localhost:27017
4. **CI-Friendly**: GitHub Actions, Jenkins, etc. expect standard ports

## Usage Patterns

### For Local Development (Recommended)
```bash
docker compose -f docker-compose-mongodb.yml up -d
rails server
```

### For Full Stack Testing
```bash
# Edit docker-compose-web.yml first to add local gem paths if needed
docker compose -f docker-compose-web.yml up -d
```

### For CI/CD
```yaml
services:
  mongodb:
    image: mongo:latest
    ports:
      - 27017:27017
```

## No Conflict with Existing Setups

The changes maintain backward compatibility:
- Installation tests still support custom ports via MONGODB_PORT env var
- Test scripts can override default port
- Personal docker-compose files can be created for specific needs
- Generic templates avoid personal information

## Files Modified

1. `lib/generators/jinda/templates/Dockerfile` - Added comments
2. `lib/generators/jinda/templates/docker-compose.yml` - Port 27017
3. `lib/generators/jinda/templates/docker-compose-mongodb.yml` - Port 27017
4. `lib/generators/jinda/templates/docker-compose-web.yml` - Port 27017, removed personal paths
5. `lib/generators/jinda/templates/DOCKER.md` - New documentation
6. `lib/generators/jinda/config_generator.rb` - Updated messages, copy DOCKER.md
7. `.github/workflows/jenkins-test.yml` - Port 27017
8. `test_jinda_installation.sh` - Default port 27017

## Files Created

1. `lib/generators/jinda/templates/DOCKER.md` - Complete Docker documentation
2. `DOCKER_CHANGES.md` - This summary document

## Testing Checklist

- [ ] Run `ruby test/installation_test.rb` - should pass with port 27017
- [ ] Run `MONGODB_PORT=27017 ./test_jinda_installation.sh` - should pass
- [ ] GitHub Actions CI should pass with standard port
- [ ] Generate new app and verify all Docker files are created
- [ ] Verify DOCKER.md is copied to new applications
- [ ] Test `docker compose -f docker-compose-mongodb.yml up -d` works
- [ ] Test `docker compose -f docker-compose-web.yml up -d` works (after editing paths)

## Migration Guide for Existing Projects

If you have existing Jinda applications using non-standard ports:

### Option 1: Update to Standard Port
```bash
# Edit config/mongoid.yml
sed -i 's/localhost:27888/localhost:27017/g' config/mongoid.yml
sed -i 's/localhost:27071/localhost:27017/g' config/mongoid.yml

# Update docker-compose files
sed -i 's/27888:27017/27017:27017/g' docker-compose*.yml
sed -i 's/27071:27017/27017:27017/g' docker-compose*.yml
```

### Option 2: Keep Custom Port
```bash
# Set environment variable before running
export MONGODB_PORT=27888
docker compose -f docker-compose-mongodb.yml up -d
```

## Benefits Summary

1. **Standardization**: One port across all environments
2. **Simplicity**: No configuration needed for default setup
3. **CI-Friendly**: Works out-of-box with CI services
4. **Generic**: No personal paths in templates
5. **Documented**: Clear DOCKER.md for users
6. **Flexible**: Still supports custom ports via env vars

## Future Considerations

1. Consider environment-specific docker-compose files (dev, test, prod)
2. Add docker-compose for production deployment
3. Consider adding docker-compose for multiple MongoDB instances (replica sets)
4. Add health checks to all services
5. Consider adding docker-compose for with Redis, Sidekiq, etc.
