# 🚀 Quick Start for Contributors

Welcome! This repository contains a **portable, production-ready GitHub Actions composite action** for setting up Groovy. Here's everything you need to know to get started:

## ✅ Fresh Clone Setup (Automatic!)

After cloning this repository, setup is **completely automatic**:

```bash
# 1. Clone the repository
git clone <your-repo-url>
cd setup-groovy-action

# 2. Run the development setup (creates .venv automatically)
./dev-setup.sh

# 3. Run tests to verify everything works
./tests/run-all-tests.sh
```

**That's it!** No manual virtual environment setup needed. No hardcoded paths to worry about.

## 🎯 What the Setup Does

The `./dev-setup.sh` script automatically:

- ✅ **Creates a clean `.venv`** virtual environment (removed first if exists)
- ✅ **Installs all dependencies** from `requirements-dev.txt`
- ✅ **Makes test scripts executable**
- ✅ **Works on any system** - no hardcoded paths

## 🧪 Testing

Run the comprehensive test suite:

```bash
./tests/run-all-tests.sh    # Complete test suite
./tests/test-action.sh      # Unit tests only
./tests/test-integration.sh # Integration tests only
./tests/test-fresh-clone.sh # Fresh clone simulation
```

All tests should pass ✅

## 📁 Important Notes

- **`.venv` is NOT tracked by git** - it's in `.gitignore`
- **Each developer gets their own clean environment**
- **No manual virtual environment setup required**
- **Virtual environment files contain system-specific paths** (this is normal!)

## 🔧 Development Guidelines

1. **Always run `./dev-setup.sh` first** after cloning
2. **Run tests after making changes**
3. **Never commit `.venv` directory**
4. **Keep action portable** - no hardcoded paths in action files

## 🎉 Ready to Contribute!

The action is fully portable and production-ready. You can:

- Use it in any GitHub Actions workflow
- Modify it without breaking portability
- Contribute to improvements
- Publish it to GitHub Marketplace

Happy coding! 🚀
