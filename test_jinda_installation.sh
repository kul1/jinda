#!/bin/bash
# Test script for Jinda gem installation and development setup
# This script validates each step of the Jinda installation process

set -e  # Exit on error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Configuration
TEST_APP_NAME="jinda_test_app_$(date +%s)"
TEST_DIR="$HOME/tmp/jinda_tests"
JINDA_GEM_PATH="$HOME/mygem/jinda"
MONGODB_PORT=${MONGODB_PORT:-27017}  # Use env var or default to standard port

echo "=========================================="
echo "Jinda Gem Installation Test Suite"
echo "=========================================="

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

# Function to cleanup
cleanup() {
    if [ "$SKIP_CLEANUP" != "true" ]; then
        print_info "Cleaning up test directory..."
        cd "$HOME"
        rm -rf "$TEST_DIR/$TEST_APP_NAME"
        
        # Stop and remove MongoDB container if we created it
        if [ -n "$NEW_MONGO_CONTAINER" ]; then
            print_info "Stopping test MongoDB container..."
            docker stop "$NEW_MONGO_CONTAINER" > /dev/null 2>&1
            docker rm "$NEW_MONGO_CONTAINER" > /dev/null 2>&1
        fi
    else
        print_info "Skipping cleanup. Test app at: $TEST_DIR/$TEST_APP_NAME"
        if [ -n "$NEW_MONGO_CONTAINER" ]; then
            print_info "MongoDB container: $NEW_MONGO_CONTAINER (will not be stopped)"
        fi
    fi
}

trap cleanup EXIT

# Create test directory
mkdir -p "$TEST_DIR"
cd "$TEST_DIR"

# Test 1: Check prerequisites
echo ""
echo "Test 1: Checking prerequisites..."
echo "-----------------------------------"

# Check Ruby version
RUBY_VERSION=$(ruby -v | awk '{print $2}')
if [[ "$RUBY_VERSION" =~ ^3\.3\. ]]; then
    print_status "Ruby version: $RUBY_VERSION"
else
    print_error "Ruby version $RUBY_VERSION is not 3.3.x"
    exit 1
fi

# Check Rails
RAILS_VERSION=$(rails -v | awk '{print $2}')
print_status "Rails version: $RAILS_VERSION"

# Check MongoDB - find any running MongoDB container or start one
print_info "Checking MongoDB setup..."

# Try to find existing MongoDB container
EXISTING_MONGO=$(docker ps --format '{{.Names}}' | grep mongo | head -1 || echo "")

if [ -n "$EXISTING_MONGO" ]; then
    print_status "Using existing MongoDB container: $EXISTING_MONGO"
    # Get the port of existing container
    EXISTING_PORT=$(docker port "$EXISTING_MONGO" | grep 27017 | cut -d':' -f2 | head -1)
    if [ -n "$EXISTING_PORT" ]; then
        MONGODB_PORT=$EXISTING_PORT
        print_status "MongoDB running on port: $MONGODB_PORT"
    fi
else
    # Check if port is already in use
    if lsof -i :$MONGODB_PORT > /dev/null 2>&1; then
        print_status "MongoDB already running on port $MONGODB_PORT (non-Docker)"
    else
        print_info "Starting new MongoDB container for testing..."
        docker run -d --name jinda_test_mongodb_${TEST_APP_NAME} \
            -p $MONGODB_PORT:27017 \
            mongo:latest > /dev/null 2>&1
        
        if [ $? -eq 0 ]; then
            print_status "MongoDB container started on port $MONGODB_PORT"
            # Wait for MongoDB to be ready
            print_info "Waiting for MongoDB to be ready..."
            sleep 5
            NEW_MONGO_CONTAINER="jinda_test_mongodb_${TEST_APP_NAME}"
        else
            print_error "Failed to start MongoDB container"
            print_info "Please ensure MongoDB is running on port $MONGODB_PORT"
            exit 1
        fi
    fi
fi

# Test 2: Create new Rails app
echo ""
echo "Test 2: Creating new Rails application..."
echo "-----------------------------------"
print_info "Creating Rails app (this may take a minute)..."
rails new "$TEST_APP_NAME" --skip-test --skip-bundle --skip-active-record > /dev/null 2>&1
if [ $? -eq 0 ]; then
    cd "$TEST_APP_NAME"
    print_status "Rails app created: $TEST_APP_NAME"
else
    print_error "Failed to create Rails app"
    exit 1
fi

# Test 3: Add Jinda gem to Gemfile
echo ""
echo "Test 3: Adding Jinda gem to Gemfile..."
echo "-----------------------------------"
echo "gem 'jinda', path: '$JINDA_GEM_PATH'" >> Gemfile
print_status "Jinda gem added to Gemfile"

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
# Test 10: Run jinda:update
echo ""
echo "Test 10: Running rails jinda:update..."
echo "-----------------------------------"
rails jinda:update
if [ $? -eq 0 ]; then
    print_status "jinda:update completed successfully"
else
    print_error "jinda:update failed"
    exit 1
fi
echo "-----------------------------------"
rails jinda:seed
# Test 10: Run jinda:update
echo ""
echo "Test 10: Running rails jinda:update..."
echo "-----------------------------------"
rails jinda:update
if [ $? -eq 0 ]; then
    print_status "jinda:update completed successfully"
else
    print_error "jinda:update failed"
    exit 1
fi
if [ $? -eq 0 ]; then
    print_status "jinda:seed completed successfully"
else
    print_error "jinda:seed failed"
    exit 1
fi

# Test 10: Check if app can initialize
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
echo "Test Summary"
echo "=========================================="
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
    print_status "jinda:update completed successfully"
else
    print_error "jinda:update failed"
    exit 1
fi
echo "  9. ✓ rails jinda:update
  10. ✓ Rails environment initialized"
echo ""

echo ""
print_info "Test app location: $TEST_DIR/$TEST_APP_NAME"
print_info "To preserve test app, run with: SKIP_CLEANUP=true ./test_jinda_installation.sh"
echo ""
print_status "Jinda gem installation test completed successfully!"
