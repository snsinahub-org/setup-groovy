#!/bin/bash

# Development Setup Script for Setup Groovy Action
# This script sets up the development environment for testing and validation

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

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

echo "=========================================="
echo "Setup Groovy Action - Development Setup"
echo "=========================================="
echo
log_info "This script will create a clean, portable development environment"
log_info "Perfect for fresh repository clones - no manual .venv setup needed!"
echo

# Check if Python is available
if ! command -v python3 &> /dev/null; then
    log_error "Python 3 is required for development but not found"
    log_info "Please install Python 3 to run development tools"
    exit 1
fi

log_info "Python 3 found: $(python3 --version)"

# Check if we're in a virtual environment
if [[ -n "$VIRTUAL_ENV" ]]; then
    log_info "Already in virtual environment: $VIRTUAL_ENV"
    USE_EXISTING_VENV=true
else
    USE_EXISTING_VENV=false
fi

# Setup virtual environment for portable development
if [[ "$USE_EXISTING_VENV" == "false" ]]; then
    log_info "Setting up development virtual environment..."
    
    # Remove existing .venv if it exists (to ensure clean, portable setup)
    if [[ -d ".venv" ]]; then
        log_warning "Removing existing .venv directory for clean setup"
        rm -rf .venv
    fi
    
    # Create new virtual environment
    python3 -m venv .venv
    log_success "Virtual environment created at .venv"
    
    # Activate virtual environment
    source .venv/bin/activate
    log_info "Virtual environment activated"
else
    log_info "Using existing virtual environment"
fi

# Install development dependencies
log_info "Installing development dependencies..."
if [[ "$USE_EXISTING_VENV" == "false" ]]; then
    pip install --upgrade pip
else
    python3 -m pip install --upgrade pip
fi

if [[ "$USE_EXISTING_VENV" == "false" ]]; then
    pip install -r requirements-dev.txt
else
    python3 -m pip install -r requirements-dev.txt
fi

log_success "Development dependencies installed"

# Make test scripts executable
log_info "Making test scripts executable..."
chmod +x tests/*.sh

log_success "Test scripts are now executable"

echo
log_success "Development environment setup complete!"
echo
log_info "You can now run:"
log_info "  ./tests/run-all-tests.sh    # Run all tests"
log_info "  ./tests/test-action.sh      # Run unit tests"  
log_info "  ./tests/test-integration.sh # Run integration tests"
echo
if [[ "$USE_EXISTING_VENV" == "false" ]]; then
    log_info "To activate the virtual environment in future sessions:"
    log_info "  source .venv/bin/activate"
fi
