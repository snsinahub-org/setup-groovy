# Changelog

All notable changes to the Setup Groovy Action will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
- New `java-version` input parameter for configurable Java installation
- Support for Java versions 8, 11, 17, and 21 with smart package manager mapping
- Dynamic Homebrew prefix detection for complete portability across Intel/Apple Silicon Macs

### Fixed
- **SHELL COMPATIBILITY**: Removed `local` variable declarations from main script scope to fix "local: can only be used in a function" error on Linux and macOS runners
- Improved shell compatibility across different GitHub Actions runner environments

### Changed
- **BREAKING**: Default Java version changed from 11 to 17 (current LTS)
- Enhanced Java installation logic with version-specific package selection
- **PORTABILITY**: Replaced all hardcoded absolute paths with dynamic path detection
- Updated documentation to reflect Java 17 as the new default and portability improvements



## [1.0.0] - 2024-12-19

### Added
- Initial release of the Setup Groovy Action
- Cross-platform support for Linux, macOS, and Windows
- Automatic Groovy installation using SDKMAN (Linux/macOS) and Chocolatey (Windows)
- Support for specific Groovy version selection
- Configurable options:
  - `groovy-version`: Specify exact version or use latest
  - `skip-if-exists`: Skip installation if Groovy already available
  - `add-to-path`: Control PATH modification
- Action outputs:
  - `groovy-version`: Version of installed Groovy
  - `groovy-path`: Installation path
- Comprehensive test suite:
  - Cross-platform compatibility tests
  - Version-specific installation tests
  - Input validation and error handling tests
  - Complex Groovy script execution tests
  - Real-world usage simulation tests
- Complete documentation with usage examples
- GitHub Actions CI/CD workflow for automated testing

### Security
- Secure installation methods using official package managers
- Input validation for version specifications
- Error handling for malformed inputs

### Performance
- Intelligent caching to skip re-installation when possible
- Optimized installation scripts for each platform
- Minimal overhead when Groovy is already available

## [Unreleased]

### Planned
- Support for custom SDKMAN mirror configuration
- Advanced caching strategies for faster CI/CD execution
- Integration with additional package managers
- Enhanced error reporting and troubleshooting guidance

---

## Release Notes Template

### [X.Y.Z] - YYYY-MM-DD

#### Added
- New features

#### Changed
- Changes in existing functionality

#### Deprecated
- Soon-to-be removed features

#### Removed
- Now removed features

#### Fixed
- Bug fixes

#### Security
- Security improvements
