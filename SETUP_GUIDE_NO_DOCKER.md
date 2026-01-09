# CD3 Toolkit Setup Guide (Without Docker/Jenkins)

Complete step-by-step guide for setting up CD3 Automation Toolkit on Ubuntu, macOS, and Windows without Docker or Jenkins dependencies.

---

## Table of Contents
1. [Prerequisites](#prerequisites)
2. [Ubuntu Setup](#ubuntu-setup)
3. [macOS Setup](#macos-setup)
4. [Windows Setup](#windows-setup)
5. [Common Issues & Solutions](#common-issues--solutions)
6. [Post-Installation Configuration](#post-installation-configuration)
7. [Verification](#verification)

---

## Prerequisites

### All Platforms Need:
- **Python 3.12** (or Python 3.10 as fallback)
- **Git**
- **OCI Account** with proper permissions
- **OCI CLI configured** (we'll set this up)
- **Terraform** 1.13+ (we'll install this)
- **Internet connection** for package downloads

### OCI Requirements:
- Tenancy OCID
- User OCID
- Compartment OCID
- API Key (public/private key pair)
- Region identifier

---

## Ubuntu Setup

### Step 1: System Update & Dependencies

```bash
# Update system packages
sudo apt update && sudo apt upgrade -y

# Install essential build tools
sudo apt install -y build-essential libssl-dev libffi-dev python3-dev

# Install Python 3.12 (or 3.10) and pip
sudo apt install -y python3.12 python3.12-venv python3-pip || \
sudo apt install -y python3.10 python3.10-venv python3-pip

# Install Git
sudo apt install -y git

# Install wget and curl
sudo apt install -y wget curl unzip
```

### Step 2: Install Terraform

```bash
# Download Terraform 1.13
cd /tmp
wget https://releases.hashicorp.com/terraform/1.13.0/terraform_1.13.0_linux_amd64.zip

# Unzip and move to /usr/local/bin
unzip terraform_1.13.0_linux_amd64.zip
sudo mv terraform /usr/local/bin/

# Verify installation
terraform version
```

### Step 3: Create Python Virtual Environment

```bash
# Navigate to CD3 directory
cd ~/Desktop/Personal_DevOps/CD3/cd3-automation-toolkit

# Create virtual environment (try Python 3.12 first, fallback to 3.10)
python3.12 -m venv cd3venv || python3.10 -m venv cd3venv

# Activate virtual environment
source cd3venv/bin/activate

# Upgrade pip
pip install --upgrade pip setuptools wheel
```

### Step 4: Install Python Dependencies

```bash
# Install CD3 dependencies (Python 3.12 compatible versions)
pip install oci-cli==3.66.1
pip install numpy==1.26.4
pip install pandas==2.0.3
pip install openpyxl==3.0.10
pip install xlrd==1.2.0
pip install xlsxwriter==3.2.0
pip install Jinja2==3.1.2
pip install PyYAML==6.0.1
pip install pycryptodomex==3.10.1
pip install requests==2.28.2
pip install netaddr==0.8.0
pip install ipaddress==1.0.23
pip install GitPython==3.1.40
pip install regex==2022.10.31
pip install wget==3.2
pip install cfgparse==1.3
pip install simplejson==3.18.3

# Optional: Install Ansible if needed
# pip install ansible==8.7.0

# Azure support (if using ADB@Azure)
# pip install azure-identity azure-mgmt-compute azure-mgmt-oracledatabase
```

### Step 5: Configure OCI CLI

```bash
# Run OCI CLI setup (this creates ~/.oci/config)
oci setup config

# Follow prompts to enter:
# - Location for config [~/.oci/config]: Press Enter
# - User OCID: ocid1.user.oc1..aaaaa...
# - Tenancy OCID: ocid1.tenancy.oc1..aaaaa...
# - Region (e.g., us-ashburn-1): your-region
# - Generate a new API Signing RSA key pair? Y
# - Directory for keys [~/.oci]: Press Enter
# - Name for key [oci_api_key]: Press Enter
# - Passphrase (optional): Leave empty or set one
```

### Step 6: Upload Public Key to OCI

```bash
# Display your public key
cat ~/.oci/oci_api_key_public.pem

# Copy the output and:
# 1. Go to OCI Console
# 2. Profile Icon > User Settings
# 3. API Keys > Add API Key
# 4. Paste Public Key > Add
# 5. Note the fingerprint
```

### Step 7: Set Correct Permissions

```bash
# Set proper permissions for OCI config and keys
chmod 600 ~/.oci/config
chmod 600 ~/.oci/oci_api_key.pem
chmod 644 ~/.oci/oci_api_key_public.pem

# Verify OCI CLI connection
oci iam region list
```

---

## macOS Setup

### Step 1: Install Homebrew (if not installed)

```bash
# Install Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

### Step 2: Install Dependencies

```bash
# Install Python 3.12 (or 3.10 if 3.12 not available)
brew install python@3.12 || brew install python@3.10

# Install Git
brew install git

# Install wget
brew install wget

# Verify installations
python3.9 --version
git --version
```

### Step 3: Install Terraform

```bash
# Using Homebrew
brew tap hashicorp/tap
brew install hashicorp/tap/terraform

# Or manual installation
cd /tmp
wget https://releases.hashicorp.com/terraform/1.13.0/terraform_1.13.0_darwin_amd64.zip
unzip terraform_1.13.0_darwin_amd64.zip
sudo mv terraform /usr/local/bin/
sudo chmod +x /usr/local/bin/terraform

# Verify
terraform version
```

### Step 4: Create Python Virtual Environment

```bash
# Navigate to CD3 directory
cd ~/Desktop/Personal_DevOps/CD3/cd3-automation-toolkit

# Create virtual environment (try Python 3.12 first, fallback to 3.10)
python3.12 -m venv cd3venv || python3.10 -m venv cd3venv

# Activate virtual environment
source cd3venv/bin/activate

# Upgrade pip
pip install --upgrade pip setuptools wheel
```

### Step 5: Install Python Dependencies

```bash
# Install dependencies with Python 3.12 compatibility
pip install oci-cli==3.66.1
pip install numpy==1.26.4
pip install pandas==2.0.3
pip install openpyxl==3.0.10
pip install xlrd==1.2.0
pip install xlsxwriter==3.2.0
pip install Jinja2==3.1.2
pip install PyYAML==6.0.1
pip install pycryptodomex==3.10.1
pip install requests==2.28.2
pip install netaddr==0.8.0
pip install ipaddress==1.0.23
pip install GitPython==3.1.40
pip install regex==2022.10.31
pip install wget==3.2
pip install cfgparse==1.3
pip install simplejson==3.18.3
```

### Step 6-7: Configure OCI CLI & Upload Keys

Same as Ubuntu Steps 5-7 above.

---

## Windows Setup

### Step 1: Install Python

1. Download Python 3.12 (or 3.10) from [python.org](https://www.python.org/downloads/)
2. Run installer
3. **IMPORTANT**: Check "Add Python to PATH"
4. Choose "Customize installation"
5. Check all optional features
6. Install for all users
7. Verify installation:

```powershell
python --version
pip --version
```

### Step 2: Install Git

1. Download Git from [git-scm.com](https://git-scm.com/download/win)
2. Run installer with default settings
3. Verify: `git --version`

### Step 3: Install Terraform

```powershell
# Download Terraform manually
# Go to: https://releases.hashicorp.com/terraform/1.13.0/
# Download: terraform_1.13.0_windows_amd64.zip

# Extract to C:\Program Files\Terraform\
# Add to PATH:
# System Properties > Environment Variables > System Variables > Path
# Add: C:\Program Files\Terraform

# Verify in new terminal
terraform version
```

### Step 4: Create Python Virtual Environment

```powershell
# Navigate to CD3 directory
cd C:\Users\YourUser\Desktop\Personal_DevOps\CD3\cd3-automation-toolkit

# Create virtual environment
python -m venv cd3venv

# Activate virtual environment
.\cd3venv\Scripts\activate

# Upgrade pip
pip install --upgrade pip setuptools wheel
```

### Step 5: Install Python Dependencies

```powershell
# Install Visual C++ Build Tools first (if not already installed)
# Download from: https://visualstudio.microsoft.com/visual-cpp-build-tools/
# Install "Desktop development with C++" workload

# Install dependencies
pip install oci-cli==3.66.1
pip install pandas==1.1.5
pip install openpyxl==3.0.7
pip install xlrd==1.2.0
pip install xlsxwriter==3.2.0
pip install numpy==1.26.4
pip install Jinja2==3.1.2
pip install PyYAML==6.0.1
pip install pycryptodomex==3.10.1
pip install requests==2.28.2
pip install netaddr==0.8.0
pip install ipaddress==1.0.23
pip install GitPython==3.1.40
pip install regex==2022.10.31
pip install wget==3.2
pip install cfgparse==1.3
pip install simplejson==3.18.3
```

### Step 6: Configure OCI CLI

```powershell
# Run OCI setup
oci setup config

# Follow prompts (same as Ubuntu)
# Keys will be created in: C:\Users\YourUser\.oci\
```

### Step 7: Upload Public Key

```powershell
# Display public key
type C:\Users\YourUser\.oci\oci_api_key_public.pem

# Upload to OCI Console (same process as Ubuntu)
```

---

## Common Issues & Solutions

### Issue 1: HTTPS Error When Setting Up Tenancy

**Problem**: SSL/TLS certificate verification errors, connection timeouts

**Solutions**:

```bash
# Solution A: Update CA certificates (Ubuntu/macOS)
sudo apt update && sudo apt install -y ca-certificates  # Ubuntu
brew install ca-certificates  # macOS

# Solution B: Check proxy settings
echo $HTTP_PROXY
echo $HTTPS_PROXY

# If behind corporate proxy, configure:
export HTTP_PROXY=http://proxy.company.com:8080
export HTTPS_PROXY=http://proxy.company.com:8080
export NO_PROXY=localhost,127.0.0.1

# Add to ~/.bashrc or ~/.zshrc for persistence

# Solution C: Update OCI CLI configuration with proxy
oci setup repair-file-permissions --file ~/.oci/config

# Add to ~/.oci/config:
[DEFAULT]
...
# Proxy settings
use_https_proxy=true
https_proxy=http://proxy.company.com:8080
```

**Windows Proxy Setup**:
```powershell
# Set proxy in PowerShell
$env:HTTP_PROXY="http://proxy.company.com:8080"
$env:HTTPS_PROXY="http://proxy.company.com:8080"
```

### Issue 2: Python Dependency Conflicts

**Problem**: Version conflicts, numpy/pandas incompatibility

**Solutions**:

```bash
# Create fresh virtual environment
deactivate  # if currently in venv
rm -rf cd3venv
python3.9 -m venv cd3venv
source cd3venv/bin/activate

# Install dependencies in specific order
pip install --upgrade pip setuptools wheel
pip install numpy==1.26.4
pip install pandas==1.1.5
pip install openpyxl==3.0.7
# ... rest of dependencies
```

### Issue 3: Permission Denied Errors (Linux/macOS)

**Problem**: Cannot write to directories, permission errors

**Solutions**:

```bash
# Fix OCI directory permissions
chmod 700 ~/.oci
chmod 600 ~/.oci/config
chmod 600 ~/.oci/oci_api_key.pem

# Fix CD3 directory ownership
sudo chown -R $USER:$USER ~/Desktop/Personal_DevOps/CD3/
chmod -R 755 ~/Desktop/Personal_DevOps/CD3/
```

### Issue 4: OCI CLI Not Found After Installation

**Problem**: Command 'oci' not recognized

**Solutions**:

```bash
# Linux/macOS: Add to PATH in ~/.bashrc or ~/.zshrc
echo 'export PATH=$PATH:~/.local/bin' >> ~/.bashrc
source ~/.bashrc

# macOS specific
echo 'export PATH=$PATH:/Users/$USER/Library/Python/3.9/bin' >> ~/.zshrc
source ~/.zshrc

# Windows: Add Python Scripts to PATH
# C:\Users\YourUser\AppData\Local\Programs\Python\Python39\Scripts
```

### Issue 5: Terraform Provider Download Issues

**Problem**: Cannot download OCI provider, network timeouts

**Solutions**:

```bash
# Pre-download providers manually
mkdir -p ~/.terraform.d/plugins

# Download OCI provider
cd /tmp
wget https://releases.hashicorp.com/terraform-provider-oci/5.19.0/terraform-provider-oci_5.19.0_linux_amd64.zip
unzip terraform-provider-oci_5.19.0_linux_amd64.zip -d ~/.terraform.d/plugins/

# Or use mirror
terraform {
  required_providers {
    oci = {
      source  = "oracle/oci"
      version = "~> 5.19.0"
    }
  }
}

# Configure Terraform CLI with mirror
cat > ~/.terraformrc << EOF
provider_installation {
  filesystem_mirror {
    path    = "/home/$USER/.terraform.d/plugins"
    include = ["oracle/oci"]
  }
  direct {
    exclude = ["oracle/oci"]
  }
}
EOF
```

### Issue 6: Excel File Read Errors

**Problem**: xlrd.biffh.XLRDError, cannot read Excel files

**Solutions**:

```bash
# Downgrade xlrd for .xls support
pip install xlrd==1.2.0

# Or convert Excel to .xlsx format
# Use openpyxl exclusively for .xlsx files
```

### Issue 7: Memory Issues with Large Excel Files

**Problem**: MemoryError when processing large templates

**Solutions**:

```bash
# Increase Python memory limit (Linux/macOS)
ulimit -v unlimited

# Split large Excel files by service/region
# Process smaller chunks separately
```

---

## Post-Installation Configuration

### Step 1: Configure connectOCI.properties

```bash
cd ~/Desktop/Personal_DevOps/CD3/cd3-automation-toolkit/cd3_automation_toolkit

# Edit connectOCI.properties
nano connectOCI.properties
```

**Required Configuration**:

```properties
# OCI Authentication
tenancy_ocid=ocid1.tenancy.oc1..aaaaaaaxxxxxx
user_ocid=ocid1.user.oc1..aaaaaaaxxxxxx
region=us-ashburn-1
fingerprint=xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx
key_path=~/.oci/oci_api_key.pem

# Authentication Method
auth_mechanism=api_key

# Optional: Session token (if using)
# auth_mechanism=session_token
# security_token_file=~/.oci/session_token

# Optional: Instance principal (if running in OCI)
# auth_mechanism=instance_principal
```

### Step 2: Configure setUpOCI.properties

```bash
nano setUpOCI.properties
```

**Configuration**:

```properties
# Output directory for generated Terraform files
outdir=/home/yourusername/oci_terraform_output

# Prefix for resources
prefix=mycompany

# Path to CD3 Excel template
cd3file=/path/to/CD3-Customer-Template.xlsx

# Workflow type
workflow_type=create_resources
# or: export_resources (for reverse engineering existing infrastructure)

# IaC tool
tf_or_tofu=terraform

# Remote state (optional)
use_remote_state=no
# remote_state_bucket_name=mybucket

# OCI DevOps Git (optional)
use_oci_devops_git=no
# oci_devops_git_repo_name=myproject/myrepo
```

### Step 3: Download Excel Template

```bash
# Download the latest CD3 Excel template
cd ~/Desktop/Personal_DevOps/CD3/
wget https://github.com/oracle-devrel/cd3-automation-toolkit/releases/latest/download/CD3-Blank-Template.xlsx

# Or get customer-specific template
wget https://github.com/oracle-devrel/cd3-automation-toolkit/releases/latest/download/CD3-Customer-Template.xlsx
```

---

## Verification

### Test 1: Verify Python Environment

```bash
# Activate virtual environment
source cd3venv/bin/activate  # Linux/macOS
.\cd3venv\Scripts\activate    # Windows

# Check Python version
python --version

# Check installed packages
pip list | grep oci-cli
pip list | grep pandas
pip list | grep Jinja2
```

### Test 2: Verify OCI Connectivity

```bash
# List regions (tests authentication)
oci iam region list

# List compartments
oci iam compartment list --compartment-id-in-subtree true

# Test specific region
oci iam availability-domain list --region us-ashburn-1
```

### Test 3: Verify Terraform

```bash
# Check version
terraform version

# Initialize sample configuration
mkdir -p /tmp/tf-test
cd /tmp/tf-test

cat > main.tf << EOF
terraform {
  required_providers {
    oci = {
      source  = "oracle/oci"
      version = "~> 5.19.0"
    }
  }
}

provider "oci" {
  region = "us-ashburn-1"
}
EOF

# Initialize (downloads OCI provider)
terraform init
```

### Test 4: Run CD3 Toolkit

```bash
# Activate environment
cd ~/Desktop/Personal_DevOps/CD3/cd3-automation-toolkit/cd3_automation_toolkit
source ../cd3venv/bin/activate

# Run setUpOCI
python setUpOCI.py

# You should see the main menu:
# ============================================
#              CD3 Automation Toolkit
# ============================================
# 1. Validate CD3 Excel Template
# 2. Generate Terraform files from CD3 Excel
# 3. Export existing OCI resources to CD3 Excel
# ...
```

---

## Quick Start Workflow

### For New Infrastructure (Create Resources):

1. **Download blank template**:
   ```bash
   wget https://github.com/oracle-devrel/cd3-automation-toolkit/releases/latest/download/CD3-Blank-Template.xlsx
   ```

2. **Fill in Excel template** with your infrastructure requirements:
   - Identity, Compartments, Tags
   - Network (VCN, Subnets, Security Lists)
   - Compute instances
   - Database services
   - etc.

3. **Update setUpOCI.properties**:
   ```properties
   workflow_type=create_resources
   cd3file=/path/to/your-filled-template.xlsx
   outdir=/path/to/output
   ```

4. **Run CD3**:
   ```bash
   python setUpOCI.py
   # Select: 2. Generate Terraform files from CD3 Excel
   ```

5. **Apply Terraform**:
   ```bash
   cd /path/to/output
   terraform init
   terraform plan
   terraform apply
   ```

### For Existing Infrastructure (Export Resources):

1. **Update setUpOCI.properties**:
   ```properties
   workflow_type=export_resources
   ```

2. **Run CD3**:
   ```bash
   python setUpOCI.py
   # Select: 3. Export existing OCI resources to CD3 Excel
   ```

3. **Review generated files**:
   - Excel file with existing resources
   - Terraform files for exported infrastructure

---

## Environment Activation Aliases

### Linux/macOS

Add to `~/.bashrc` or `~/.zshrc`:

```bash
# CD3 Toolkit alias
alias cd3='cd ~/Desktop/Personal_DevOps/CD3/cd3-automation-toolkit/cd3_automation_toolkit && source ../cd3venv/bin/activate && python setUpOCI.py'
alias cd3-activate='cd ~/Desktop/Personal_DevOps/CD3/cd3-automation-toolkit && source cd3venv/bin/activate'
```

Then use:
```bash
source ~/.bashrc  # or source ~/.zshrc
cd3  # Launches CD3 directly
```

### Windows

Create `cd3.bat` in `C:\Windows\System32`:

```batch
@echo off
cd C:\Users\YourUser\Desktop\Personal_DevOps\CD3\cd3-automation-toolkit\cd3_automation_toolkit
call ..\cd3venv\Scripts\activate
python setUpOCI.py
```

Then use:
```powershell
cd3  # Launches CD3 directly
```

---

## Additional Resources

- **Official Documentation**: [CD3 Automation Toolkit GitHub](https://github.com/oracle-devrel/cd3-automation-toolkit)
- **Excel Templates**: Check releases page for latest templates
- **OCI Documentation**: [Oracle Cloud Infrastructure Docs](https://docs.oracle.com/en-us/iaas/Content/home.htm)
- **Terraform OCI Provider**: [Terraform Registry](https://registry.terraform.io/providers/oracle/oci/latest/docs)

---

## Support

For issues specific to CD3 Toolkit:
- GitHub Issues: https://github.com/oracle-devrel/cd3-automation-toolkit/issues
- Oracle Forums: https://community.oracle.com/

For OCI issues:
- OCI Support: https://support.oracle.com/

---

## Security Notes

1. **Never commit credentials** to version control
2. **Protect private keys**: Keep `~/.oci/oci_api_key.pem` secure (chmod 600)
3. **Use instance principals** when running in OCI compute instances
4. **Rotate API keys** regularly
5. **Use session tokens** for temporary access
6. **Enable MFA** on your OCI account

---

## Troubleshooting Checklist

- [ ] Python 3.8+ installed
- [ ] Virtual environment activated
- [ ] All dependencies installed without errors
- [ ] OCI CLI configured (`~/.oci/config` exists)
- [ ] API key uploaded to OCI Console
- [ ] Fingerprint matches in config
- [ ] Region is correct
- [ ] `oci iam region list` works
- [ ] Terraform installed and in PATH
- [ ] connectOCI.properties configured
- [ ] setUpOCI.properties configured
- [ ] Excel template available
- [ ] No proxy/firewall blocking OCI API
- [ ] Permissions set correctly on config files

---

**Last Updated**: 2026-01-09
**CD3 Version**: Compatible with latest release
**Tested On**: Ubuntu 20.04/22.04, macOS Monterey/Ventura, Windows 10/11
