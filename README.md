# Setup Groovy Action

A GitHub Actions composite action that installs and configures Groovy runtime using SDKMAN. This action provides cross-platform Groovy setup with automatic dependency management for any workflow requiring Groovy script execution.

## Version Tags

When using this action, you can specify different version tags:

- `snsinahub-org/setup-groovy@v1` - Latest stable v1.x release (recommended)
- `snsinahub-org/setup-groovy@v1.0.0` - Specific version for reproducible builds
- `snsinahub-org/setup-groovy@main` - Latest development version (not recommended for production)

## Quick Start

```yaml
name: Test Groovy Script
on: [push]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: snsinahub-org/setup-groovy@v1
      - name: Run Groovy Script
        run: |
          echo 'println "Hello from Groovy!"' > test.groovy
          groovy test.groovy
```

## Features

- 🚀 **Fast Installation**: Uses SDKMAN for reliable Groovy installation on Linux/macOS, Chocolatey on Windows
- 🔄 **Version Control**: Support for specific Groovy versions or latest stable
- ⚡ **Smart Caching**: Skip installation if Groovy is already available
- 🛣️ **PATH Integration**: Automatically adds Groovy to PATH for subsequent steps
- 📤 **Outputs**: Provides version and path information for downstream usage
- 🔧 **Fully Automated**: Zero manual intervention required - handles all dependencies automatically
- 🌐 **Cross-Platform**: Works on Ubuntu, macOS, and Windows without platform-specific configuration
- 🛡️ **Robust Error Handling**: Comprehensive error messages and fallback mechanisms
- 🔁 **Retry Logic**: Built-in retry mechanisms for network-dependent operations

## Automation Highlights

This action is designed to be **completely self-contained** and **production-ready** with no manual setup required:

### 🔧 **Automatic Dependency Management**
- **Java Runtime**: Auto-detects and installs OpenJDK 17 (default) if not present, configurable for other versions
- **Package Managers**: Auto-installs SDKMAN (Linux/macOS) or Chocolatey (Windows)
- **System Tools**: Auto-installs curl, unzip, zip on Linux/macOS as needed
- **PowerShell Policy**: Automatically configures execution policy on Windows
- **Dynamic Path Detection**: Automatically detects Homebrew prefix and system paths (portable across Intel/Apple Silicon)

### 🛡️ **Robust Error Handling**  
- **Network Resilience**: Retry logic for downloads and installations
- **Fallback Mechanisms**: Multiple installation strategies for different scenarios
- **Detailed Diagnostics**: Clear error messages with actionable troubleshooting steps
- **Permission Management**: Automatic handling of file permissions and access rights

### 🌍 **Universal Compatibility**
- **Linux Distributions**: Ubuntu, CentOS, RHEL, Fedora, Arch Linux (via multiple package managers)
- **macOS**: Intel and Apple Silicon support with Homebrew integration
- **Windows**: PowerShell Core compatibility with Chocolatey integration
- **GitHub Runners**: Optimized for all GitHub Actions runner types including self-hosted

## Usage

### Basic Usage

```yaml
steps:
  - name: Setup Groovy
    uses: snsinahub-org/setup-groovy@v1
```

### With Specific Version

```yaml
steps:
  - name: Setup Groovy
    uses: snsinahub-org/setup-groovy@v1
    with:
      groovy-version: '4.0.15'
```

### Advanced Configuration

```yaml
steps:
  - name: Setup Groovy
    uses: snsinahub-org/setup-groovy@v1
    with:
      groovy-version: '4.0.15'
      java-version: '21'        # Use Java 21 instead of default 17
      skip-if-exists: 'false'
      add-to-path: 'true'
```

## Inputs

| Input | Description | Required | Default |
|-------|-------------|----------|---------|
| `groovy-version` | Version of Groovy to install (e.g., '4.0.15') | No | `''` (latest) |
| `java-version` | Version of Java to install if not present (e.g., '17', '11', '21') | No | `'17'` |
| `skip-if-exists` | Skip installation if Groovy is already available | No | `'true'` |
| `add-to-path` | Add Groovy to PATH for subsequent steps | No | `'true'` |

## Outputs

| Output | Description |
|--------|-------------|
| `groovy-version` | The version of Groovy that was installed |
| `groovy-path` | Path to the Groovy installation directory |

### Cross-Platform Example

```yaml
name: Cross-Platform Groovy Testing
on: [push]

jobs:
  test-groovy:
    strategy:
      matrix:
        os: [ubuntu-latest, windows-latest, macos-latest]
    runs-on: ${{ matrix.os }}
    
    steps:
      - name: Checkout
        uses: actions/checkout@v4

      - name: Setup Groovy
        uses: snsinahub-org/setup-groovy@v1
        with:
          groovy-version: '4.0.15'

      - name: Test Groovy Installation
        shell: bash
        run: |
          groovy --version
          echo 'println "Hello from Groovy on ${{ matrix.os }}!"' > test.groovy
          groovy test.groovy

      - name: Platform-Specific Groovy Script
        shell: bash
        run: |
          cat > platform-test.groovy <<'EOF'
          def os = System.getProperty('os.name')
          def arch = System.getProperty('os.arch')
          def javaVersion = System.getProperty('java.version')
          
          println "Running on: ${os}"
          println "Architecture: ${arch}"
          println "Java Version: ${javaVersion}"
          println "Groovy Version: ${GroovySystem.version}"
          EOF
          
          groovy platform-test.groovy
```

## Platform Support

| Platform | Supported | Installation Method | Notes |
|----------|-----------|-------------------|-------|
| Ubuntu | ✅ | SDKMAN | Fully tested and recommended |
| Linux | ✅ | SDKMAN | All major distributions supported |
| macOS | ✅ | SDKMAN | Requires Xcode Command Line Tools |
| Windows | ✅ | Chocolatey + Direct Download | Uses PowerShell for installation |

### Platform-Specific Details

**Linux/Ubuntu:**
- Uses SDKMAN for installation (industry standard)
- Requires `curl` and `bash`
- Automatic Java dependency resolution

**macOS:**
- Uses SDKMAN (same as Linux)
- May require Xcode Command Line Tools: `xcode-select --install`
- Supports both Intel and Apple Silicon

**Windows:**
- Uses Chocolatey package manager for latest versions
- Direct download for specific versions
- Automatically installs OpenJDK if needed
- Uses PowerShell for installation scripts

## Requirements

### All Platforms
- **Java Runtime**: Groovy requires Java (JDK 8 or higher)
  - Auto-installed (OpenJDK 17 by default, configurable) if not present
  - All platforms supported via appropriate package managers
  - Can also use `actions/setup-java` for specific Java configurations

### Platform-Specific Requirements

**Linux/Ubuntu:**
- `curl` (for SDKMAN installation)
- `bash` shell environment

**macOS:**
- `curl` (pre-installed)
- Xcode Command Line Tools (usually available)

**Windows:**
- PowerShell 5.1+ (pre-installed on GitHub Actions)
- Internet access for Chocolatey and package downloads

## Troubleshooting

### Automated Issue Resolution

**This action automatically handles common setup issues without manual intervention:**

✅ **Java Installation**: Automatically detects and installs OpenJDK 11 if Java is not available
✅ **SDKMAN Installation**: Auto-installs SDKMAN on Linux/macOS with proper permissions  
✅ **Chocolatey Installation**: Auto-installs Chocolatey package manager on Windows
✅ **PowerShell Policy**: Automatically sets execution policy on Windows
✅ **System Dependencies**: Auto-installs curl, unzip, and zip on Linux/macOS
✅ **PATH Management**: Automatically adds Groovy to PATH for subsequent steps
✅ **Permission Handling**: Sets proper file permissions for SDKMAN directory
✅ **Network Issues**: Includes retry logic and fallback mechanisms

### Manual Troubleshooting (Rare Cases)

**Issue**: "Network connectivity problems"
```yaml
# Solution: Ensure runner has internet access for package downloads
# For self-hosted runners, check firewall and proxy settings
```

**Issue**: "Specific Groovy version not available"
```yaml
# Solution: Check available versions and use a supported one
- name: Setup Groovy
  uses: snsinahub-org/setup-groovy@v1
  with:
    groovy-version: '4.0.15'  # Use a known stable version
```

**Issue**: "Disk space issues" (Self-hosted runners)
```yaml
# Solution: Clean up before running the action
- name: Clean workspace
  run: |
    df -h  # Check disk space
    # Clean up if needed
```

**Issue**: "Corporate proxy/firewall restrictions"
```yaml
# Solution: Configure proxy settings for package managers
- name: Configure proxy (if needed)
  run: |
    # Configure proxy for your environment
    export HTTP_PROXY=http://proxy.company.com:8080
    export HTTPS_PROXY=http://proxy.company.com:8080
```

### Platform-Specific Notes

**Windows Runners:**
- The action uses PowerShell Core (`pwsh`) for better cross-platform compatibility
- Chocolatey is installed automatically if not present
- OpenJDK is installed automatically if Java is not available

**Self-Hosted Runners:**
- Ensure the runner has internet access for package downloads
- For air-gapped environments, consider pre-installing Groovy
- Windows self-hosted runners may need Chocolatey pre-installed

## Contributing

When contributing to this action:

1. **Clone and Setup**: Clone the repository and run `./dev-setup.sh` for a portable development environment
2. **Test across platforms**: Verify compatibility on ubuntu-latest, macos-latest, windows-latest
3. **Version compatibility**: Test with various Groovy versions
4. **Documentation**: Update documentation for any new inputs/outputs
5. **Run tests**: Execute the full test suite with `./tests/run-all-tests.sh`

### Development Setup

```bash
# Clone the repository
git clone https://github.com/snsinahub-org/setup-groovy.git
cd setup-groovy

# Run the portable development setup
./dev-setup.sh

# Run tests
./tests/run-all-tests.sh
```

The development setup creates a portable virtual environment that works regardless of your system path.

**🎯 Portability**: This action contains no hardcoded paths and works on any system. The `.venv` directory is excluded from the repository to ensure complete portability across different environments.

**Note**: The `.venv` directory is not committed to the repository (it's in `.gitignore`). Each developer should run `./dev-setup.sh` to create their own local development environment.

## Publishing

To publish this action to the GitHub Marketplace:

1. Create a new repository `snsinahub-org/setup-groovy`
2. Copy all files from `setup-groovy-action/` to the repository root
3. Move `tests/.github/workflows/test-setup-groovy-action.yml` to `.github/workflows/`
4. Create and push a version tag: `git tag v1.0.0 && git push origin v1.0.0`
5. Create a GitHub release from the tag
6. The action will be available as `snsinahub-org/setup-groovy@v1`

## License

This action is provided under the MIT License.
