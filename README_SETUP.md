# CD3 Toolkit Setup Guide
## Simple, No Docker/Jenkins Setup for Ubuntu, macOS, and Windows

**Version:** Python 3.12/3.10 | Terraform 1.13
**Updated:** 2026-01-09

---

## 🚀 Quick Start (Choose Your OS)

### Ubuntu/macOS - One Command Install
```bash
cd ~/Desktop/Personal_DevOps/CD3
./quick_install_cd3.sh
```
**Time:** 10-15 minutes | **Installs:** Python 3.12, Terraform 1.13, all packages

### Windows - Manual Install
See [Windows Setup](#windows-setup) below

---

## 📋 What You Need

- Python 3.12 or 3.10
- Terraform 1.13+
- OCI Account with API access
- 15-30 minutes

---

## 🐧 Ubuntu Setup

### Automated Installation
```bash
cd ~/Desktop/Personal_DevOps/CD3
./quick_install_cd3.sh
```

### Manual Installation
```bash
# 1. Install dependencies
sudo apt update
sudo apt install -y python3.12 python3.12-venv python3-pip git wget curl build-essential

# 2. Install Terraform
cd /tmp
wget https://releases.hashicorp.com/terraform/1.13.0/terraform_1.13.0_linux_amd64.zip
unzip terraform_1.13.0_linux_amd64.zip
sudo mv terraform /usr/local/bin/

# 3. Create virtual environment
cd ~/Desktop/Personal_DevOps/CD3/cd3-automation-toolkit
python3.12 -m venv cd3venv
source cd3venv/bin/activate

# 4. Install Python packages
pip install --upgrade pip
pip install -r ../../requirements.txt
```

---

## 🍎 macOS Setup

### Automated Installation
```bash
cd ~/Desktop/Personal_DevOps/CD3
./quick_install_cd3.sh
```

### Manual Installation
```bash
# 1. Install Homebrew (if needed)
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# 2. Install dependencies
brew install python@3.12 git wget terraform

# 3. Create virtual environment
cd ~/Desktop/Personal_DevOps/CD3/cd3-automation-toolkit
python3.12 -m venv cd3venv
source cd3venv/bin/activate

# 4. Install Python packages
pip install --upgrade pip
pip install -r ../../requirements.txt
```

---

## 🪟 Windows Setup

### Prerequisites
1. Download [Python 3.12](https://www.python.org/downloads/) - **Check "Add to PATH"**
2. Download [Git](https://git-scm.com/download/win)
3. Download [Terraform 1.13](https://releases.hashicorp.com/terraform/1.13.0/terraform_1.13.0_windows_amd64.zip)
4. Download [Visual C++ Build Tools](https://visualstudio.microsoft.com/visual-cpp-build-tools/)

### Installation Steps
```powershell
# 1. Create virtual environment
cd C:\Users\YourUser\Desktop\Personal_DevOps\CD3\cd3-automation-toolkit
python -m venv cd3venv
.\cd3venv\Scripts\activate

# 2. Install Python packages
pip install --upgrade pip
pip install -r ..\..\requirements.txt
```

---

## ⚙️ Configure OCI

### Option 1: CLI Generated Keys (Recommended)

```bash
# Generate keys locally
oci setup config

# Upload public key to OCI Console
cat ~/.oci/oci_api_key_public.pem
```

Then:
1. Go to OCI Console
2. Profile Icon → User Settings → API Keys → Add API Key
3. Choose "Paste Public Key"
4. Paste the key content
5. Click "Add"

### Option 2: Use Downloaded Console Key

If you downloaded a key from OCI Console:

```bash
# Move key to correct location
mkdir -p ~/.oci
mv ~/Downloads/oracleidentitycloudservice_*.pem ~/.oci/oci_api_key.pem
chmod 600 ~/.oci/oci_api_key.pem

# Create config file
nano ~/.oci/config
```

Add this content:
```ini
[DEFAULT]
user=ocid1.user.oc1..aaaaaaaxxxxx
fingerprint=aa:bb:cc:dd:ee:ff:11:22:33:44:55:66:77:88:99:00
tenancy=ocid1.tenancy.oc1..aaaaaaaxxxxx
region=us-ashburn-1
key_file=~/.oci/oci_api_key.pem
```

Get values from OCI Console:
- **User OCID:** Profile Icon → User Settings → OCID
- **Tenancy OCID:** Profile Icon → Tenancy → OCID
- **Fingerprint:** Profile Icon → User Settings → API Keys
- **Region:** Your home region (e.g., us-ashburn-1)

---

## 🔧 Configure CD3

### Edit connectOCI.properties

```bash
cd ~/Desktop/Personal_DevOps/CD3/cd3-automation-toolkit/cd3_automation_toolkit
nano connectOCI.properties
```

Required settings:
```properties
tenancy_ocid=ocid1.tenancy.oc1..aaaaaaaxxxxx
user_ocid=ocid1.user.oc1..aaaaaaaxxxxx
region=us-ashburn-1
key_path=~/.oci/oci_api_key.pem
fingerprint=aa:bb:cc:dd:ee:ff:11:22:33:44:55:66:77:88:99:00
auth_mechanism=api_key
```

### Edit setUpOCI.properties

```bash
nano setUpOCI.properties
```

Required settings:
```properties
outdir=/path/to/terraform/output
prefix=mycompany
cd3file=/path/to/CD3-Template.xlsx
workflow_type=create_resources
tf_or_tofu=terraform
```

---

## ✅ Verify Installation

```bash
# Run verification script
./verify_versions.sh

# Or manually check
python3 --version      # Should show 3.12 or 3.10
terraform version      # Should show 1.13+
oci --version          # Should show 3.66+
oci iam region list    # Should list OCI regions
```

---

## 🚀 Run CD3

```bash
# Activate environment
source ~/Desktop/Personal_DevOps/CD3/cd3-automation-toolkit/cd3venv/bin/activate

# Run CD3
cd ~/Desktop/Personal_DevOps/CD3/cd3-automation-toolkit/cd3_automation_toolkit
python setUpOCI.py
```

---

## 🐛 Common Issues

### Python 3.12 Package Error
**Error:** `AttributeError: module 'configparser' has no attribute 'SafeConfigParser'`

**Solution:** Use pandas 2.0.3 (included in requirements.txt)
```bash
pip install pandas==2.0.3
```

### HTTPS/SSL Errors
```bash
./fix_https_errors.sh    # Linux/macOS
.\fix_https_errors.ps1   # Windows
```

### OCI Authentication Failed
```bash
# Check fingerprint matches
grep fingerprint ~/.oci/config
# Compare with: OCI Console → User Settings → API Keys

# Fix permissions
chmod 600 ~/.oci/oci_api_key.pem
chmod 600 ~/.oci/config
```

### Permission Denied
```bash
chmod 700 ~/.oci
chmod 600 ~/.oci/*
```

---

## 📦 Package Versions

**Python 3.12 Compatible:**
- numpy==1.26.4
- pandas==2.0.3
- oci-cli==3.66.1
- openpyxl==3.0.10
- Terraform 1.13+

Full list in [requirements.txt](requirements.txt)

---

## 📚 Additional Help

### Scripts
- `quick_install_cd3.sh` - Automated installer (Linux/macOS)
- `install_packages.sh` - Install packages only
- `verify_versions.sh` - Check installation
- `fix_https_errors.sh` - Fix SSL issues
- `requirements.txt` - Python packages

### Documentation
- `PYTHON312_COMPATIBILITY.md` - Python 3.12 compatibility details
- `COMPATIBILITY_FIX_SUMMARY.md` - Recent compatibility fixes
- `VERSION_INFO.md` - Detailed version information

### Get Help
- GitHub: https://github.com/oracle-devrel/cd3-automation-toolkit/issues
- OCI Docs: https://docs.oracle.com/en-us/iaas/

---

## ⚡ Quick Commands

```bash
# Install everything
./quick_install_cd3.sh

# Install packages only
pip install -r requirements.txt

# Verify setup
./verify_versions.sh

# Fix HTTPS issues
./fix_https_errors.sh

# Run CD3
source cd3venv/bin/activate
cd cd3-automation-toolkit/cd3_automation_toolkit
python setUpOCI.py
```

---

## 🎯 Workflow

1. **Install** - Run `quick_install_cd3.sh` or follow manual steps
2. **Configure OCI** - Setup API keys and config
3. **Configure CD3** - Edit .properties files
4. **Download Template** - Get CD3 Excel template
5. **Fill Template** - Add your infrastructure requirements
6. **Generate Terraform** - Run `python setUpOCI.py`
7. **Apply Infrastructure** - `terraform init && terraform apply`

---

**Last Updated:** 2026-01-09
**Tested On:** Ubuntu 20.04/22.04, macOS Monterey/Ventura, Windows 10/11
**Status:** Production Ready ✅
