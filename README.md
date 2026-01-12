# CD3 Automation Toolkit

Oracle Cloud Infrastructure deployment automation using Terraform and Excel templates.

## What is CD3?

CD3 (Cloud Deployment & Design) automates OCI infrastructure provisioning by:
- Converting Excel templates to Terraform code
- Exporting existing OCI resources to Excel
- Managing infrastructure as code

## Quick Setup

### Automated Installation (Linux/macOS)

```bash
./quick_install_cd3.sh
```

**Time:** 10-15 minutes

### Manual Installation

See [docs/SETUP.md](docs/SETUP.md) for detailed platform-specific instructions.

## Prerequisites

- Python 3.12 or 3.10
- Terraform 1.13+
- OCI account with API access
- 2GB free disk space

## Usage

```bash
# Activate environment
source cd3-automation-toolkit/cd3venv/bin/activate

# Run CD3
cd cd3-automation-toolkit/cd3_automation_toolkit
python setUpOCI.py
```

## Documentation

- **[Setup Guide](docs/SETUP.md)** - Complete installation and configuration
- **[Troubleshooting](docs/TROUBLESHOOTING.md)** - Common issues and solutions
- **[Archived Docs](docs/archive/)** - Detailed reference guides

## Quick Links

- **CD3 GitHub:** https://github.com/oracle-devrel/cd3-automation-toolkit
- **OCI Docs:** https://docs.oracle.com/en-us/iaas/
- **Terraform Provider:** https://registry.terraform.io/providers/oracle/oci/latest/docs

## Scripts

| Script | Purpose |
|--------|---------|
| `quick_install_cd3.sh` | Automated setup (Linux/macOS) |
| **`cd3_wsl_complete.sh`** | **Complete WSL helper - does everything!** ⭐ |
| `diagnose_cd3.sh` | Diagnose CD3 issues |
| `run_cd3.sh` | Helper to run CD3 correctly (macOS) |
| `verify_versions.sh` | Check installation |
| `fix_https_errors.sh` | Fix SSL issues |

## Troubleshooting

**ModuleNotFoundError: No module named 'ocicloud' (MOST COMMON!):**

This error happens even with packages installed if you're in wrong directory or venv not activated.

**Quick Solutions:**
- **WSL Users:** Use **[cd3_wsl_complete.sh](cd3_wsl_complete.sh)** - ONE script does everything! ⭐
- **Detailed Fix:** [FINAL_FIX.md](FINAL_FIX.md) - Complete explanation
- **Copy Commands:** [RUN_CD3_COMMANDS.txt](RUN_CD3_COMMANDS.txt) - Exact commands
- **Diagnose:** `bash diagnose_cd3.sh` - Shows what's wrong

**SSL/HTTPS Errors:**
```bash
./fix_https_errors.sh
```

**Verify Installation:**
```bash
./verify_versions.sh
```

**More Help:** See [docs/TROUBLESHOOTING.md](docs/TROUBLESHOOTING.md) for all common issues

## Support

- GitHub Issues: https://github.com/oracle-devrel/cd3-automation-toolkit/issues
- Documentation: See [docs/](docs/) folder
