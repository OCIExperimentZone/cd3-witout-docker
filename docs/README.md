# CD3 Documentation

## Getting Started

**[SETUP.md](SETUP.md)** - Complete installation and configuration guide for all platforms

This is the main document you need to get CD3 up and running.

## What's Inside

### SETUP.md
Complete guide covering:
- Automated installation (Linux/macOS)
- Manual installation (all platforms)
- OCI API key configuration
- CD3 properties setup
- Running CD3
- Troubleshooting
- Usage workflows

## Archived Documentation

The [archive/](archive/) folder contains older, more detailed documentation files. These have been consolidated into SETUP.md but are kept for reference:

- START_HERE.md
- QUICK_START.md
- SETUP_GUIDE_NO_DOCKER.md
- README_SETUP_SCRIPTS.md
- DOCUMENTATION_INDEX.md
- VERSION_INFO.md
- PYTHON312_COMPATIBILITY.md
- COMPATIBILITY_FIX_SUMMARY.md
- CHANGES_SUMMARY.md
- WSL_SETUP_GUIDE.md

## Quick Reference

**Install CD3:**
```bash
./quick_install_cd3.sh
```

**Run CD3:**
```bash
source cd3-automation-toolkit/cd3venv/bin/activate
cd cd3-automation-toolkit/cd3_automation_toolkit
python setUpOCI.py
```

**Fix SSL Issues:**
```bash
./fix_https_errors.sh
```

**Verify Installation:**
```bash
./verify_versions.sh
```

## Need Help?

1. Read [SETUP.md](SETUP.md) - troubleshooting section
2. Check [archive/](archive/) for detailed explanations
3. GitHub Issues: https://github.com/oracle-devrel/cd3-automation-toolkit/issues
