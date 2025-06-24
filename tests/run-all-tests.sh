#!/bin/bash

# Test Runner for Setup Groovy Action
# Runs all tests in sequence with clear reporting

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

# Check if we're in the right location
if [[ -f "test-action.sh" && -f "test-integration.sh" ]]; then
    # We're in the tests directory
    TEST_DIR="."
elif [[ -f "tests/test-action.sh" && -f "tests/test-integration.sh" ]]; then
    # We're in the action root directory
    TEST_DIR="tests"
else
    log_error "Please run this script from either the action root directory or the tests directory"
    log_info "Usage: ./tests/run-all-tests.sh (from root) or ./run-all-tests.sh (from tests/)"
    exit 1
fi

echo "========================================="
echo "Setup Groovy Action - Complete Test Suite"
echo "========================================="
echo

# Test 1: Unit Tests
log_info "Running Unit Tests..."
echo "----------------------------------------"
if $TEST_DIR/test-action.sh; then
    log_success "Unit tests completed successfully"
    unit_tests_passed=true
else
    log_error "Unit tests failed"
    unit_tests_passed=false
fi

echo
echo "----------------------------------------"
echo

# Test 2: Integration Tests
log_info "Running Integration Tests..."
echo "----------------------------------------"
if $TEST_DIR/test-integration.sh; then
    log_success "Integration tests completed successfully"
    integration_tests_passed=true
else
    log_error "Integration tests failed"
    integration_tests_passed=false
fi

echo
echo "----------------------------------------"
echo

# Test 3: Check test artifacts
log_info "Checking test artifacts..."
if [[ -d "$TEST_DIR/test-results" ]]; then
    artifact_count=$(ls -1 $TEST_DIR/test-results/ | wc -l)
    log_info "Found $artifact_count test artifacts in test-results/"
    echo "Test artifacts:"
    ls -la test-results/ | grep -v "^total" | tail -n +2 | while read line; do
        echo "  📄 $(echo $line | awk '{print $9}')"
    done
else
    log_warning "No test-results directory found"
fi

echo
echo "----------------------------------------"

log_info "Running Fresh Clone Test..."
if $TEST_DIR/test-fresh-clone.sh; then
    log_success "Fresh clone test completed successfully"
    fresh_clone_passed="true"
else
    log_error "Fresh clone test failed"
    fresh_clone_passed="false"
fi

echo
echo "========================================="
echo "Final Test Summary"
echo "========================================="

if [[ "$unit_tests_passed" == "true" ]]; then
    echo -e "✅ Unit Tests: ${GREEN}PASSED${NC}"
else
    echo -e "❌ Unit Tests: ${RED}FAILED${NC}"
fi

if [[ "$integration_tests_passed" == "true" ]]; then
    echo -e "✅ Integration Tests: ${GREEN}PASSED${NC}"
else
    echo -e "❌ Integration Tests: ${RED}FAILED${NC}"
fi

if [[ "$fresh_clone_passed" == "true" ]]; then
    echo -e "✅ Fresh Clone Test: ${GREEN}PASSED${NC}"
else
    echo -e "❌ Fresh Clone Test: ${RED}FAILED${NC}"
fi

echo

if [[ "$unit_tests_passed" == "true" && "$integration_tests_passed" == "true" && "$fresh_clone_passed" == "true" ]]; then
    echo -e "${GREEN}🎉 All tests passed! The Setup Groovy Action is ready for use.${NC}"
    echo
    echo "Next steps:"
    echo "  1. Commit your changes"
    echo "  2. Push to trigger GitHub Actions CI/CD tests"
    echo "  3. Use the action in your workflows"
    exit 0
else
    echo -e "${RED}❌ Some tests failed. Please review the output above and fix any issues.${NC}"
    echo
    echo "Troubleshooting:"
    echo "  - Check test-results/ directory for detailed logs"
    echo "  - Ensure Docker is running for integration tests"
    echo "  - Verify fresh clone setup works correctly"
    echo "  - Verify action.yml syntax and structure"
    exit 1
fi
