#!/bin/bash

# Fresh Clone Test Script
# This script simulates what happens when someone clones the repository fresh
# and ensures the development setup works correctly

set -e

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

echo "=============================================="
echo "Setup Groovy Action - Fresh Clone Test"
echo "=============================================="
echo

log_info "Simulating fresh repository clone experience..."

# Check if .venv exists (it shouldn't in a fresh clone)
if [[ -d ".venv" ]]; then
    log_info "Removing existing .venv to simulate fresh clone"
    rm -rf .venv
fi

# Verify .venv is properly excluded from git (if git is available)
if command -v git &> /dev/null && [[ -d ".git" ]]; then
    if git check-ignore .venv &> /dev/null; then
        log_success ".venv is properly ignored by git"
    else
        log_error ".venv is NOT ignored by git - check .gitignore"
        exit 1
    fi
else
    log_info "Git not available or not a git repo - skipping git ignore check"
fi

# Run development setup
log_info "Running dev-setup.sh..."
./dev-setup.sh

# Verify .venv was created
if [[ -d ".venv" ]]; then
    log_success ".venv directory created successfully"
else
    log_error ".venv directory was not created"
    exit 1
fi

# Verify virtual environment works
log_info "Testing virtual environment activation..."
(
    source .venv/bin/activate
    
    # Check Python in virtual environment
    if [[ "$VIRTUAL_ENV" == *".venv" ]]; then
        log_success "Virtual environment activated correctly"
        log_info "Python path: $(which python)"
        log_info "Python version: $(python --version)"
    else
        log_error "Virtual environment not activated correctly"
        exit 1
    fi

    # Test that dependencies are installed
    log_info "Testing installed dependencies..."
    python -c "import yaml; print('PyYAML:', yaml.__version__)" || {
        log_error "PyYAML not installed correctly"
        exit 1
    }

    log_success "Dependencies installed correctly"

    # Run a quick test
    log_info "Running quick action test..."
    ./tests/test-action.sh > /dev/null 2>&1 || {
        log_error "Quick test failed"
        exit 1
    }

    log_success "Quick test passed"
)

echo
log_success "Fresh clone test completed successfully!"
echo
log_info "✅ .venv created automatically"
log_info "✅ Dependencies installed correctly"  
log_info "✅ Tests can run successfully"
log_info "✅ Virtual environment works properly"
echo
log_info "This setup is ready for fresh repository clones!"
