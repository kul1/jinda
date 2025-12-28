# Jinda Gem Development Log

## Project Overview
- **Gem Source Location**: `~/mygem/jinda`
- **Goal**: Fix jinda gem from source and modify Docker setup to run MongoDB only (not entire jinda stack)
- **Started**: 2025-11-21

---

## Environment Setup

### Date: 2025-11-21

#### Step 1: PATH Configuration
- **Action**: Added `~/mybin/jinda/` to PATH in `~/.zshrc`
- **File Modified**: `~/.zshrc`
- **Change**: Added `export PATH="$HOME/mybin/jinda:$PATH"`
- **Purpose**: Enable running jinda shell scripts from anywhere
- **Status**: ✅ Complete

---

## Docker Configuration Changes

### Goal: Run MongoDB Only in Docker
- **Current State**: TBD - Need to assess current Docker setup
- **Target State**: MongoDB running in Docker, jinda gem running locally on host

#### Tasks:
- [ ] Document current Docker setup (docker-compose.yml, Dockerfile)
- [ ] Identify MongoDB configuration
- [ ] Extract MongoDB service to standalone docker-compose.yml
- [ ] Configure MongoDB connection for local jinda gem
- [ ] Test MongoDB connectivity
- [ ] Document connection strings and environment variables

---

## Gem Development Changes

### Date: 2025-11-21

#### OmniAuth Compatibility Updates
**Issue**: OmniAuth 2.x and Rails 7 compatibility problems
- Original error: `Could not find matching strategy for :google_oauth2`
- Root cause: Outdated gem versions and missing CSRF protection config

**Changes Made**:

1. **Updated OmniAuth gem versions in `install_generator.rb`**:
   - `oauth2`: 1.4.4 → ~> 2.0 (required by omniauth-google-oauth2)
   - `omniauth`: 1.9.1 → ~> 2.0 (required for Rails 7 and newer providers)
   - `omniauth-oauth2`: 1.6.0 → ~> 1.8 (compatible with OmniAuth 2.x)
   - `omniauth-identity`: ~> 1.1.1 → ~> 3.1
   - `omniauth-facebook`: 6.0.0 → 10.0.0
   - `omniauth-google-oauth2`: 0.8.0 → ~> 1.1
   - Note: Gem name changed from `omniauth-google_oauth2` (underscore) to `omniauth-google-oauth2` (hyphen)

2. **Added Rails 7 CSRF protection in `config_generator.rb`**:
   - Added `OmniAuth.config.allowed_request_methods = [:post, :get]` to the omniauth initializer template
   - This allows both GET and POST requests for OmniAuth callbacks

3. **Created MongoDB-only Docker Compose template**:
   - New file: `lib/generators/jinda/templates/docker-compose-mongodb.yml`
   - Runs MongoDB container on port 27888 (mapped to 27017 internally)
   - Uses named volume `mongodb_data` for persistence
   - Container name: `jinda_mongodb`

4. **Updated `setup_docker` method** in `config_generator.rb`:
   - Now copies `docker-compose-mongodb.yml` in addition to existing Docker files
   - Updated finish message to show both Docker options:
     - Full stack: `docker compose up -d`
     - MongoDB only: `docker compose -f docker-compose-mongodb.yml up -d`

**Testing**:
- ✅ Updated test app Gemfile with new gem versions
- ✅ Ran `bundle install` successfully
- ✅ Ran `rails generate jinda:config` - omniauth.rb generated correctly
- ✅ Verified `OmniAuth.config.allowed_request_methods = [:post, :get]` is present
- ✅ Started MongoDB-only Docker container successfully
- ✅ Verified container running on port 27888
- ✅ Stopped container cleanly

**Status**: ✅ Complete

#### MongoDB Configuration Templates
The jinda gem includes multiple mongoid.yml templates for different environments:
- `config/mongoid.yml-localhost` - For local development (MongoDB on localhost:27017)
- `config/mongoid.yml-docker` - For Docker environments (MongoDB on mongodb:27017)

**Usage**: Copy the appropriate template to `config/mongoid.yml` based on your setup:
```bash
# For local MongoDB
cp config/mongoid.yml-localhost config/mongoid.yml

# For Docker MongoDB
cp config/mongoid.yml-docker config/mongoid.yml
```

**Note**: When using `docker-compose-mongodb.yml`, MongoDB runs on `localhost:27888`, so use the localhost template.

---

## Testing Log

### Test Results
- Date | Test Type | Result | Notes
- -----|-----------|--------|------

---

## Notes and Issues

### Known Issues
1. [To be documented]

### Dependencies
- MongoDB version: TBD
- Ruby version: TBD
- Other dependencies: TBD

---

## Commands Reference

### Useful Commands
```bash
# Source updated .zshrc
source ~/.zshrc

# Build gem locally
gem build jinda.gemspec

# Install local gem
gem install ./jinda-*.gem

# Start MongoDB in Docker
docker-compose up -d mongodb

# Check MongoDB status
docker ps
```

---

## Next Steps
1. Investigate current Docker setup at `~/mygem/jinda`
2. Document existing configuration
3. Create MongoDB-only docker-compose.yml
4. Test gem connectivity with dockerized MongoDB
