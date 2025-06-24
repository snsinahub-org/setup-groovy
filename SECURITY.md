# Security Policy

## Supported Versions

We support the following versions of the Setup Groovy Action:

| Version | Supported          |
| ------- | ------------------ |
| 1.x.x   | :white_check_mark: |
| 0.x.x   | :x:                |

## Reporting a Vulnerability

We take security seriously. If you discover a security vulnerability in this action, please follow these steps:

### For Critical Security Issues

1. **Do NOT** create a public GitHub issue
2. Email the maintainers directly (if available) or use GitHub's security advisory feature
3. Include as much detail as possible:
   - Description of the vulnerability
   - Steps to reproduce
   - Potential impact
   - Suggested fix (if known)

### For Non-Critical Issues

1. Create a GitHub issue with the `security` label
2. Provide detailed information about the issue
3. We will respond within 48 hours

## Security Features

This action includes several security measures:

- **Checksum Verification**: Downloads are verified when possible
- **Minimal Permissions**: Runs with least privilege necessary
- **No Credential Storage**: Does not store or persist any credentials
- **Sandboxed Execution**: All installations are isolated to the workflow run
- **Dependency Pinning**: Uses specific versions of dependencies when possible

## Security Best Practices

When using this action:

1. **Pin to Specific Versions**: Use `@v1.0.0` instead of `@main` for production
2. **Review Dependencies**: Check what versions of Java/Groovy are being installed
3. **Limit Scope**: Only use necessary inputs and outputs
4. **Monitor Updates**: Subscribe to releases to stay informed of security updates

## Vulnerability Disclosure Timeline

- **Day 0**: Vulnerability reported
- **Day 1**: Acknowledgment sent to reporter
- **Day 7**: Initial assessment completed
- **Day 14**: Fix developed and tested
- **Day 21**: Security update released
- **Day 28**: Public disclosure (if applicable)

We appreciate your help in keeping this action secure!
