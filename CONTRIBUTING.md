# Contributing to Setup Groovy Action

Thank you for your interest in contributing to the Setup Groovy Action! This document provides guidelines and information for contributors.

## Table of Contents

- [Code of Conduct](#code-of-conduct)
- [Getting Started](#getting-started)
- [Development Setup](#development-setup)
- [Making Changes](#making-changes)
- [Testing](#testing)
- [Submitting Changes](#submitting-changes)
- [Release Process](#release-process)

## Code of Conduct

This project adheres to a code of conduct that promotes a welcoming and inclusive environment. Please be respectful and professional in all interactions.

## Getting Started

### Prerequisites

- Git
- Basic understanding of GitHub Actions
- Access to Linux, macOS, or Windows for testing (or GitHub Actions runners)
- Familiarity with Groovy (helpful but not required)

### Development Setup

1. **Fork and Clone**
   ```bash
   git clone https://github.com/your-username/setup-groovy-action.git
   cd setup-groovy-action
   ```

2. **Setup Development Environment**
   ```bash
   # Run the portable development setup script
   ./dev-setup.sh
   ```
   This creates a clean, portable virtual environment for testing.

3. **Create a Branch**
   ```bash
   git checkout -b feature/your-feature-name
   # or
   git checkout -b fix/your-bug-fix
   ```

## Making Changes

### Code Style

- Use consistent shell script formatting
- Add comments for complex logic
- Follow YAML best practices for GitHub Actions
- Ensure cross-platform compatibility

### Action Development

- **action.yml**: Main action definition
  - Update inputs/outputs as needed
  - Maintain backward compatibility when possible
  - Add appropriate descriptions

- **Cross-platform support**: Test on all supported platforms
  - Linux (Ubuntu)
  - macOS
  - Windows

### Documentation

- Update `README.md` for user-facing changes
- Update `CHANGELOG.md` following Keep a Changelog format
- Add inline comments for complex logic
- Update examples if API changes

## Testing

### Local Testing

Run the comprehensive test suite:

```bash
# Make scripts executable
chmod +x tests/run-all-tests.sh
chmod +x tests/test-action.sh
chmod +x tests/test-integration.sh

# Run all tests
./tests/run-all-tests.sh

# Run specific test types
./tests/test-action.sh          # Unit tests
./tests/test-integration.sh     # Integration tests
```

### GitHub Actions Testing

The repository includes comprehensive CI/CD workflows:

- **Basic tests**: Run on every push/PR
- **Extended tests**: Run on manual trigger
- **Cross-platform tests**: Verify functionality on all supported OS

Test your changes by:

1. Pushing to your fork
2. Creating a pull request
3. Monitoring the automated test results

### Test Categories

1. **Unit Tests** (`tests/test-action.sh`)
   - YAML syntax validation
   - Metadata verification
   - Security checks
   - Documentation validation

2. **Integration Tests** (`tests/test-integration.sh`)
   - Docker-based testing
   - Cross-platform installation
   - Version-specific testing

3. **End-to-End Tests** (GitHub Actions workflow)
   - Real action execution
   - Complex Groovy scripts
   - Multi-platform scenarios

## Submitting Changes

### Pull Request Process

1. **Ensure Tests Pass**
   ```bash
   ./tests/run-all-tests.sh
   ```

2. **Update Documentation**
   - README.md (if user-facing changes)
   - CHANGELOG.md (add entry for your changes)
   - Code comments (if adding complex logic)

3. **Create Pull Request**
   - Use descriptive title
   - Reference any related issues
   - Describe changes and rationale
   - Include testing details

4. **PR Template**
   ```markdown
   ## Description
   Brief description of changes

   ## Type of Change
   - [ ] Bug fix
   - [ ] New feature
   - [ ] Breaking change
   - [ ] Documentation update

   ## Testing
   - [ ] Unit tests pass
   - [ ] Integration tests pass
   - [ ] Manual testing completed

   ## Checklist
   - [ ] Code follows project style
   - [ ] Self-review completed
   - [ ] Documentation updated
   - [ ] CHANGELOG.md updated
   ```

### Review Process

1. Automated tests must pass
2. Code review by maintainers
3. Documentation review
4. Final approval and merge

## Release Process

### Version Numbering

We follow [Semantic Versioning](https://semver.org/):

- **MAJOR**: Breaking changes
- **MINOR**: New features (backward compatible)
- **PATCH**: Bug fixes (backward compatible)

### Release Steps

1. **Update Version**
   - Update `CHANGELOG.md`
   - Update version references in documentation

2. **Create Release**
   - Tag the release: `git tag v1.x.x`
   - Create GitHub release with release notes
   - Update major version tag (e.g., `v1`)

3. **Post-Release**
   - Verify marketplace listing
   - Update any example repositories
   - Announce in relevant channels

## Common Contribution Areas

### High-Impact Contributions

- **Cross-platform compatibility improvements**
- **Performance optimizations**
- **Error handling enhancements**
- **Documentation improvements**
- **Test coverage expansion**

### Feature Ideas

- Support for additional Groovy versions
- Custom SDKMAN mirror configuration
- Enhanced caching strategies
- Integration with other package managers
- Improved error reporting

### Bug Reports

When reporting bugs:

1. Use the issue template
2. Include:
   - Operating system
   - Groovy version (if applicable)
   - Action configuration
   - Error messages
   - Steps to reproduce

## Development Tips

### Testing Locally

```bash
# Test action metadata
yaml-lint action.yml

# Test shell scripts
shellcheck tests/*.sh

# Test specific scenarios
docker run --rm -v $(pwd):/workspace ubuntu:latest /workspace/tests/test-integration.sh
```

### Debugging

- Use `set -x` in shell scripts for detailed debugging
- Add temporary `echo` statements for troubleshooting
- Test with different Groovy versions
- Verify behavior on all supported platforms

## Getting Help

- **Documentation**: Start with README.md and TEST_GUIDE.md
- **Issues**: Search existing issues or create new ones
- **Discussions**: Use GitHub Discussions for questions
- **Examples**: Check the `tests/` directory for usage examples

## Recognition

Contributors will be acknowledged in:
- CHANGELOG.md
- GitHub releases
- README.md (for significant contributions)

Thank you for contributing to Setup Groovy Action!
