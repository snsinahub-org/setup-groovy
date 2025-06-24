#!/bin/bash

# SDKMAN Installation Debug Script
# This script helps debug SDKMAN installation issues on Linux and macOS

set -e

echo "============================================"
echo "SDKMAN Installation Debug Test"
echo "============================================"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
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

# Test environment info
log_info "Environment Information:"
echo "  OS: $(uname -s)"
echo "  Architecture: $(uname -m)"
echo "  Home: $HOME"
echo "  Shell: $SHELL"
echo "  User: $(whoami)"

# Check prerequisites
log_info "Checking prerequisites..."
if command -v curl &> /dev/null; then
    log_success "curl is available: $(curl --version | head -1)"
else
    log_error "curl is not available"
    exit 1
fi

if command -v bash &> /dev/null; then
    log_success "bash is available: $(bash --version | head -1)"
else
    log_error "bash is not available"
    exit 1
fi

# Clean slate test
log_info "Cleaning any existing SDKMAN installation..."
rm -rf "$HOME/.sdkman" 2>/dev/null || true

# Test SDKMAN installation
log_info "Testing SDKMAN installation..."

# Download the installer and check what it does
log_info "Downloading SDKMAN installer..."
curl -s "https://get.sdkman.io" > /tmp/sdkman_installer.sh

if [ ! -s /tmp/sdkman_installer.sh ]; then
    log_error "Failed to download SDKMAN installer"
    exit 1
fi

log_info "SDKMAN installer downloaded successfully ($(wc -l < /tmp/sdkman_installer.sh) lines)"

# Run the installer
log_info "Running SDKMAN installer..."
if bash /tmp/sdkman_installer.sh; then
    log_success "SDKMAN installer completed"
else
    log_error "SDKMAN installer failed"
    exit 1
fi

# Check what was installed
log_info "Checking SDKMAN installation..."
if [ -d "$HOME/.sdkman" ]; then
    log_success "SDKMAN directory created: $HOME/.sdkman"
    
    log_info "Directory structure:"
    find "$HOME/.sdkman" -type f -name "*.sh" | head -10
    
    log_info "Looking for initialization scripts:"
    find "$HOME/.sdkman" -name "*init*" -type f
    
    log_info "Looking for sdk executables:"
    find "$HOME/.sdkman" -name "sdk*" -type f
    
    # Try different possible locations for the init script
    POSSIBLE_INIT_SCRIPTS=(
        "$HOME/.sdkman/bin/sdkman-init.sh"
        "$HOME/.sdkman/sdkman-init.sh"
        "$HOME/.sdkman/etc/sdkman-init.sh"
    )
    
    FOUND_INIT=""
    for script in "${POSSIBLE_INIT_SCRIPTS[@]}"; do
        if [ -f "$script" ]; then
            log_success "Found init script: $script"
            FOUND_INIT="$script"
            break
        else
            log_info "Not found: $script"
        fi
    done
    
    if [ -n "$FOUND_INIT" ]; then
        log_info "Testing SDKMAN initialization..."
        if source "$FOUND_INIT"; then
            log_success "SDKMAN sourced successfully"
            
            if command -v sdk &> /dev/null; then
                log_success "SDK command is available"
                sdk version
            else
                log_warning "SDK command not available after sourcing"
            fi
        else
            log_error "Failed to source SDKMAN init script"
        fi
    else
        log_error "No SDKMAN init script found"
        log_info "Complete directory listing:"
        find "$HOME/.sdkman" -type f | head -20
    fi
else
    log_error "SDKMAN directory not created"
fi

# Cleanup
rm -f /tmp/sdkman_installer.sh

echo
log_info "SDKMAN debug test completed"
