# CD3 Automation Toolkit - Local Setup

This directory contains a Python script to install and configure the CD3 (Cloud Deployment & Design) Automation Toolkit locally on your laptop without Docker.

## What is CD3 Toolkit?

CD3 is Oracle's Cloud Deployment & Design tool that helps automate Oracle Cloud Infrastructure (OCI) resource provisioning using Terraform. It generates Terraform configurations from Excel templates.

## Prerequisites

- **Python 3.6+** (Python 3.8+ recommended)
- **Internet connection** for downloading dependencies
- **Admin/sudo access** (for installing system packages)
- **OCI Account** with appropriate permissions

## Quick Start

### 1. Run the Setup Script

```bash
cd /Users/pragadeeswarpa/Desktop/Personal_DevOps/CD3
python3 setup_cd3_toolkit.py
```

### 2. What the Script Does

The script automatically:
- ✅ Detects your operating system (macOS, Linux, or Windows)
- ✅ Installs Git (if not present)
- ✅ Installs Python dependencies (OCI SDK, OCI CLI, Jinja2, Pandas, etc.)
- ✅ Installs Terraform
- ✅ Installs OCI CLI
- ✅ Clones CD3 toolkit from GitHub
- ✅ Sets up the CD3 environment
- ✅ Verifies all installations

## OS-Specific Instructions

### macOS
The script will automatically install Homebrew if needed, then use it to install required tools.

```bash
# Make the script executable (optional)
chmod +x setup_cd3_toolkit.py

# Run the script
python3 setup_cd3_toolkit.py
```

### Linux (Ubuntu/Debian)
```bash
# Ensure Python3 and pip are installed
sudo apt-get update
sudo apt-get install -y python3 python3-pip

# Run the script
python3 setup_cd3_toolkit.py
```

### Linux (RHEL/CentOS)
```bash
# Ensure Python3 and pip are installed
sudo yum install -y python3 python3-pip

# Run the script
python3 setup_cd3_toolkit.py
```

### Windows
For Windows, some tools may need manual installation:
- Install Python from: https://www.python.org/downloads/
- Install Git from: https://git-scm.com/download/win
- Install Terraform from: https://www.terraform.io/downloads

Then run:
```powershell
python setup_cd3_toolkit.py
```

## What Gets Installed

### System Tools
- **Git**: Version control system
- **Terraform**: Infrastructure as Code tool
- **OCI CLI**: Oracle Cloud Infrastructure command-line interface

### Python Packages
- `oci`: Oracle Cloud Infrastructure SDK
- `oci-cli`: OCI command-line tools
- `jinja2`: Template engine
- `pandas`: Data manipulation
- `openpyxl`: Excel file handling
- `PyYAML`: YAML parsing
- And other required dependencies

### CD3 Toolkit
- Cloned to: `~/cd3-automation-toolkit`
- Repository: https://github.com/oracle-devrel/cd3-automation-toolkit

## After Installation

### 1. Configure OCI CLI

You'll need to configure OCI CLI with your credentials:

```bash
oci setup config
```

You'll need:
- **Tenancy OCID**
- **User OCID**
- **Region**
- **API Key** (public/private key pair)

### 2. Navigate to CD3 Toolkit

```bash
cd ~/cd3-automation-toolkit
```

### 3. Download Excel Template

Download the CD3 Excel template from the GitHub repository and fill it with your infrastructure requirements.

### 4. Run CD3 Toolkit

```bash
python setUpOCI.py
```

## Troubleshooting

### Permission Errors
If you encounter permission errors during installation:
```bash
# For macOS/Linux
sudo python3 setup_cd3_toolkit.py
```

### Python Package Installation Issues
If pip installation fails:
```bash
# Upgrade pip first
python3 -m pip install --upgrade pip

# Try installing packages individually
python3 -m pip install oci oci-cli
```

### Terraform Installation Issues
If Terraform installation fails, install manually:
- macOS: `brew install terraform`
- Linux: Download from https://www.terraform.io/downloads
- Windows: Download from https://www.terraform.io/downloads

### OCI CLI Configuration
If OCI CLI setup fails:
```bash
# Manual configuration
oci setup config

# Verify configuration
oci iam region list
```

## Directory Structure

After setup, your structure will be:

```
~/cd3-automation-toolkit/
├── setUpOCI.py              # Main script
├── requirements.txt          # Python dependencies
├── cd3_automation_toolkit/   # Core toolkit code
├── user-scripts/            # Custom scripts
├── README.md                # Documentation
└── ...
```

## Verification

To verify everything is installed correctly:

```bash
# Check Git
git --version

# Check Python
python3 --version

# Check Terraform
terraform version

# Check OCI CLI
oci --version

# Check Python packages
python3 -m pip list | grep oci
```

## Resources

- **CD3 GitHub**: https://github.com/oracle-devrel/cd3-automation-toolkit
- **OCI Documentation**: https://docs.oracle.com/en-us/iaas/
- **Terraform OCI Provider**: https://registry.terraform.io/providers/oracle/oci/latest/docs

## Support

For issues specific to:
- **This setup script**: Check this README or review the script
- **CD3 Toolkit**: Visit the GitHub repository and check Issues
- **OCI**: Refer to Oracle Cloud documentation

## Notes

- The script installs CD3 toolkit in your home directory (`~/cd3-automation-toolkit`)
- All Python packages are installed globally or in your current Python environment
- Consider using a Python virtual environment for isolation
- Make sure you have adequate disk space (at least 2GB free)

---

**Happy Automating with CD3!** 🚀
