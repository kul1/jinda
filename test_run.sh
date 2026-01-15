#!/bin/bash
# Ensure running with bash
if [ -z "$BASH_VERSION" ]; then
  echo "Error: This script requires bash. Please run with 'bash $0' instead of 'sh $0'."
  exit 1
fi
# Test script for Jinda gem installation and development setup
# This script validates each step of the Jinda installation process
#
# IMPORTANT: To persist directory changes (stay in the created app), source this script:
#   . ./test_run.sh
# Running as ./test_run.sh will create the app but return to original directory.

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Configuration
TEST_APP_NAME="jinda_test_app_$(date +%s)"
JINDA_GEM_PATH="$HOME/mygem/jinda"
JINDA_ADMIN_LTE_GEM_PATH="$HOME/mygem/jinda_adminlte"
MONGODB_PORT=${MONGODB_PORT:-27017}  # Use env var or default to standard port

# Default: no cleanup (preserve app)
DO_CLEANUP=false

# Parse options
while getopts ":C" opt; do
  case ${opt} in
    C )
      DO_CLEANUP=true
      ;;
    \? )
      echo "Usage: $0 [-C]  # -C to force cleanup after tests"
      echo "To persist in app directory, source: . $0"
      exit 1
      ;;
  esac
done

# Function to print status
print_status() {
    echo -e "${GREEN}[✓]${NC} $1"
}

print_error() {
    echo -e "${RED}[✗]${NC} $1"
}

print_info() {
    echo -e "${YELLOW}[i]${NC} $1"
}

# Cleanup function (defined early for trap)
cleanup() {
    if [ -n "$TEST_APP_NAME" ] && [ -d "$TEST_APP_NAME" ]; then
        cd ..
        rm -rf "$TEST_APP_NAME"
        print_info "Test app $TEST_APP_NAME cleaned up."
    fi
    if [ -n "$NEW_MONGO_CONTAINER" ]; then
        docker stop "$NEW_MONGO_CONTAINER" > /dev/null 2>&1 || true
        docker rm "$NEW_MONGO_CONTAINER" > /dev/null 2>&1 || true
        print_info "Test MongoDB container stopped and removed."
    fi
    print_status "Cleanup completed successfully."
}

# Trap for cleanup on exit (if requested)
trap cleanup EXIT

print_info "Starting Jinda installation test..."

SCRIPT_NAME=$(basename "$0")
if [ "$0" = "$BASH_SOURCE" ]; then
    print_info "Running as executed script (./$SCRIPT_NAME)"
else
    print_info "Running as sourced script (. $SCRIPT_NAME) - cd will persist."
fi
print_info "This script will create the app and auto-start Rails server on port 3000+ at the end."
print_info "Ctrl+C to stop server and return to original directory."
echo ""
print_info "NOTE: For sh compatibility, run with 'bash $SCRIPT_NAME' instead of 'sh $SCRIPT_NAME'."

# Ensure Rails is installed (only once)
if ! command -v rails > /dev/null 2>&1 || ! rails -v > /dev/null 2>&1; then
  echo "Installing Rails 7.1.6..."
  gem install rails -v 7.1.6
fi

echo "=========================================="
echo "Jinda Gem Installation Test Suite"
echo "=========================================="

# Check Rails version
RAILS_VERSION=$(rails -v | awk '{print $2}')
print_status "Rails version: $RAILS_VERSION"

# Capture current git branch from jinda gem
CURRENT_BRANCH=$(cd "$JINDA_GEM_PATH" && git branch --show-current 2>/dev/null || echo "main")
print_status "Current jinda branch: $CURRENT_BRANCH"

# Check MongoDB setup
print_info "Checking MongoDB setup..."

# Check if Docker is accessible
if ! docker ps > /dev/null 2>&1; then
    print_error "Docker daemon is not running or not accessible."
    echo "Please start Docker and ensure it's running, then rerun the script."
    echo "Please ensure mongodb available port: 27017"
    exit 1
fi

EXISTING_MONGO=$(docker ps --format '{{.Names}}' | grep mongo | head -1 || echo "")
if [ -n "$EXISTING_MONGO" ]; then
    print_status "Using existing MongoDB container: $EXISTING_MONGO"
    EXISTING_PORT=$(docker port "$EXISTING_MONGO" 2>/dev/null | grep 27017 | cut -d':' -f2 | head -1)
    if [ -n "$EXISTING_PORT" ]; then
        MONGODB_PORT=$EXISTING_PORT
        print_status "MongoDB running on port: $MONGODB_PORT"
    fi
else
    if lsof -i :$MONGODB_PORT > /dev/null 2>&1; then
        print_status "MongoDB already running on port $MONGODB_PORT (non-Docker)"
    else
    # Check if Docker is accessible before attempting to start container
    if ! docker ps > /dev/null 2>&1; then
        print_error "Docker daemon is not running or not accessible."
        echo "Please start Docker and ensure it's running, then rerun the script."
        echo "Please ensure mongodb available port: 27017"
        exit 1
    fi

    print_info "Starting new MongoDB container for testing..."
    NEW_MONGO_CONTAINER="jinda_test_mongodb_${TEST_APP_NAME}"
    docker run -d --name "$NEW_MONGO_CONTAINER" \
        -p $MONGODB_PORT:27017 \
        mongo:latest > /dev/null 2>&1

    if [ $? -eq 0 ]; then
        print_status "MongoDB container started on port $MONGODB_PORT"
        sleep 5  # Wait for ready
    else
        print_error "Failed to start MongoDB container"
        echo "Please ensure mongodb available port: 27017"
        exit 1
    fi
    fi
fi

# Test 1: Create new Rails app
echo ""
echo "Test 1: Creating new Rails application..."
echo "-----------------------------------"
print_info "Creating Rails app (this may take a minute)..."
rails new "$TEST_APP_NAME" --skip-test --skip-bundle --skip-active-record > /dev/null 2>&1
if [ $? -eq 0 ]; then
    cd "$TEST_APP_NAME"
    print_status "Rails app created and entered: $TEST_APP_NAME"

    # Switch to same branch as jinda gem (if git init'd)
    if git rev-parse --git-dir > /dev/null 2>&1; then
        if [ -n "$CURRENT_BRANCH" ] && [ "$CURRENT_BRANCH" != "main" ]; then
            print_info "Switching to $CURRENT_BRANCH branch..."
            git checkout -b "$CURRENT_BRANCH" > /dev/null 2>&1 || true
            print_status "Branch set to $CURRENT_BRANCH"
        fi
    fi
else
    print_error "Failed to create Rails app"
    exit 1
fi

# Test 2: Add Jinda gems to Gemfile
echo ""
echo "Test 2: Adding Jinda gems to Gemfile..."
echo "-----------------------------------"
echo "gem 'jinda', path: '$JINDA_GEM_PATH'" >> Gemfile
echo "gem 'jinda_adminlte', path: '$JINDA_ADMIN_LTE_GEM_PATH'" >> Gemfile
print_status "Jinda & jinda_adminlte gems added to Gemfile"

# Test 3: Bundle install
echo ""
echo "Test 3: Running bundle install..."
echo "-----------------------------------"
print_info "Installing gems (this may take a minute)..."
bundle install > /dev/null 2>&1
if [ $? -eq 0 ] && bundle show jinda > /dev/null 2>&1; then
    print_status "Bundle install successful - Jinda available"
else
    print_error "Bundle install failed or Jinda not found"
    bundle install  # Debug
    exit 1
fi

# Test 4: jinda:install generator
echo ""
echo "Test 4: Running rails generate jinda:install..."
echo "-----------------------------------"
print_info "Running generator (auto-accepting prompts)..."
rails generate jinda:install --force --quiet --skip-collision-check
if [ $? -eq 0 ]; then
    print_status "jinda:install generator completed"
else
    print_error "jinda:install generator failed"
    exit 1
fi

# Test 5: Bundle install post-generator
echo ""
echo "Test 5: Running bundle install (after generator)..."
echo "-----------------------------------"
bundle install > /dev/null 2>&1
if [ $? -eq 0 ]; then
    print_status "Post-generator bundle install successful"
else
    print_error "Post-generator bundle install failed"
    exit 1
fi

# Test 6: jinda:config generator
echo ""
echo "Test 6: Running rails generate jinda:config..."
echo "-----------------------------------"
print_info "Running config generator..."
rails generate jinda:config --force --quiet --skip-collision-check
if [ $? -eq 0 ]; then
    print_status "jinda:config generator completed"
    # Update mongoid port
    sed -i.bak "s/localhost:27017/localhost:$MONGODB_PORT/g" config/mongoid.yml
    print_status "MongoDB config updated to port $MONGODB_PORT"
else
    print_error "jinda:config generator failed"
    exit 1
fi

# Test 7: Seed database
echo ""
echo "Test 7: Running rails jinda:seed..."
echo "-----------------------------------"
rails jinda:seed
print_status "Database seeded (admin/secret user created)"

# Test 8: jinda:update (twice, suppress warnings)
echo ""
echo "Test 8: Running rake jinda:update (verification)..."
echo "-----------------------------------"
print_info "Running jinda:update (suppressing non-error output)..."
if rake jinda:update 2>/dev/null || [ $? -eq 0 ]; then
    if rake jinda:update > /dev/null 2>&1 2>/dev/null || [ $? -eq 0 ]; then
        print_status "jinda:update completed successfully (twice, warnings suppressed)"
    else
        print_error "Second jinda:update failed"
        exit 1
    fi
else
    print_error "First jinda:update failed"
    exit 1
fi

# Test 9: Verify Rails env loads
echo ""
echo "Test 9: Testing Rails environment load..."
echo "-----------------------------------"
bundle exec rails runner "puts 'Rails env loaded OK'"
if [ $? -eq 0 ]; then
    print_status "Rails environment loads successfully"
else
    print_error "Rails env load failed"
    exit 1
fi

# Final summary (only if not cleaning up)
if [ "$DO_CLEANUP" == "true" ]; then
    print_info "Running cleanup mode..."
    cleanup
    print_status "Test completed with cleanup. No app/server started."
    exit 0
else
    echo ""
    echo "=========================================="
    echo "Jinda Installation Test Summary"
    echo "=========================================="
    print_status "ALL TESTS PASSED! Jinda app ready."
    echo ""
    echo "Created app: $TEST_APP_NAME"
    APP_FULL_PATH="$(pwd)"
    PARENT_DIR="$(cd .. && pwd)"
    echo "App directory: $APP_FULL_PATH"
    echo "Parent directory: $PARENT_DIR"
    echo ""
    print_info "Next steps (once in app dir):"
    echo "  Visit http://localhost:3000"
    echo "  Login: admin / secret"
    echo "  Check Admin menu for Mindmap Editor"
    echo ""
    print_info "To cleanup later: cd \"$PARENT_DIR\" && rm -rf $TEST_APP_NAME"
    print_info "For future runs with cleanup: $0 -C"
    echo ""
    print_status "Auto-starting Rails server on first available port (3000+)..."
    echo ""

    # Find first available port starting from 3000 (portable for sh)
    PORT=3000
    while [ $PORT -le 3010 ]; do
        if ! lsof -i :$PORT > /dev/null 2>&1; then
            break
        fi
        PORT=`expr $PORT + 1`
    done

    if [ $PORT -gt 3010 ]; then
        print_error "No available port found (3000-3010 busy). Starting interactive shell instead."
        print_info "Run 'rails s -p 3011' manually or free a port."
        exec bash -i
    else
        print_status "Starting Rails server on http://localhost:$PORT (bind 0.0.0.0)..."
        print_info "Login: admin/secret | Ctrl+C to stop server and return to original dir."
        echo ""
        # Start server in foreground, replacing script process (portable)
        exec bundle exec rails server -b 0.0.0.0 -p $PORT
    fi
fi
echo "Test 2: Creating new Rails application..."
echo "-----------------------------------"
print_info "Creating Rails app (this may take a minute)..."
rails new "$TEST_APP_NAME" --skip-test --skip-bundle --skip-active-record > /dev/null 2>&1
if [ $? -eq 0 ]; then
    cd "$TEST_APP_NAME"
    print_status "Rails app created: $TEST_APP_NAME"

    # Switch to same branch as jinda gem
    if [ -n "$CURRENT_BRANCH" ]; then
        print_info "Switching to $CURRENT_BRANCH branch..."
        git checkout -b "$CURRENT_BRANCH" > /dev/null 2>&1
        if [ $? -eq 0 ]; then
            print_status "Switched to $CURRENT_BRANCH branch"
        else
            print_error "Failed to create $CURRENT_BRANCH branch"
        fi
    fi
else
    print_error "Failed to create Rails app"
    exit 1
fi

# Test 3: Add Jinda gem to Gemfile
echo ""
echo "Test 3: Adding Jinda gem to Gemfile..."
echo "-----------------------------------"
echo "gem 'jinda', path: '$JINDA_GEM_PATH'" >> Gemfile
echo "gem 'jinda_adminlte', path: '$JINDA_ADMIN_LTE_GEM_PATH'" >> Gemfile
print_status "Jinda & Jinda_adminlte gem added to Gemfile"

# Test 4: Bundle install
echo ""
echo "Test 4: Running bundle install..."
echo "-----------------------------------"
print_info "Installing gems (this may take a minute)..."
bundle install > /dev/null 2>&1
if [ $? -eq 0 ]; then
    print_status "Bundle install successful"
else
    print_error "Bundle install failed"
    bundle install  # Show output for debugging
    exit 1
fi

# Verify jinda gem is installed
if bundle show jinda > /dev/null 2>&1; then
    print_status "Jinda gem is available in bundle"
else
    print_error "Jinda gem not found in bundle"
    exit 1
fi

# Test 5: Run jinda:install generator
echo ""
echo "Test 5: Running rails generate jinda:install..."
echo "-----------------------------------"
print_info "Running generator (auto-accepting prompts)..."
rails generate jinda:install --force --quiet
if [ $? -eq 0 ]; then
    print_status "jinda:install generator completed"
else
    print_error "jinda:install generator failed"
    rails generate jinda:install  # Show output for debugging
    exit 1
fi

# Test 6: Bundle install again (for new gems added by generator)
echo ""
echo "Test 6: Running bundle install (after generator)..."
echo "-----------------------------------"
print_info "Installing additional gems..."
bundle install > /dev/null 2>&1
if [ $? -eq 0 ]; then
    print_status "Bundle install successful"
else
    print_error "Bundle install failed"
    bundle install  # Show output for debugging
    exit 1
fi

# Test 7: Run jinda:config generator
echo ""
echo "Test 7: Running rails generate jinda:config..."
echo "-----------------------------------"
print_info "Running config generator (auto-accepting prompts)..."
rails generate jinda:config --force --quiet
if [ $? -eq 0 ]; then
    print_status "jinda:config generator completed"
else
    print_error "jinda:config generator failed"
    rails generate jinda:config  # Show output for debugging
    exit 1
fi

# Update mongoid.yml to use correct MongoDB port
print_info "Updating MongoDB configuration..."
sed -i.bak "s/localhost:27017/localhost:$MONGODB_PORT/" config/mongoid.yml
print_status "MongoDB configuration updated"

# Test 8: Run jinda:seed
echo ""
echo "Test 8: Running rails jinda:seed..."
rails jinda:seed
# Test 10: Run jinda:update
echo ""
echo "Test 10: Running rails jinda:update..."
echo "-----------------------------------"
rails jinda:update
if [ $? -eq 0 ]; then
    print_status "First jinda:update completed successfully"
    # Run second update
    rails jinda:update > /dev/null 2>&1
    if [ $? -eq 0 ]; then
        print_status "Second jinda:update completed successfully"
    else
        print_error "Second jinda:update failed"
    fi
else
    print_error "First jinda:update failed"
    exit 1
fi
echo ""
echo "Test 10: Testing Rails environment initialization..."
echo "-----------------------------------"
bundle exec rails runner "puts 'Rails environment loaded successfully'"
if [ $? -eq 0 ]; then
    print_status "Rails environment initialized successfully"
else
    print_error "Rails environment initialization failed"
    exit 1
fi

# # Test 10: Start Rails server and test
# echo ""
# echo "Test 10: Testing Rails server..."
# echo "-----------------------------------"
# print_info "Starting Rails server on port 3000..."
#
# # Start server in background
# bundle exec rails server -p 3000 -d
#
# # Wait for server to start
# sleep 5
#
# # Check if server is running
# if lsof -i :3000 > /dev/null 2>&1; then
#     print_status "Rails server started successfully on port 3000"
#
#     # Test HTTP response
#     print_info "Testing HTTP request to localhost:3000..."
#     HTTP_CODE=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:3000)
#
#     if [ "$HTTP_CODE" == "200" ] || [ "$HTTP_CODE" == "302" ]; then
#         print_status "Server responding correctly (HTTP $HTTP_CODE)"
#     else
#         print_error "Server returned HTTP $HTTP_CODE"
#     fi
#
#     # Stop the server
#     print_info "Stopping Rails server..."
#     if [ -f tmp/pids/server.pid ]; then
#         kill $(cat tmp/pids/server.pid) 2>/dev/null || true
#         rm -f tmp/pids/server.pid 2>/dev/null || true
#     fi
# else
#     print_error "Rails server failed to start"
#     exit 1
# fi
#
# # Test 11: Verify key files exist
# echo ""
# echo "Test 11: Verifying installation files..."
# echo "-----------------------------------"
# FILES=(
#     "app/controllers/admins_controller.rb"
#     "app/controllers/articles_controller.rb"
#     "app/models/user.rb"
#     "app/views/jinda/index.html.haml"
#     "config/initializers/jinda.rb"
#     "config/initializers/omniauth.rb"
#     "config/mongoid.yml"
#     "db/seeds.rb"
# )
#
# for file in "${FILES[@]}"; do
#     if [ -f "$file" ]; then
#         print_status "File exists: $file"
#     else
#         print_error "File missing: $file"
#     fi
# done
#
# # Summary
# echo ""
echo "=========================================="
# Ensure Rails is installed
if ! command -v rails > /dev/null 2>&1 || ! rails -v > /dev/null 2>&1; then
  echo "Installing Rails..."
  gem install rails -v 7.1.6
fi
echo "Test Summary"
echo "=========================================="
# Ensure Rails is installed
if ! command -v rails > /dev/null 2>&1 || ! rails -v > /dev/null 2>&1; then
  echo "Installing Rails..."
  gem install rails -v 7.1.6
fi
print_status "All tests passed successfully!"
echo ""
echo "Installation steps verified:"
echo "  1. ✓ Prerequisites checked"
echo "  2. ✓ Rails app created"
echo "  3. ✓ Jinda gem added to Gemfile"
echo "  4. ✓ Bundle install successful"
echo "  5. ✓ rails generate jinda:install"
echo "  6. ✓ Bundle install (post-generator)"
echo "  7. ✓ rails generate jinda:config"
echo "  8. ✓ rails jinda:seed"
# Test 10: Run jinda:update
echo ""
echo "Test 10: Running rails jinda:update..."
echo "-----------------------------------"
rails jinda:update
if [ $? -eq 0 ]; then
    print_status "First jinda:update completed successfully"
    # Run second update
    rails jinda:update > /dev/null 2>&1
    if [ $? -eq 0 ]; then
        print_status "Second jinda:update completed successfully"
    else
        print_error "Second jinda:update failed"
    fi
else
    print_error "First jinda:update failed"
    exit 1
fi
print_info "Test app location: $TEST_DIR/$TEST_APP_NAME"
print_info "Full path: $(pwd)/$TEST_APP_NAME"
print_info "To force cleanup, run with: ./test_jinda_installation.sh -C"
echo ""
echo ""

