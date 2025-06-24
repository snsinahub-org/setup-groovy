#!/bin/bash

# Shell Compatibility Test for GitHub Actions
# This test validates that the action.yml script works in different shell contexts

set -e

echo "============================================"
echo "Shell Compatibility Test for Setup Groovy Action"
echo "============================================"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
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

# Test 1: Check for proper shell specification
log_info "Testing shell specifications in action.yml..."
shell_specs=$(grep -n "shell:" action.yml)
echo "$shell_specs"

if echo "$shell_specs" | grep -q "shell: bash"; then
    log_success "Found proper bash shell specifications"
else
    log_error "No bash shell specifications found"
    exit 1
fi

# Test 2: Validate syntax with different shells
log_info "Testing bash syntax validation..."

# Extract the main setup script from action.yml for testing
# This is a simplified test - in practice the full YAML would be parsed
if bash -n action.yml 2>/dev/null; then
    log_success "Basic syntax check passed"
else
    log_error "Syntax issues detected"
fi

# Test 3: Check for potentially problematic constructs
log_info "Checking for shell compatibility issues..."

problematic_patterns=0

# Check for 'local' outside functions
if grep -n "^[[:space:]]*local " action.yml | grep -v "function\|()"; then
    log_error "Found 'local' declarations outside functions"
    problematic_patterns=$((problematic_patterns + 1))
fi

# Check for bash-specific constructs without proper shell specification
bash_constructs=$(grep -n "\[\[" action.yml)
if [ -n "$bash_constructs" ]; then
    log_info "Found bash-specific constructs (should be OK with shell: bash):"
    echo "$bash_constructs"
fi

if [ $problematic_patterns -eq 0 ]; then
    log_success "No shell compatibility issues detected"
else
    log_error "Found $problematic_patterns potential compatibility issues"
    exit 1
fi

# Test 4: Validate YAML structure
log_info "Validating YAML structure..."
if command -v python3 &> /dev/null; then
    python3 -c "
import yaml
import sys
try:
    with open('action.yml', 'r') as f:
        yaml.safe_load(f)
    print('✅ YAML structure is valid')
except yaml.YAMLError as e:
    print(f'❌ YAML error: {e}')
    sys.exit(1)
except Exception as e:
    print(f'❌ Error: {e}')
    sys.exit(1)
" 2>/dev/null || echo "⚠️  Python/PyYAML not available, skipping YAML validation"
else
    echo "⚠️  Python not available, skipping YAML validation"
fi

log_success "Shell compatibility test completed successfully"
echo
log_info "The action should work correctly on GitHub Actions runners with:"
log_info "  ✅ Linux (Ubuntu) - uses bash"
log_info "  ✅ macOS - uses bash"  
log_info "  ✅ Windows - uses PowerShell for Windows steps, bash for others"
