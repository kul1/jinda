#!/bin/bash
# Unit Test Runner for Jinda Gem
# 
# This script runs all unit tests and provides a summary
# Usage: ./test/run_unit_tests.sh

set -e

JINDA_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$JINDA_ROOT"

echo "=========================================="
echo "Jinda Gem Unit Tests"
echo "=========================================="
echo ""

TOTAL_TESTS=0
FAILED_TESTS=0
FAILED_FILES=()

# Function to run a test file
run_test() {
    local test_file="$1"
    local test_name="$2"
    
    echo "Running: $test_name"
    echo "  File: $test_file"
    
    if ruby "$test_file"; then
        echo "  ✓ PASSED"
        echo ""
        return 0
    else
        echo "  ✗ FAILED"
        echo ""
        FAILED_TESTS=$((FAILED_TESTS + 1))
        FAILED_FILES+=("$test_name")
        return 1
    fi
}

# Run static analysis tests (fast)
echo "--- Static Analysis Tests ---"
echo ""

run_test "test/jenkins_stage_test.rb" "Jenkins Stage Test"
run_test "test/note_model_test.rb" "Note Model Test"
run_test "test/api_notes_controller_test.rb" "API Notes Controller Test"
run_test "test/note_validation_integration_test.rb" "Note Validation Integration Test"

TOTAL_TESTS=4

# Optionally run integration tests (slow)
if [ "$RUN_INTEGRATION_TESTS" = "true" ]; then
    echo "--- Integration Tests (Slow) ---"
    echo ""
    echo "Note: Integration tests require MongoDB running on port ${MONGODB_PORT:-27017}"
    echo ""
    
    if run_test "test/generated_app_test.rb" "Generated App Test"; then
        TOTAL_TESTS=$((TOTAL_TESTS + 1))
    else
        TOTAL_TESTS=$((TOTAL_TESTS + 1))
    fi
else
    echo "--- Integration Tests ---"
    echo "Skipped (set RUN_INTEGRATION_TESTS=true to run)"
    echo ""
fi

# Summary
echo "=========================================="
echo "Test Summary"
echo "=========================================="
echo "Total test suites: $TOTAL_TESTS"
echo "Passed: $((TOTAL_TESTS - FAILED_TESTS))"
echo "Failed: $FAILED_TESTS"
echo ""

if [ $FAILED_TESTS -gt 0 ]; then
    echo "Failed test suites:"
    for test in "${FAILED_FILES[@]}"; do
        echo "  - $test"
    done
    echo ""
    exit 1
else
    echo "✓ All tests passed!"
    echo ""
    exit 0
fi
