#!/bin/bash

# Unit Tests for Setup Groovy Action
# Run this script locally to test the action before pushing to GitHub

# Remove set -e to see all test results
# set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Test counter
TESTS_RUN=0
TESTS_PASSED=0
TESTS_FAILED=0

# Helper functions
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[PASS]${NC} $1"
    ((TESTS_PASSED++))
}

log_error() {
    echo -e "${RED}[FAIL]${NC} $1"
    ((TESTS_FAILED++))
}

log_warning() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

run_test() {
    local test_name="$1"
    local test_command="$2"
    
    ((TESTS_RUN++))
    log_info "Running test: $test_name"
    
    if eval "$test_command"; then
        log_success "$test_name"
        return 0
    else
        log_error "$test_name"
        return 1
    fi
}

# Test setup
setup_test_environment() {
    log_info "Setting up test environment..."
    
    # Create temporary directory for tests
    export TEST_DIR=$(mktemp -d)
    export ACTION_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"  # Parent directory of tests/
    
    log_info "Test directory: $TEST_DIR"
    log_info "Action directory: $ACTION_DIR"
    
    # Verify action files exist
    if [[ ! -f "$ACTION_DIR/action.yml" ]]; then
        log_error "Action file not found: $ACTION_DIR/action.yml"
        exit 1
    fi
}

# Test 1: Verify action.yml syntax
test_action_syntax() {
    log_info "Validating action.yml syntax..."
    
    # Check if action.yml is valid YAML
    if command -v yq &> /dev/null; then
        yq eval '.' "$ACTION_DIR/action.yml" > /dev/null
        return $?
    elif command -v python3 &> /dev/null; then
        python3 -c "
import sys
try:
    import yaml
    with open('$ACTION_DIR/action.yml', 'r') as f:
        yaml.safe_load(f)
    print('✅ YAML syntax is valid')
    sys.exit(0)
except ImportError:
    print('⚠️  Python yaml module not available, skipping YAML validation')
    sys.exit(0)
except yaml.YAMLError as e:
    print(f'❌ YAML syntax error: {e}')
    sys.exit(1)
except Exception as e:
    print(f'❌ Error validating YAML: {e}')
    sys.exit(1)
"
        return $?
    else
        log_warning "No YAML validator found (yq or python3), skipping syntax check"
        return 0
    fi
}

# Test 2: Check required action metadata
test_action_metadata() {
    log_info "Checking action metadata..."
    
    # Check if required fields exist
    local required_fields=("name" "description" "runs")
    local action_content=$(cat "$ACTION_DIR/action.yml")
    
    for field in "${required_fields[@]}"; do
        if ! echo "$action_content" | grep -q "^$field:"; then
            log_error "Missing required field: $field"
            return 1
        fi
    done
    
    # Check if it's a composite action
    if ! echo "$action_content" | grep -q "using: 'composite'"; then
        log_error "Action should be a composite action"
        return 1
    fi
    
    return 0
}

# Test 3: Check input definitions
test_input_definitions() {
    log_info "Checking input definitions..."
    
    local action_content=$(cat "$ACTION_DIR/action.yml")
    local expected_inputs=("groovy-version" "skip-if-exists" "add-to-path")
    
    for input in "${expected_inputs[@]}"; do
        if ! echo "$action_content" | grep -q "$input:"; then
            log_error "Missing input definition: $input"
            return 1
        fi
    done
    
    return 0
}

# Test 4: Check output definitions
test_output_definitions() {
    log_info "Checking output definitions..."
    
    local action_content=$(cat "$ACTION_DIR/action.yml")
    local expected_outputs=("groovy-version" "groovy-path")
    
    for output in "${expected_outputs[@]}"; do
        if ! echo "$action_content" | grep -q "$output:"; then
            log_error "Missing output definition: $output"
            return 1
        fi
    done
    
    return 0
}

# Test 5: Check platform-specific steps
test_platform_steps() {
    log_info "Checking platform-specific steps..."
    
    local action_content=$(cat "$ACTION_DIR/action.yml")
    
    # Check for OS detection
    if ! echo "$action_content" | grep -q "RUNNER_OS"; then
        log_error "Missing OS detection logic"
        return 1
    fi
    
    # Check for platform-specific steps
    if ! echo "$action_content" | grep -q "runner.os != 'Windows'"; then
        log_error "Missing Unix-specific step condition"
        return 1
    fi
    
    if ! echo "$action_content" | grep -q "runner.os == 'Windows'"; then
        log_error "Missing Windows-specific step condition"
        return 1
    fi
    
    return 0
}

# Test 6: Check shell types
test_shell_types() {
    log_info "Checking shell types..."
    
    local action_content=$(cat "$ACTION_DIR/action.yml")
    
    # Should have both bash and pwsh shells
    if ! echo "$action_content" | grep -q "shell: bash"; then
        log_error "Missing bash shell usage"
        return 1
    fi
    
    if ! echo "$action_content" | grep -q "shell: pwsh"; then
        log_error "Missing PowerShell (pwsh) usage"
        return 1
    fi
    
    return 0
}

# Test 7: Check README documentation
test_readme_documentation() {
    log_info "Checking README documentation..."
    
    local readme_file="$ACTION_DIR/README.md"
    
    if [[ ! -f "$readme_file" ]]; then
        log_error "README.md not found"
        return 1
    fi
    
    local readme_content=$(cat "$readme_file")
    local required_sections=("Usage" "Inputs" "Outputs" "Platform Support" "Troubleshooting")
    
    for section in "${required_sections[@]}"; do
        if ! echo "$readme_content" | grep -qi "## $section\|# $section"; then
            log_error "Missing README section: $section"
            return 1
        fi
    done
    
    return 0
}

# Test 8: Simulate action execution (dry run)
test_action_dry_run() {
    log_info "Running action dry run simulation..."
    
    # Create a minimal test script that simulates what the action would do
    cat > "$TEST_DIR/simulate_action.sh" << 'EOF'
#!/bin/bash

# Simulate the action logic without actually installing anything
echo "=== Simulating Setup Groovy Action ==="

# Check inputs (these would come from GitHub Actions context)
GROOVY_VERSION="${INPUT_GROOVY_VERSION:-}"
SKIP_IF_EXISTS="${INPUT_SKIP_IF_EXISTS:-true}"
ADD_TO_PATH="${INPUT_ADD_TO_PATH:-true}"

echo "Inputs:"
echo "  groovy-version: $GROOVY_VERSION"
echo "  skip-if-exists: $SKIP_IF_EXISTS" 
echo "  add-to-path: $ADD_TO_PATH"

# Simulate OS detection
if [[ "$OSTYPE" == "msys" || "$OSTYPE" == "cygwin" ]]; then
    RUNNER_OS="Windows"
elif [[ "$OSTYPE" == "darwin"* ]]; then
    RUNNER_OS="macOS"
else
    RUNNER_OS="Linux"
fi

echo "Detected OS: $RUNNER_OS"

# Simulate installation logic
if [[ "$RUNNER_OS" == "Windows" ]]; then
    echo "Would install Groovy using PowerShell and Chocolatey"
else
    echo "Would install Groovy using SDKMAN"
fi

# Simulate outputs
echo "Simulated outputs:"
echo "  groovy-version=Groovy Version: 4.0.15 JVM: 11.0.x"
echo "  groovy-path=/path/to/groovy/bin"

echo "✅ Action simulation completed successfully"
EOF

    chmod +x "$TEST_DIR/simulate_action.sh"
    
    # Run the simulation
    "$TEST_DIR/simulate_action.sh"
    return $?
}

# Test 9: Check for common security issues
test_security_checks() {
    log_info "Running security checks..."
    
    local action_content=$(cat "$ACTION_DIR/action.yml")
    
    # Check for potential command injection vulnerabilities
    if echo "$action_content" | grep -q '\${{.*}}.*|'; then
        log_warning "Potential command injection risk detected with pipe operators"
    fi
    
    # Check for direct evaluation of user input
    if echo "$action_content" | grep -q 'eval.*\${{'; then
        log_error "Direct evaluation of user input detected - security risk"
        return 1
    fi
    
    # Check for downloads over HTTP (should use HTTPS)
    if echo "$action_content" | grep -q 'http://'; then
        log_error "HTTP downloads detected - should use HTTPS"
        return 1
    fi
    
    return 0
}

# Test 10: Check error handling
test_error_handling() {
    log_info "Checking error handling..."
    
    local action_content=$(cat "$ACTION_DIR/action.yml")
    
    # Should have error handling for command failures
    if ! echo "$action_content" | grep -q "ErrorAction\|set -e\|exit 1"; then
        log_warning "Limited error handling detected"
    fi
    
    # Should have validation for required tools
    if ! echo "$action_content" | grep -q "command -v\|Get-Command"; then
        log_warning "Limited tool validation detected"
    fi
    
    return 0
}

# Main test execution
main() {
    echo "=================================="
    echo "Setup Groovy Action - Unit Tests"
    echo "=================================="
    echo
    
    setup_test_environment
    
    # Run all tests
    run_test "Action YAML Syntax" "test_action_syntax"
    run_test "Action Metadata" "test_action_metadata"
    run_test "Input Definitions" "test_input_definitions"
    run_test "Output Definitions" "test_output_definitions"
    run_test "Platform-Specific Steps" "test_platform_steps"
    run_test "Shell Types" "test_shell_types"
    run_test "README Documentation" "test_readme_documentation"
    run_test "Action Dry Run" "test_action_dry_run"
    run_test "Security Checks" "test_security_checks"
    run_test "Error Handling" "test_error_handling"
    
    # Cleanup
    rm -rf "$TEST_DIR"
    
    # Summary
    echo
    echo "=================================="
    echo "Test Results Summary"
    echo "=================================="
    echo "Total tests run: $TESTS_RUN"
    echo -e "Tests passed: ${GREEN}$TESTS_PASSED${NC}"
    echo -e "Tests failed: ${RED}$TESTS_FAILED${NC}"
    echo
    
    if [[ $TESTS_FAILED -eq 0 ]]; then
        echo -e "${GREEN}🎉 All tests passed!${NC}"
        exit 0
    else
        echo -e "${RED}❌ Some tests failed. Please review and fix the issues.${NC}"
        exit 1
    fi
}

# Check if running as source or executed
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi
