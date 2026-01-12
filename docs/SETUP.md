# CD3 Toolkit Setup Guide

Complete guide to install and configure CD3 Automation Toolkit without Docker.

---

## 🗺️ Installation Decision Tree

```
Which platform are you using?
├─ Linux (Ubuntu/Debian/RHEL)
│  ├─ Want automatic? → Run: ./quick_install_cd3.sh [15 min]
│  └─ Want manual? → See: Linux Manual Installation
│
├─ macOS
│  ├─ Want automatic? → Run: ./quick_install_cd3.sh [15 min]
│  └─ Want manual? → See: macOS Manual Installation
│
├─ Windows
│  ├─ Have WSL? 
│  │  ├─ Yes → Run: ./cd3_wsl_complete.sh [15 min]
│  │  └─ No → Install WSL first (see below)
│  └─ Want native Windows? → See: Windows Manual Installation
│
└─ Already installed?
   ├─ Not working? → See: Troubleshooting section
   └─ Want to verify? → Run: ./verify_versions.sh
```

---

## ⚡ Quick Start (Automated)

### Recommended Path - One Command Install

**Linux/macOS:**
```bash
git clone https://github.com/oracle-devrel/cd3-automation-toolkit.git
cd cd3-automation-toolkit
./quick_install_cd3.sh
```

**Windows WSL:**
```bash
git clone https://github.com/oracle-devrel/cd3-automation-toolkit.git
cd cd3-automation-toolkit
./cd3_wsl_complete.sh
```

**⏱️ Time Required:** 10-15 minutes  
**What Gets Installed:**
- ✅ Python 3.12 or 3.10
- ✅ Terraform 1.13+
- ✅ OCI CLI 3.66+
- ✅ All required Python packages
- ✅ Virtual environment configured

**After Installation:**
```bash
./verify_versions.sh    # Verify everything is installed
./run_cd3.sh            # Run CD3 (macOS/Linux)
./run_cd3_wsl.sh        # Run CD3 (WSL)
```

---

## 📋 Prerequisites Checklist

Before starting, verify you have:

| Requirement | Minimum | Recommended | Check Command |
|-------------|---------|-------------|---------------|
| **Python** | 3.10 | 3.12 | `python3 --version` |
| **Git** | 2.0+ | Latest | `git --version` |
| **Disk Space** | 2GB | 5GB | `df -h .` |
| **Internet** | Required | Broadband | - |
| **OCI Account** | Free tier OK | Paid account | [cloud.oracle.com](https://cloud.oracle.com) |
| **Admin Access** | Required | - | Can you run `sudo`? |

**Note on Python Versions:**
- ✅ **3.10** - Fully supported
- ✅ **3.12** - Fully supported (recommended)
- ⚠️ **3.13** - NOT supported (numpy/pandas incompatibility)
- ⚠️ **3.9 or earlier** - NOT supported

---

## 🐧 Linux Installation

### Ubuntu/Debian

**Automated (Recommended):**
```bash
./quick_install_cd3.sh
```

**Manual Steps:**

```bash
# Step 1: Install system dependencies
sudo apt update
sudo apt install -y python3.12 python3.12-venv python3-pip git wget unzip

# Step 2: Verify Python version
python3.12 --version
# Should show: Python 3.12.x

# Step 3: Install Terraform
wget https://releases.hashicorp.com/terraform/1.13.0/terraform_1.13.0_linux_amd64.zip
unzip terraform_1.13.0_linux_amd64.zip
sudo mv terraform /usr/local/bin/
terraform version
# Should show: Terraform v1.13.0

# Step 4: Clone CD3 repository
cd ~
git clone https://github.com/oracle-devrel/cd3-automation-toolkit.git
cd cd3-automation-toolkit

# Step 5: Create virtual environment
python3.12 -m venv cd3venv
source cd3venv/bin/activate
# Your prompt should now show (cd3venv)

# Step 6: Upgrade pip
pip install --upgrade pip

# Step 7: Install core packages (takes ~5 minutes)
pip install numpy==1.26.4 pandas==2.0.3

# Step 8: Install CD3 dependencies (takes ~10 minutes)
pip install oci-cli==3.66.1 openpyxl==3.0.10 xlrd==1.2.0 \
    xlsxwriter==3.2.0 Jinja2==3.1.2 PyYAML==6.0.1 \
    pycryptodomex==3.10.1 requests==2.28.2 netaddr==0.8.0 \
    ipaddress==1.0.23 GitPython==3.1.40 regex==2022.10.31 \
    wget==3.2 cfgparse==1.3 simplejson==3.18.3

# Step 9: Configure OCI CLI
oci setup config
# Follow the interactive prompts

# Step 10: Verify installation
python --version
terraform version
oci --version
```

### RHEL/CentOS/Fedora

```bash
# Install dependencies
sudo dnf install -y python3.12 python3-pip git wget unzip

# Follow same steps as Ubuntu starting from Step 2
```

---

## 🍎 macOS Installation

### Automated (Recommended)

```bash
./quick_install_cd3.sh
```

### Manual Steps

```bash
# Step 1: Install Homebrew (if not installed)
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Step 2: Install dependencies via Homebrew
brew install python@3.12 git wget
brew tap hashicorp/tap
brew install hashicorp/tap/terraform

# Step 3: Verify installations
python3.12 --version
terraform version
git --version

# Step 4: Clone CD3 repository
cd ~/Desktop
git clone https://github.com/oracle-devrel/cd3-automation-toolkit.git
cd cd3-automation-toolkit

# Step 5: Create virtual environment
python3.12 -m venv cd3venv
source cd3venv/bin/activate

# Step 6: Install Python packages
pip install --upgrade pip
pip install numpy==1.26.4 pandas==2.0.3
pip install oci-cli==3.66.1 openpyxl==3.0.10 xlrd==1.2.0 \
    xlsxwriter==3.2.0 Jinja2==3.1.2 PyYAML==6.0.1 \
    pycryptodomex==3.10.1 requests==2.28.2 netaddr==0.8.0 \
    ipaddress==1.0.23 GitPython==3.1.40 regex==2022.10.31 \
    wget==3.2 cfgparse==1.3 simplejson==3.18.3

# Step 7: Configure OCI CLI
oci setup config
```

### macOS M1/M2 (Apple Silicon) Notes

If you encounter issues with pandas/numpy on Apple Silicon:

```bash
# Use Rosetta 2 Python (if needed)
arch -x86_64 python3.12 -m venv cd3venv
source cd3venv/bin/activate
arch -x86_64 pip install -r requirements.txt
```

---

## 🪟 Windows Installation

### Option 1: WSL (Recommended)

**Windows Subsystem for Linux provides the best CD3 experience on Windows.**

#### Install WSL

```powershell
# Open PowerShell as Administrator
wsl --install

# Restart your computer
# After restart, Ubuntu will open automatically
# Set username and password when prompted
```

#### Install CD3 in WSL

```bash
# In WSL terminal
cd ~
git clone https://github.com/oracle-devrel/cd3-automation-toolkit.git
cd cd3-automation-toolkit

# Use the WSL helper script
./cd3_wsl_complete.sh
```

**Or manual installation (follow Linux Ubuntu steps above)**

### Option 2: Native Windows (Advanced)

```powershell
# Step 1: Install Python 3.12
# Download from: https://www.python.org/downloads/
# ⚠️ Check "Add Python to PATH" during installation

# Step 2: Install Git
# Download from: https://git-scm.com/download/win

# Step 3: Install Terraform
# Download from: https://www.terraform.io/downloads
# Extract to C:\terraform and add to PATH

# Step 4: Verify installations (in PowerShell)
python --version
git --version
terraform version

# Step 5: Clone repository
cd $env:USERPROFILE\Desktop
git clone https://github.com/oracle-devrel/cd3-automation-toolkit.git
cd cd3-automation-toolkit

# Step 6: Create virtual environment
python -m venv cd3venv
.\cd3venv\Scripts\activate

# Step 7: Install packages
pip install --upgrade pip
pip install numpy==1.26.4 pandas==2.0.3
pip install oci-cli==3.66.1 openpyxl==3.0.10 xlrd==1.2.0 `
    xlsxwriter==3.2.0 Jinja2==3.1.2 PyYAML==6.0.1 `
    pycryptodomex==3.10.1 requests==2.28.2 netaddr==0.8.0 `
    ipaddress==1.0.23 GitPython==3.1.40 regex==2022.10.31 `
    wget==3.2 cfgparse==1.3 simplejson==3.18.3

# Step 8: Configure OCI CLI
oci setup config
```

**Note:** Native Windows may have PATH and line-ending issues. WSL is strongly recommended.

---
## 🔐 OCI Configuration

### Configuration Decision Tree

```
Do you have an OCI account?
├─ No → Create one at https://cloud.oracle.com (free tier available)
└─ Yes
   ├─ Do you have API keys?
   │  ├─ No → Run: oci setup config (generates keys)
   │  └─ Yes → Do you have fingerprint?
   │     ├─ No → Run: oci setup config
   │     └─ Yes → Configure CD3 properties (see below)
   └─ Is public key uploaded to OCI?
      ├─ No → Upload via OCI Console > User Settings > API Keys
      └─ Yes → You're ready!
```

### Step 1: Generate OCI API Keys

The OCI CLI will generate API keys for you interactively:

```bash
oci setup config
```

**Interactive Prompts:**

```
Enter a location for your config [~/.oci/config]: 
→ Press Enter (use default)

Enter a user OCID: 
→ Get from: OCI Console > Profile Icon > User Settings
→ Example: ocid1.user.oc1..aaaaaaaxxxx

Enter a tenancy OCID: 
→ Get from: OCI Console > Profile Icon > Tenancy
→ Example: ocid1.tenancy.oc1..aaaaaaaxxxx

Enter a region (e.g. us-ashburn-1): 
→ Your OCI region (e.g., us-ashburn-1, us-phoenix-1)

Do you want to generate a new API Signing RSA key pair? [Y/n]: 
→ Y (Yes - generate new keys)

Enter a directory for your keys [~/.oci]: 
→ Press Enter (use default)

Enter a name for your key [oci_api_key]: 
→ Press Enter (use default)

Enter a passphrase for your private key (empty for no passphrase): 
→ Press Enter (no passphrase is simpler)
```

**What This Creates:**
- `~/.oci/config` - OCI CLI configuration file
- `~/.oci/oci_api_key.pem` - Private key (keep secret!)
- `~/.oci/oci_api_key_public.pem` - Public key (upload to OCI)

### Step 2: Get Your OCIDs

**Tenancy OCID:**
1. Log in to OCI Console: https://cloud.oracle.com
2. Click **Profile Icon** (top right)
3. Click **Tenancy: [your-tenancy-name]**
4. Copy the **OCID** value

**User OCID:**
1. Click **Profile Icon** (top right)
2. Click **User Settings**
3. Copy the **OCID** value

**Region:**
- Listed in OCI Console top right
- Examples: `us-ashburn-1`, `us-phoenix-1`, `uk-london-1`

### Step 3: Upload Public Key to OCI

```bash
# Display your public key
cat ~/.oci/oci_api_key_public.pem
```

**Copy the entire output** (including `BEGIN` and `END` lines)

Then in OCI Console:
1. Go to **Profile Icon** → **User Settings**
2. Scroll to **API Keys** section
3. Click **Add API Key**
4. Select **Paste Public Key**
5. Paste your public key
6. Click **Add**

### Step 4: Verify OCI Connection

```bash
# Test authentication
oci iam region list

# Should list all OCI regions
# If you see regions, authentication works! ✓
```

**Troubleshooting**:
- **Error: "Service error: NotAuthenticated"**
  → Public key not uploaded or wrong fingerprint
  → Solution: Re-upload public key, verify fingerprint matches

- **Error: "Config file not found"**
  → Config not generated
  → Solution: Run `oci setup config` again

### Step 5: Configure CD3 Properties

#### File: `cd3-automation-toolkit/cd3_automation_toolkit/connectOCI.properties`

```properties
# Connection Configuration
tenancy_ocid=ocid1.tenancy.oc1..aaaaaaaxxxxxxxxx
user_ocid=ocid1.user.oc1..aaaaaaaxxxxxxxxx
region=us-ashburn-1
key_path=~/.oci/oci_api_key.pem
fingerprint=aa:bb:cc:dd:ee:ff:00:11:22:33:44:55:66:77:88:99
auth_mechanism=api_key
```

**Getting Your Fingerprint:**
```bash
# Method 1: From OCI Console
# OCI Console > User Settings > API Keys > Copy fingerprint

# Method 2: From config file
cat ~/.oci/config | grep fingerprint
```

#### File: `setUpOCI.properties`

```properties
# Output Configuration
outdir=/path/to/terraform/output
prefix=mycompany
cd3file=/path/to/CD3-Template.xlsx
workflow_type=create_resources
tf_or_tofu=terraform
```

**Example Values:**
```properties
outdir=./terraform-output
prefix=prod
cd3file=~/Downloads/CD3-Template.xlsx
workflow_type=create_resources
tf_or_tofu=terraform
```

---

## 📥 Download Excel Template

```bash
# Download latest template
wget https://github.com/oracle-devrel/cd3-automation-toolkit/releases/latest/download/CD3-Blank-Template.xlsx

# Or download manually from:
# https://github.com/oracle-devrel/cd3-automation-toolkit/releases
```

**Template Structure:**
- **Variables** tab: Global configuration
- **VCN** tab: Virtual Cloud Networks
- **Instances** tab: Compute instances
- **Block Volumes** tab: Storage
- **Security Lists** tab: Firewall rules
- **Load Balancers** tab: Traffic distribution
- Additional tabs for other OCI resources

---

## 🚀 Running CD3

### Quick Method (Helper Scripts)

```bash
# macOS/Linux
./run_cd3.sh

# WSL
./run_cd3_wsl.sh
```

**These scripts automatically:**
- ✅ Activate virtual environment
- ✅ Navigate to correct directory
- ✅ Run CD3

### Manual Method (Understanding the Process)

```bash
# Step 1: Activate virtual environment
source cd3-automation-toolkit/cd3venv/bin/activate

# Verify activation - your prompt should show (cd3venv)
# Example: (cd3venv) user@host:~$

# Step 2: Navigate to CD3 directory
cd cd3-automation-toolkit/cd3_automation_toolkit

# Verify location
pwd
# Should end with: .../cd3_automation_toolkit

# Step 3: Run CD3
python setUpOCI.py
```

### Understanding the CD3 Menu

When you run CD3, you'll see:

```
╔════════════════════════════════════════╗
║   CD3 Automation Toolkit v2.0         ║
╚════════════════════════════════════════╝

Choose workflow:
1. Validate Excel Template
2. Create Terraform Files from Excel  
3. Export OCI Resources to Excel
4. Exit

Enter your choice [1-4]:
```

**Menu Options Explained:**

| Option | Purpose | When to Use |
|--------|---------|-------------|
| **1. Validate** | Check Excel for errors | Before generating Terraform |
| **2. Create** | Generate Terraform from Excel | Creating new infrastructure |
| **3. Export** | Save OCI resources to Excel | Documenting existing infrastructure |
| **4. Exit** | Close CD3 | When finished |

---

## ✅ Verification & Testing

### Post-Installation Verification

```bash
# Quick verification script
./verify_versions.sh

# Manual verification
python --version          # Should show 3.12.x or 3.10.x
terraform version         # Should show 1.13.x or higher
oci --version            # Should show 3.66.x or higher

# Test OCI connectivity
oci iam region list
# Should list all OCI regions
```

### Expected Output

**Successful verification:**
```
✓ Python 3.12.2 found
✓ Terraform v1.13.0 found
✓ OCI CLI 3.66.1 found
✓ Virtual environment active
✓ Required packages installed
✓ OCI authentication working

All checks passed! CD3 is ready to use.
```

**If you see errors**, check:
- Virtual environment is activated: `which python3` should show `cd3venv`
- OCI config exists: `cat ~/.oci/config`
- Python packages installed: `pip list | grep oci`

---

## 🔧 Troubleshooting Common Issues

### Issue Decision Tree

```
What's the problem?
│
├─ "ModuleNotFoundError: No module named 'ocicloud'"
│  └─ Solution: Use helper script or check directory + venv
│     → See: TROUBLESHOOTING.md section "ModuleNotFoundError"
│
├─ "SSL/HTTPS certificate errors"
│  └─ Solution: Run ./fix_https_errors.sh
│     → See: TROUBLESHOOTING.md section "SSL/HTTPS Errors"
│
├─ "OCI authentication failed"
│  └─ Solution: Verify API key uploaded and fingerprint correct
│     → See: TROUBLESHOOTING.md section "OCI Connection Errors"
│
├─ "Python package conflicts"
│  └─ Solution: Recreate virtual environment
│     → See below
│
└─ "Something else"
   └─ Solution: Run diagnostic script
      → Run: ./diagnose_cd3.sh
```

### Quick Fixes

#### ModuleNotFoundError: 'ocicloud'

```bash
# Use helper script (easiest)
./run_cd3.sh

# OR verify manually
pwd                    # Should end with cd3_automation_toolkit
which python3          # Should contain cd3venv
ls -la ocicloud/       # Should exist

# If any fail, navigate correctly:
cd /path/to/cd3-automation-toolkit/cd3_automation_toolkit
source ../cd3venv/bin/activate
```

**Detailed explanation**: [TROUBLESHOOTING.md](TROUBLESHOOTING.md#modulenotfounderror-no-module-named-ocicloud)

#### SSL Certificate Errors

```bash
./fix_https_errors.sh

# OR manually
pip install --upgrade certifi
export SSL_CERT_FILE=$(python -m certifi)
```

#### OCI Connection Issues

```bash
# Check configuration
cat ~/.oci/config

# Test connection
oci iam region list

# Fix permissions
chmod 600 ~/.oci/oci_api_key.pem
chmod 600 ~/.oci/config

# Regenerate if needed
oci setup config --repair
```

#### Recreate Virtual Environment

```bash
# Deactivate current environment
deactivate

# Remove old environment
rm -rf cd3-automation-toolkit/cd3venv

# Create new environment
cd cd3-automation-toolkit
python3.12 -m venv cd3venv
source cd3venv/bin/activate

# Reinstall packages
pip install --upgrade pip
pip install -r requirements.txt
```

### Diagnostic Tools

```bash
# Comprehensive diagnostic
./diagnose_cd3.sh

# Check specific components
python -c "import oci; print('OCI SDK OK')"
python -c "import pandas; print('Pandas OK')"
python -c "from ocicloud.python import ociCommonTools; print('ocicloud OK')"

# Check environment variables
env | grep -i python
env | grep -i oci
```

---

## 📖 Usage Workflows

### Workflow 1: Create New Infrastructure

**Scenario**: You want to create new OCI resources from scratch.

```bash
# 1. Download and fill Excel template
wget https://github.com/oracle-devrel/cd3-automation-toolkit/releases/latest/download/CD3-Blank-Template.xlsx

# 2. Edit template with desired resources
# - Open in Excel/LibreOffice
# - Fill in VCN, Instances, etc.
# - Save as my-infrastructure.xlsx

# 3. Generate Terraform
./run_cd3.sh
# Select option: 2 (Create Terraform Files)
# Provide: Excel file path, output directory, prefix

# 4. Review generated code
cd output
ls -la *.tf
cat vcn.tf

# 5. Initialize Terraform
terraform init

# 6. Plan deployment
terraform plan -out=tfplan

# 7. Review plan output
# Check: resource count, configurations

# 8. Apply (creates resources in OCI)
terraform apply tfplan

# 9. Verify in OCI Console
# OCI Console > Networking > VCNs
```

**Time Estimate:**
- Excel design: 30-60 minutes
- Terraform generation: 1-2 minutes
- Terraform apply: 5-15 minutes

### Workflow 2: Document Existing Infrastructure

**Scenario**: You have existing OCI resources and want to document them.

```bash
# 1. Run CD3
./run_cd3.sh

# 2. Select option: 3 (Export OCI Resources)

# 3. Choose what to export
# - Select compartments
# - Select resource types (VCN, Compute, Storage, etc.)

# 4. Wait for export (2-15 minutes depending on size)

# 5. Review Excel output
# File created: oci-export-[timestamp].xlsx

# 6. Use for:
# - Documentation
# - Migration planning  
# - Disaster recovery
# - Compliance audits
```

### Workflow 3: Modify Existing Infrastructure

**Scenario**: You want to change existing resources managed by CD3.

```bash
# 1. Edit your Excel template
# - Modify values (e.g., change instance shape)
# - Add new resources
# - Remove resources (delete rows)

# 2. Regenerate Terraform
./run_cd3.sh
# Select option: 2

# 3. Review changes
cd output
terraform plan

# Look for:
# - Resources being modified (yellow ~)
# - Resources being added (green +)
# - Resources being destroyed (red -)

# 4. Apply changes
terraform apply
```

---

## 🌐 Corporate Environment Considerations

### Proxy Configuration

```bash
# Set environment variables
export HTTP_PROXY=http://proxy.company.com:8080
export HTTPS_PROXY=http://proxy.company.com:8080
export NO_PROXY=localhost,127.0.0.1,.oraclecloud.com

# Configure pip for proxy
pip install --proxy http://proxy.company.com:8080 package-name

# Configure OCI CLI for proxy
# Add to ~/.oci/config:
[DEFAULT]
proxy=http://proxy.company.com:8080
```

### Air-Gapped Environments

```bash
# On internet-connected machine:
pip download -r requirements.txt -d packages/

# Transfer packages/ directory to air-gapped machine

# On air-gapped machine:
pip install --no-index --find-links=packages/ -r requirements.txt
```

### Certificate Authorities

```bash
# Add corporate CA certificate
export REQUESTS_CA_BUNDLE=/path/to/corporate-ca.pem
export SSL_CERT_FILE=/path/to/corporate-ca.pem

# Or install system-wide
sudo cp corporate-ca.crt /usr/local/share/ca-certificates/
sudo update-ca-certificates
```

---

## 📚 Additional Resources

### Documentation Links
- **Architecture Deep Dive**: [ARCHITECTURE.md](../ARCHITECTURE.md)
- **Beginner's Guide**: [GETTING_STARTED.md](../GETTING_STARTED.md)
- **Quick Reference**: [QUICK_REFERENCE.md](QUICK_REFERENCE.md)
- **Troubleshooting**: [TROUBLESHOOTING.md](TROUBLESHOOTING.md)
- **Contributing**: [CONTRIBUTING.md](../CONTRIBUTING.md)

### External Resources
- **OCI Documentation**: https://docs.oracle.com/en-us/iaas/
- **Terraform OCI Provider**: https://registry.terraform.io/providers/oracle/oci/latest/docs
- **CD3 Official Repo**: https://github.com/oracle-devrel/cd3-automation-toolkit

### Community & Support
- **GitHub Issues**: Report bugs and request features
- **GitHub Discussions**: Ask questions and share experiences
- **OCI Forums**: General OCI questions

---

## 🎓 Next Steps

After completing setup:

1. **Beginners**: Read [GETTING_STARTED.md](../GETTING_STARTED.md)
2. **Experienced Users**: See [QUICK_REFERENCE.md](QUICK_REFERENCE.md)
3. **Developers**: Check [CONTRIBUTING.md](../CONTRIBUTING.md)
4. **Everyone**: Try the "Create New Infrastructure" workflow above

---

**Document Version**: 2.0  
**Last Updated**: 2026-01-12  
**Feedback**: Open an issue if you find errors or have suggestions!
