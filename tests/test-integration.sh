#!/bin/bash

# Docker-based Integration Tests for Setup Groovy Action
# This script tests the action in isolated Docker containers

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ACTION_DIR="$(dirname "$SCRIPT_DIR")"  # Parent directory of tests/
TEST_RESULTS_DIR="$SCRIPT_DIR/test-results"

# Ensure test results directory exists
mkdir -p "$TEST_RESULTS_DIR"

log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[PASS]${NC} $1"
}

log_error() {
    echo -e "${RED}[FAIL]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

# Check if Docker is available
check_docker() {
    if ! command -v docker &> /dev/null; then
        log_error "Docker is not installed or not in PATH"
        exit 1
    fi
    
    if ! docker info &> /dev/null; then
        log_error "Docker daemon is not running"
        exit 1
    fi
    
    log_info "Docker is available"
}

# Test on Ubuntu container
test_ubuntu() {
    log_info "Testing on Ubuntu container..."
    
    local container_name="groovy-action-test-ubuntu"
    local dockerfile_content="FROM ubuntu:22.04

# Install dependencies
RUN apt-get update && apt-get install -y \\
    curl \\
    unzip \\
    openjdk-11-jdk \\
    && rm -rf /var/lib/apt/lists/*

# Set up environment
ENV JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64
ENV PATH=\$PATH:\$JAVA_HOME/bin

# Create test user
RUN useradd -m -s /bin/bash testuser
USER testuser
WORKDIR /home/testuser

# Copy action files
COPY setup-groovy-action/ ./setup-groovy-action/

# Create test script
RUN echo '#!/bin/bash' > test.sh && \\
    echo 'set -e' >> test.sh && \\
    echo 'export HOME=/home/testuser' >> test.sh && \\
    echo 'export GITHUB_PATH=/tmp/github_path' >> test.sh && \\
    echo 'export GITHUB_OUTPUT=/tmp/github_output' >> test.sh && \\
    echo 'touch \$GITHUB_PATH \$GITHUB_OUTPUT' >> test.sh && \\
    echo 'cd /home/testuser' >> test.sh && \\
    echo '# Test action file structure' >> test.sh && \\
    echo 'if [ ! -f \"setup-groovy-action/action.yml\" ]; then' >> test.sh && \\
    echo '  echo \"❌ Action file not found\"' >> test.sh && \\
    echo '  exit 1' >> test.sh && \\
    echo 'fi' >> test.sh && \\
    echo 'echo \"✅ Action file found\"' >> test.sh && \\
    echo '# Test that SDKMAN can be downloaded (without installing)' >> test.sh && \\
    echo 'if curl -s --head \"https://get.sdkman.io\" | grep -q \"200 OK\"; then' >> test.sh && \\
    echo '  echo \"✅ SDKMAN endpoint accessible\"' >> test.sh && \\
    echo 'else' >> test.sh && \\
    echo '  echo \"❌ SDKMAN endpoint not accessible\"' >> test.sh && \\
    echo '  exit 1' >> test.sh && \\
    echo 'fi' >> test.sh && \\
    echo '# Test Java availability' >> test.sh && \\
    echo 'if java -version 2>&1 | grep -q \"openjdk\"; then' >> test.sh && \\
    echo '  echo \"✅ Java is available\"' >> test.sh && \\
    echo 'else' >> test.sh && \\
    echo '  echo \"❌ Java not found\"' >> test.sh && \\
    echo '  exit 1' >> test.sh && \\
    echo 'fi' >> test.sh && \\
    echo 'echo \"✅ Ubuntu integration test completed successfully\"' >> test.sh && \\
    chmod +x test.sh

CMD [\"/bin/bash\", \"test.sh\"]"

    # Create temporary Dockerfile
    echo "$dockerfile_content" > "$TEST_RESULTS_DIR/Dockerfile.ubuntu"
    
    # Build and run container
    if docker build -t "$container_name" -f "$TEST_RESULTS_DIR/Dockerfile.ubuntu" "$(dirname "$ACTION_DIR")" > "$TEST_RESULTS_DIR/ubuntu-build.log" 2>&1; then
        log_info "Ubuntu container built successfully"
        
        if docker run --rm "$container_name" > "$TEST_RESULTS_DIR/ubuntu-test.log" 2>&1; then
            log_success "Ubuntu test passed"
            echo "Test output:"
            cat "$TEST_RESULTS_DIR/ubuntu-test.log" | tail -10
            return 0
        else
            log_error "Ubuntu test failed"
            echo "Error output:"
            cat "$TEST_RESULTS_DIR/ubuntu-test.log" | tail -20
            return 1
        fi
    else
        log_error "Failed to build Ubuntu container"
        cat "$TEST_RESULTS_DIR/ubuntu-build.log" | tail -20
        return 1
    fi
}

# Test action file validation
test_action_validation() {
    log_info "Validating action files..."
    
    # Check if action.yml exists and is valid
    if [[ ! -f "$ACTION_DIR/action.yml" ]]; then
        log_error "Action file not found: $ACTION_DIR/action.yml"
        return 1
    fi
    
    # Basic YAML validation using Python (if available)
    if command -v python3 &> /dev/null; then
        python3 -c "
import sys
try:
    import yaml
    with open('$ACTION_DIR/action.yml', 'r') as f:
        data = yaml.safe_load(f)
    
    # Check required fields
    required = ['name', 'description', 'runs', 'inputs', 'outputs']
    for field in required:
        if field not in data:
            print(f'❌ Missing required field: {field}')
            sys.exit(1)
    
    # Check composite action
    if data.get('runs', {}).get('using') != 'composite':
        print('❌ Action should be composite')
        sys.exit(1)
    
    print('✅ Action YAML validation passed')
    sys.exit(0)
except ImportError:
    print('⚠️  Python yaml module not available, skipping detailed YAML validation')
    # Do basic file existence check instead
    import os
    if os.path.getsize('$ACTION_DIR/action.yml') > 0:
        print('✅ Action file exists and is not empty')
        sys.exit(0)
    else:
        print('❌ Action file is empty')
        sys.exit(1)
except Exception as e:
    print(f'❌ YAML validation error: {e}')
    sys.exit(1)
" > "$TEST_RESULTS_DIR/validation.log" 2>&1
        
        if [[ $? -eq 0 ]]; then
            log_success "Action YAML validation passed"
            return 0
        else
            log_error "Action YAML validation failed"
            cat "$TEST_RESULTS_DIR/validation.log"
            return 1
        fi
    else
        log_warning "Python3 not available, skipping YAML validation"
        return 0
    fi
}

# Test README documentation
test_documentation() {
    log_info "Checking documentation..."
    
    local readme_file="$ACTION_DIR/README.md"
    
    if [[ ! -f "$readme_file" ]]; then
        log_error "README.md not found"
        return 1
    fi
    
    # Check for required sections
    local required_sections=("Usage" "Inputs" "Outputs" "Platform Support")
    local missing_sections=()
    
    for section in "${required_sections[@]}"; do
        if ! grep -qi "## $section\|# $section" "$readme_file"; then
            missing_sections+=("$section")
        fi
    done
    
    if [[ ${#missing_sections[@]} -gt 0 ]]; then
        log_error "Missing README sections: ${missing_sections[*]}"
        return 1
    else
        log_success "Documentation check passed"
        return 0
    fi
}

# Main test function
main() {
    echo "======================================="
    echo "Setup Groovy Action - Integration Tests"
    echo "======================================="
    echo
    
    local tests_passed=0
    local tests_failed=0
    local total_tests=3
    
    # Check prerequisites
    check_docker
    
    # Run tests
    echo "Running integration tests..."
    echo
    
    # Test 1: Action validation
    if test_action_validation; then
        ((tests_passed++))
    else
        ((tests_failed++))
    fi
    
    # Test 2: Documentation
    if test_documentation; then
        ((tests_passed++))
    else
        ((tests_failed++))
    fi
    
    # Test 3: Ubuntu container test
    if test_ubuntu; then
        ((tests_passed++))
    else
        ((tests_failed++))
    fi
    
    # Summary
    echo
    echo "======================================="
    echo "Integration Test Results"
    echo "======================================="
    echo "Total tests: $total_tests"
    echo -e "Passed: ${GREEN}$tests_passed${NC}"
    echo -e "Failed: ${RED}$tests_failed${NC}"
    echo
    echo "Test artifacts saved to: $TEST_RESULTS_DIR"
    
    if [[ $tests_failed -eq 0 ]]; then
        echo -e "${GREEN}🎉 All integration tests passed!${NC}"
        exit 0
    else
        echo -e "${RED}❌ Some integration tests failed.${NC}"
        exit 1
    fi
}

# Cleanup function
cleanup() {
    log_info "Cleaning up test containers and images..."
    docker rmi groovy-action-test-ubuntu 2>/dev/null || true
}

# Set trap for cleanup
trap cleanup EXIT

# Run main function if script is executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi
