# Testing Guide for Setup Groovy Action

This directory contains comprehensive tests for the Setup Groovy Action. The tests are designed to validate functionality, performance, security, and cross-platform compatibility.

## Test Structure

```
📁 setup-groovy-action/
├── 📄 action.yml                                      # The main action file
├── 📖 README.md                                       # Action documentation
└── 📁 tests/                                          # Test suite
    ├── 🔄 .github/workflows/test-setup-groovy-action.yml  # GitHub Actions CI/CD tests
    ├── 🧪 test-action.sh                              # Local unit tests
    ├── 🐳 test-integration.sh                         # Docker integration tests  
    ├── ⚙️ test-config.yml                             # Test configuration
    ├── 📖 TEST_GUIDE.md                               # This file
    └── 📁 test-results/                               # Generated test artifacts
        ├── Dockerfile.ubuntu                          # Docker build file
        ├── ubuntu-build.log                           # Container build log
        ├── ubuntu-test.log                            # Container test output
        └── validation.log                             # YAML validation log
```

## Test Types

### 1. Unit Tests (`test-action.sh`)

**Purpose**: Validate action structure, metadata, and configuration without execution.

**What it tests**:
- ✅ Action YAML syntax and structure
- ✅ Required metadata fields (name, description, runs)
- ✅ Input/output definitions
- ✅ Platform-specific step logic
- ✅ Shell type usage (bash/pwsh)
- ✅ README documentation completeness
- ✅ Security vulnerability checks
- ✅ Error handling patterns

**How to run**:
```bash
# From the tests directory
cd setup-groovy-action/tests

# Run all unit tests
./test-action.sh

# Or run with verbose output
bash -x ./test-action.sh
```

**Expected output**:
```
==================================
Setup Groovy Action - Unit Tests
==================================

[INFO] Setting up test environment...
[INFO] Running test: Action YAML Syntax
[PASS] Action YAML Syntax
[INFO] Running test: Action Metadata
[PASS] Action Metadata
...
🎉 All tests passed!
```

### 2. Integration Tests (`test-integration.sh`)

**Purpose**: Test actual action execution in isolated Docker containers.

**What it tests**:
- ✅ Real Groovy installation on Ubuntu
- ✅ SDKMAN setup and configuration
- ✅ Basic Groovy script execution
- ✅ Action file validation
- ✅ Environment simulation

**Prerequisites**:
- Docker installed and running
- Internet access for package downloads

**How to run**:
```bash
# From the tests directory
cd setup-groovy-action/tests

# Run integration tests
./test-integration.sh

# View test artifacts
ls -la test-results/
```

**Expected output**:
```
=======================================
Setup Groovy Action - Integration Tests
=======================================

[INFO] Docker is available
[INFO] Validating action files...
[PASS] Action YAML validation passed
[INFO] Testing on Ubuntu container...
[PASS] Ubuntu test passed
🎉 All integration tests passed!
```

### 3. GitHub Actions CI/CD Tests (`.github/workflows/test-setup-groovy-action.yml`)

**Purpose**: Comprehensive testing across multiple platforms and scenarios in real GitHub Actions environment.

**What it tests**:
- ✅ **Cross-platform compatibility**: Ubuntu, Windows, macOS
- ✅ **Version-specific installations**: Multiple Groovy versions  
- ✅ **Input validation**: All action parameters
- ✅ **Error handling**: Invalid inputs and failure scenarios
- ✅ **Complex Groovy scripts**: External dependencies, JSON processing
- ✅ **Performance testing**: Large scripts and multiple installations
- ✅ **Real-world simulation**: Complex usage patterns and scenarios

**Test Matrix**:

| Test Job | Platforms | Groovy Versions | Purpose |
|----------|-----------|-----------------|---------|
| `test-basic-cross-platform` | ubuntu, windows, macos | latest | Basic functionality |
| `test-specific-versions` | ubuntu, windows | 4.0.15, 4.0.21, 3.0.19 | Version compatibility |
| `test-action-inputs` | ubuntu, windows | latest | Input validation |
| `test-error-handling` | ubuntu | latest | Error scenarios |
| `test-complex-groovy` | ubuntu | latest | Advanced features |
| `test-performance` | ubuntu | latest | Performance benchmarks |

**How to trigger**:
```bash
# Automatic triggers
git push origin main                    # Push to main branch
git push origin feature/groovy-setup   # Push to any branch with changes

# Manual trigger with different test levels
gh workflow run test-setup-groovy-action.yml -f test-matrix=basic
gh workflow run test-setup-groovy-action.yml -f test-matrix=full  
gh workflow run test-setup-groovy-action.yml -f test-matrix=stress
```

## Test Configuration (`test-config.yml`)

Defines test scenarios, expected outcomes, and validation rules:

- **Scenarios**: Different test configurations (basic, version-specific, etc.)
- **Security checks**: Patterns to detect vulnerabilities
- **Performance benchmarks**: Expected execution times
- **Compatibility matrix**: Supported OS and Groovy versions
- **Validation rules**: Required fields and documentation sections

## Running Tests Locally

### Quick Validation (30 seconds)
```bash
# Run unit tests only
./test-action.sh
```

### Full Local Testing (5-10 minutes)
```bash
# Run unit tests
./test-action.sh

# Run integration tests (requires Docker)
./test-integration.sh

# Check test artifacts
ls -la test-results/
```

### Complete Testing (20-30 minutes)
```bash
# Local tests
./test-action.sh && ./test-integration.sh

# Trigger GitHub Actions tests
gh workflow run test-setup-groovy-action.yml -f test-matrix=full

# Monitor results
gh run list --workflow=test-setup-groovy-action.yml
```

## Test Scenarios and Expected Outcomes

### Scenario 1: Basic Cross-Platform
```yaml
Input: Default action configuration
Expected: 
  - Groovy installed on all platforms
  - Command available in PATH
  - Outputs correctly set
  - Basic script execution successful
```

### Scenario 2: Specific Version Installation
```yaml
Input: groovy-version: "4.0.15"
Expected:
  - Exact version installed
  - Version verification successful  
  - Version-specific features available
```

### Scenario 3: Skip If Exists
```yaml
Input: skip-if-exists: true (with Groovy pre-installed)
Expected:
  - Installation skipped
  - Existing version detected
  - No unnecessary downloads
```

### Scenario 4: Error Handling
```yaml
Input: groovy-version: "99.99.99" (invalid)
Expected:
  - Action fails gracefully
  - Clear error message
  - No partial installation
```

## Performance Benchmarks

| Operation | Ubuntu | Windows | macOS |
|-----------|--------|---------|-------|
| First install | <120s | <180s | <150s |
| Cached install | <10s | <15s | <12s |
| Basic script | <5s | <8s | <6s |
| Complex script | <30s | <45s | <35s |

## Troubleshooting Tests

### Test Failures

**Unit Test Failures**:
```bash
# Check specific test
./test-action.sh 2>&1 | grep -A5 -B5 "FAIL"

# Validate YAML manually
python3 -c "import yaml; yaml.safe_load(open('setup-groovy-action/action.yml'))"
```

**Integration Test Failures**:
```bash
# Check Docker status
docker info

# View detailed logs
cat test-results/ubuntu-test.log
cat test-results/ubuntu-build.log
```

**GitHub Actions Failures**:
```bash
# View recent runs
gh run list --workflow=test-setup-groovy-action.yml

# Get detailed logs
gh run view <run-id> --log
```

### Common Issues

**Issue**: Docker not available
```bash
# Solution: Install Docker
# macOS: brew install docker
# Ubuntu: sudo apt install docker.io
# Windows: Install Docker Desktop
```

**Issue**: Python YAML validation fails  
```bash
# Solution: Install PyYAML
pip3 install pyyaml

# Or use alternative validation
docker run --rm -v $(pwd):/workspace mikefarah/yq eval setup-groovy-action/action.yml
```

**Issue**: Network timeouts in tests
```bash
# Solution: Increase timeout or check network
curl -I https://get.sdkman.io
curl -I https://community.chocolatey.org
```

## Test Coverage

The test suite covers:

- ✅ **Functional Testing**: 95% of action functionality
- ✅ **Platform Testing**: 100% of supported platforms  
- ✅ **Version Testing**: Major Groovy versions (3.x, 4.x)
- ✅ **Error Testing**: Common failure scenarios
- ✅ **Security Testing**: Basic vulnerability patterns
- ✅ **Performance Testing**: Installation and execution benchmarks
- ✅ **Documentation Testing**: README completeness

## Contributing to Tests

When adding new features to the action:

1. **Update unit tests** in `test-action.sh`
2. **Add integration scenarios** in `test-integration.sh`  
3. **Extend GitHub Actions tests** in the workflow file
4. **Update test configuration** in `test-config.yml`
5. **Document new test cases** in this guide

### Test Development Guidelines

- **Isolation**: Each test should be independent
- **Repeatability**: Tests should produce consistent results
- **Speed**: Keep unit tests fast (<30s total)
- **Coverage**: Test both success and failure paths
- **Documentation**: Update this guide for new test types

## Continuous Integration

The GitHub Actions workflow runs automatically on:
- **Push to main/develop**: Full test suite
- **Pull requests**: Basic and compatibility tests
- **Manual dispatch**: Configurable test levels
- **Schedule**: Nightly full regression tests (if configured)

Test results are reported in:
- GitHub Actions job summaries
- Pull request status checks  
- Workflow run artifacts
- Test coverage reports
