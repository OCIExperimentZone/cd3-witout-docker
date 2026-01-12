# CD3 Automation Toolkit

> **Oracle Cloud Infrastructure (OCI) deployment automation using Terraform and Excel templates**

Transform Excel spreadsheets into production-ready Terraform infrastructure code, or export your existing OCI environment to Excel for documentation and migration.

---

## 🎯 Choose Your Path

### 👨‍💼 Senior Infrastructure/DevOps Professional (10+ years experience)

**You want**: Architecture overview, quick reference, extension guides

→ **Start here**: [ARCHITECTURE.md](ARCHITECTURE.md) - System design and technical decisions  
→ **Commands**: [docs/QUICK_REFERENCE.md](docs/QUICK_REFERENCE.md) - Cheat sheet for daily operations  
→ **Extend CD3**: [CONTRIBUTING.md](CONTRIBUTING.md) - Add new resource types and customize

**Quick Install**:
```bash
./quick_install_cd3.sh && ./run_cd3.sh
```

---

### 🎓 New to Infrastructure Automation or OCI

**You want**: Step-by-step guidance, learning resources, friendly explanations

→ **Start here**: [GETTING_STARTED.md](GETTING_STARTED.md) - Complete beginner's guide  
→ **Setup Help**: [docs/SETUP.md](docs/SETUP.md) - Detailed installation for all platforms  
→ **When stuck**: [docs/TROUBLESHOOTING.md](docs/TROUBLESHOOTING.md) - Solutions to common problems

**Quick Install**:
```bash
./quick_install_cd3.sh
# Follow the prompts - takes 10-15 minutes
```

---

### 🔧 Just Want to Get It Working Now

**Quick Solutions for Common Issues:**

| Problem | Solution | Time |
|---------|----------|------|
| **ModuleNotFoundError: 'ocicloud'** | Use helper script: `./run_cd3.sh` or `./cd3_wsl_complete.sh` | 1 min |
| **SSL/HTTPS Errors** | Run: `./fix_https_errors.sh` | 2 min |
| **Need to diagnose issues** | Run: `./diagnose_cd3.sh` | 1 min |
| **Fresh installation** | Run: `./quick_install_cd3.sh` | 15 min |

**See**: [FINAL_FIX.md](FINAL_FIX.md) for detailed error explanations

---

## What is CD3?

**CD3 (Cloud Deployment & Design)** automates OCI infrastructure provisioning:

- 📊 **Excel → Terraform**: Convert spreadsheets to infrastructure code
- 📤 **OCI → Excel**: Export existing infrastructure for documentation
- 🔄 **Bi-directional**: Design in Excel, deploy with Terraform
- 🚀 **Bulk Operations**: Create hundreds of resources efficiently
- 👥 **Team Friendly**: Non-developers can participate in infrastructure design

### Use Cases

- **Greenfield Deployments**: Design entire environments in Excel, generate Terraform
- **Migration Projects**: Export on-premise or other cloud designs to OCI
- **Documentation**: Maintain infrastructure inventory in spreadsheet format
- **Compliance**: Standardize deployments using template patterns
- **Training**: Learn Terraform by seeing Excel-to-code transformations

---

## Prerequisites

- **Python**: 3.10 or 3.12 (3.13 not supported due to numpy compatibility)
- **Terraform**: 1.13 or higher
- **OCI Account**: With API access and permissions
- **Disk Space**: 2GB free
- **Platform**: Linux, macOS, Windows (via WSL), or Windows native

---

## Installation

### Automated (Recommended)

**Linux/macOS**:
```bash
git clone https://github.com/oracle-devrel/cd3-automation-toolkit.git
cd cd3-automation-toolkit
./quick_install_cd3.sh
```

**Windows (WSL)**:
```bash
git clone https://github.com/oracle-devrel/cd3-automation-toolkit.git
cd cd3-automation-toolkit
./cd3_wsl_complete.sh
```

### Manual Installation

See [docs/SETUP.md](docs/SETUP.md) for platform-specific instructions.

---

## Quick Start

### 1. Activate Environment

```bash
source cd3-automation-toolkit/cd3venv/bin/activate
cd cd3-automation-toolkit/cd3_automation_toolkit
```

**Or use helper script**:
```bash
./run_cd3.sh        # macOS/Linux
./run_cd3_wsl.sh    # WSL
```

### 2. Run CD3

```bash
python setUpOCI.py
```

### 3. Choose Workflow

```
1. Validate Excel Template
2. Create Terraform Files from Excel
3. Export OCI Resources to Excel
4. Exit
```

---

## Documentation Structure

### For Everyone
- **[README.md](README.md)** ← You are here - Overview and navigation
- **[docs/TROUBLESHOOTING.md](docs/TROUBLESHOOTING.md)** - Common issues and solutions

### By Experience Level
- **Beginners**: [GETTING_STARTED.md](GETTING_STARTED.md) - Step-by-step tutorial
- **Intermediate**: [docs/SETUP.md](docs/SETUP.md) - Detailed installation and configuration
- **Advanced**: [ARCHITECTURE.md](ARCHITECTURE.md) - System design and internals
- **Developers**: [CONTRIBUTING.md](CONTRIBUTING.md) - Extend and customize CD3

### Quick Reference
- **[docs/QUICK_REFERENCE.md](docs/QUICK_REFERENCE.md)** - Command cheat sheet
- **[00_START_HERE.txt](00_START_HERE.txt)** - File navigation guide
- **[docs/archive/](docs/archive/)** - Archived detailed guides

---

## Helper Scripts

| Script | Purpose | When to Use |
|--------|---------|-------------|
| `quick_install_cd3.sh` | One-command installation | First-time setup (Linux/macOS) |
| `cd3_wsl_complete.sh` | Complete WSL setup helper ⭐ | First-time setup (Windows WSL) |
| `run_cd3.sh` | Auto-activate and run CD3 | Daily use (macOS/Linux) |
| `run_cd3_wsl.sh` | Auto-activate and run CD3 | Daily use (WSL) |
| `diagnose_cd3.sh` | Diagnose configuration issues | Troubleshooting |
| `verify_versions.sh` | Check installed versions | Post-installation validation |
| `fix_https_errors.sh` | Fix SSL certificate problems | SSL/HTTPS errors |

---

## Example Workflows

### Create New Infrastructure

1. Download Excel template:
   ```bash
   wget https://github.com/oracle-devrel/cd3-automation-toolkit/releases/latest/download/CD3-Blank-Template.xlsx
   ```

2. Fill template with desired resources (VCNs, Instances, etc.)

3. Generate Terraform:
   ```bash
   python setUpOCI.py
   # Select option 2: "Create Terraform Files"
   ```

4. Deploy:
   ```bash
   cd output
   terraform init
   terraform plan
   terraform apply
   ```

### Document Existing Infrastructure

1. Run CD3:
   ```bash
   python setUpOCI.py
   # Select option 3: "Export OCI Resources"
   ```

2. Select compartments to export

3. Review generated Excel file with current infrastructure state

---

## Common Issues & Quick Fixes

### ❌ ModuleNotFoundError: No module named 'ocicloud'

**Cause**: Wrong directory or virtual environment not activated

**Solution**:
```bash
# Use helper script (easiest)
./run_cd3.sh          # macOS/Linux
./run_cd3_wsl.sh      # WSL

# OR manually
cd cd3-automation-toolkit/cd3_automation_toolkit
source ../cd3venv/bin/activate
python setUpOCI.py
```

**Detailed explanation**: [FINAL_FIX.md](FINAL_FIX.md)

### ❌ SSL/HTTPS Certificate Errors

```bash
./fix_https_errors.sh
```

### ❌ OCI Authentication Failed

```bash
# Verify configuration
cat ~/.oci/config

# Test connection
oci iam region list

# Reconfigure if needed
oci setup config
```

### 🔍 Not sure what's wrong?

```bash
./diagnose_cd3.sh
```

**More solutions**: [docs/TROUBLESHOOTING.md](docs/TROUBLESHOOTING.md)

---

## Learning Resources

### Videos & Tutorials
- **CD3 Overview**: https://github.com/oracle-devrel/cd3-automation-toolkit#readme
- **OCI Terraform Provider**: https://registry.terraform.io/providers/oracle/oci/latest/docs

### Reference Documentation
- **OCI Documentation**: https://docs.oracle.com/en-us/iaas/
- **Terraform Docs**: https://www.terraform.io/docs

### Community
- **GitHub Issues**: https://github.com/oracle-devrel/cd3-automation-toolkit/issues
- **GitHub Discussions**: Share experiences and ask questions

---

## Contributing

Interested in extending CD3 or adding new resource types?

See [CONTRIBUTING.md](CONTRIBUTING.md) for:
- Development setup
- Adding new OCI resources
- Code style guidelines
- Submitting pull requests

---

## License

Universal Permissive License v1.0

See the [official CD3 repository](https://github.com/oracle-devrel/cd3-automation-toolkit) for license details.

---

## Acknowledgments

This is a community-maintained fork focusing on non-Docker deployment.

**Official CD3 Repository**: https://github.com/oracle-devrel/cd3-automation-toolkit

---

**Need Help?** Choose your path at the top of this README based on your experience level!

**Document Version**: 2.0  
**Last Updated**: 2026-01-12
