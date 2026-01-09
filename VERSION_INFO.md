# CD3 Toolkit Setup - Version Information

## Software Versions Used

This setup is configured for the following software versions:

### Core Requirements

| Software | Version | Notes |
|----------|---------|-------|
| **Python** | 3.12 (preferred) or 3.10 | Scripts will try 3.12 first, fallback to 3.10 |
| **Terraform** | 1.13.0+ | HashiCorp Terraform for IaC |
| **Git** | Latest stable | Version control |
| **OCI CLI** | 3.66.1+ | Oracle Cloud Infrastructure CLI |

### Python Package Versions

| Package | Version | Purpose |
|---------|---------|---------|
| oci-cli | 3.66.1 | Oracle Cloud Interface CLI |
| numpy | 1.26.4 | Numerical operations (install first) |
| pandas | 2.0.3 | Data manipulation (Python 3.12 compatible) |
| openpyxl | 3.0.10 | Excel file handling (.xlsx) |
| xlrd | 1.2.0 | Excel file reading (.xls) |
| xlsxwriter | 3.2.0 | Excel file writing |
| Jinja2 | 3.1.2 | Template engine |
| PyYAML | 6.0.1 | YAML parsing |
| pycryptodomex | 3.10.1 | Cryptography |
| requests | 2.28.2 | HTTP library |
| netaddr | 0.8.0 | Network address manipulation |
| ipaddress | 1.0.23 | IP address utilities |
| GitPython | 3.1.40 | Git integration |
| regex | 2022.10.31 | Advanced regex |
| wget | 3.2 | File downloads |
| cfgparse | 1.3 | Config parsing |
| simplejson | 3.18.3 | JSON handling |

---

## Why Python 3.12 or 3.10?

### Python 3.12 (Preferred)
- **Latest stable release** (as of 2024)
- Better performance and optimizations
- Improved error messages
- Enhanced security features
- Better type hinting support

### Python 3.10 (Fallback)
- Widely available in package repositories
- Stable and well-tested
- Good compatibility with all dependencies
- Supported on older systems

### Installation Priority
The automated scripts attempt installation in this order:
1. **Try Python 3.12** - Best performance and features
2. **Fallback to Python 3.10** - If 3.12 not available
3. **Error if neither available** - Manual installation required

---

## Why Terraform 1.13?

### Terraform 1.13.0 Features
- **Stable release** with all core features
- **OCI Provider compatibility** - Works with latest OCI provider versions
- **Enhanced state management** - Better remote state handling
- **Improved error messages** - Easier debugging
- **Resource targeting improvements** - More granular apply/destroy
- **Better module support** - Enhanced module versioning

### Compatibility
- ✅ OCI Terraform Provider 5.x+
- ✅ All CD3-generated Terraform modules
- ✅ Remote state backends (OCI Object Storage, S3, etc.)
- ✅ Terraform Cloud/Enterprise

---

## Version Compatibility Matrix

### Operating Systems

| OS | Python 3.12 | Python 3.10 | Terraform 1.13 | Status |
|----|-------------|-------------|----------------|--------|
| **Ubuntu 22.04** | ✅ Native | ✅ Native | ✅ Manual | Fully Supported |
| **Ubuntu 20.04** | ⚠️ PPA/Build | ✅ Native | ✅ Manual | Supported |
| **Ubuntu 18.04** | ❌ Build Only | ✅ PPA | ✅ Manual | Limited |
| **macOS Ventura (13)** | ✅ Homebrew | ✅ Homebrew | ✅ Homebrew | Fully Supported |
| **macOS Monterey (12)** | ✅ Homebrew | ✅ Homebrew | ✅ Homebrew | Fully Supported |
| **macOS Big Sur (11)** | ✅ Homebrew | ✅ Homebrew | ✅ Homebrew | Supported |
| **Windows 11** | ✅ python.org | ✅ python.org | ✅ Manual | Fully Supported |
| **Windows 10** | ✅ python.org | ✅ python.org | ✅ Manual | Fully Supported |
| **RHEL 9** | ✅ dnf | ✅ dnf | ✅ Manual | Supported |
| **RHEL 8** | ⚠️ Build | ✅ dnf | ✅ Manual | Supported |

**Legend:**
- ✅ Available through package manager or official installer
- ⚠️ Requires additional repository or build from source
- ❌ Not recommended/supported

---

## Architecture Support

### Terraform 1.13.0 Binaries Available For:

| Architecture | Linux | macOS | Windows |
|--------------|-------|-------|---------|
| **AMD64 (x86_64)** | ✅ | ✅ | ✅ |
| **ARM64** | ✅ | ✅ (M1/M2/M3) | ✅ |
| **386 (32-bit)** | ✅ | ❌ | ✅ |

### Python Support:

| Architecture | Linux | macOS | Windows |
|--------------|-------|-------|---------|
| **AMD64 (x86_64)** | ✅ | ✅ | ✅ |
| **ARM64** | ✅ | ✅ (M1/M2/M3) | ✅ |
| **386 (32-bit)** | ✅ | ❌ | ✅ |

**Note:** The quick install script automatically detects Mac architecture (Intel vs Apple Silicon) and downloads the appropriate Terraform binary.

---

## Alternative Versions

### If You Need Different Versions:

#### Using Python 3.11
```bash
# Ubuntu/Debian
sudo apt install python3.11 python3.11-venv python3-pip
python3.11 -m venv cd3venv

# macOS
brew install python@3.11
python3.11 -m venv cd3venv
```

#### Using Terraform 1.9+ (Latest)
```bash
# Ubuntu/macOS
cd /tmp
wget https://releases.hashicorp.com/terraform/1.9.0/terraform_1.9.0_linux_amd64.zip
unzip terraform_1.9.0_linux_amd64.zip
sudo mv terraform /usr/local/bin/

# Or use Homebrew (macOS)
brew install terraform  # Gets latest
```

#### Using Older Terraform (1.5.x)
```bash
# If you specifically need an older version
cd /tmp
wget https://releases.hashicorp.com/terraform/1.5.7/terraform_1.5.7_linux_amd64.zip
unzip terraform_1.5.7_linux_amd64.zip
sudo mv terraform /usr/local/bin/
```

---

## Checking Installed Versions

### Quick Check Script

```bash
#!/bin/bash
echo "=== Installed Versions ==="
echo ""

echo -n "Python: "
python3 --version 2>/dev/null || echo "Not installed"

echo -n "Terraform: "
terraform version -json 2>/dev/null | grep -o '"version":"[^"]*"' | cut -d'"' -f4 || echo "Not installed"

echo -n "Git: "
git --version 2>/dev/null || echo "Not installed"

echo -n "OCI CLI: "
oci --version 2>/dev/null || echo "Not installed"

echo ""
echo "=== Python Packages ==="
if command -v pip &> /dev/null; then
    pip list | grep -E "oci-cli|pandas|openpyxl|Jinja2|terraform"
else
    echo "pip not found"
fi
```

Save as `check_versions.sh` and run:
```bash
chmod +x check_versions.sh
./check_versions.sh
```

---

## Upgrade Guide

### Upgrading Python

**From 3.10 to 3.12:**
```bash
# Ubuntu
sudo apt install python3.12 python3.12-venv

# Recreate virtual environment
cd ~/Desktop/Personal_DevOps/CD3/cd3-automation-toolkit
deactivate  # if active
rm -rf cd3venv
python3.12 -m venv cd3venv
source cd3venv/bin/activate

# Reinstall packages
pip install --upgrade pip
pip install -r requirements.txt  # if you have one
# Or install packages individually
```

### Upgrading Terraform

```bash
# Check current version
terraform version

# Download new version
cd /tmp
wget https://releases.hashicorp.com/terraform/1.13.0/terraform_1.13.0_linux_amd64.zip
unzip terraform_1.13.0_linux_amd64.zip

# Replace old version
sudo mv terraform /usr/local/bin/
sudo chmod +x /usr/local/bin/terraform

# Verify
terraform version
```

### Upgrading Python Packages

```bash
# Activate environment
source cd3venv/bin/activate

# Upgrade specific package
pip install --upgrade oci-cli

# Upgrade all packages (careful - may cause conflicts)
pip list --outdated
pip install --upgrade package-name

# Or upgrade with constraints
pip install --upgrade oci-cli==3.66.1
```

---

## Troubleshooting Version Issues

### Issue: Python 3.12 Not Available

**Ubuntu 20.04:**
```bash
# Add deadsnakes PPA
sudo apt update
sudo apt install software-properties-common
sudo add-apt-repository ppa:deadsnakes/ppa
sudo apt update
sudo apt install python3.12 python3.12-venv
```

**RHEL/CentOS:**
```bash
# Build from source
sudo yum install gcc openssl-devel bzip2-devel libffi-devel
cd /tmp
wget https://www.python.org/ftp/python/3.12.0/Python-3.12.0.tgz
tar xzf Python-3.12.0.tgz
cd Python-3.12.0
./configure --enable-optimizations
make -j $(nproc)
sudo make altinstall
```

### Issue: Terraform Version Mismatch

**Error:** "Required version constraint not satisfied"

**Solution:**
```bash
# Check required version in .tf files
grep -r "required_version" *.tf

# Install exact version needed
cd /tmp
wget https://releases.hashicorp.com/terraform/VERSION/terraform_VERSION_linux_amd64.zip
# Replace VERSION with needed version
```

### Issue: Package Version Conflicts

**Error:** "Cannot install package X due to dependency Y"

**Solution:**
```bash
# Create fresh environment
deactivate
rm -rf cd3venv
python3.12 -m venv cd3venv
source cd3venv/bin/activate

# Install packages in specific order
pip install --upgrade pip setuptools wheel
pip install numpy==1.26.4  # Install numpy first
pip install pandas==1.1.5  # Then pandas
# Continue with other packages
```

---

## Minimum vs Recommended Versions

### Minimum Requirements (Will Work)
- Python: 3.8
- Terraform: 1.0
- OCI CLI: 3.0
- Git: 2.0

### Recommended (Tested & Optimized)
- Python: **3.12 or 3.10**
- Terraform: **1.13.0**
- OCI CLI: **3.66.1**
- Git: **2.39+**

### Latest (Bleeding Edge)
- Python: 3.13 (may have compatibility issues)
- Terraform: 1.9+ (fully compatible, newer features)
- OCI CLI: Latest (auto-updates)
- Git: Latest stable

---

## Version Lock for Production

For production environments, consider locking versions:

### requirements.txt
```txt
# Install in this order for Python 3.12 compatibility
numpy==1.26.4
pandas==2.0.3
oci-cli==3.66.1
openpyxl==3.0.10
xlrd==1.2.0
xlsxwriter==3.2.0
Jinja2==3.1.2
PyYAML==6.0.1
pycryptodomex==3.10.1
requests==2.28.2
netaddr==0.8.0
ipaddress==1.0.23
GitPython==3.1.40
regex==2022.10.31
wget==3.2
cfgparse==1.3
simplejson==3.18.3
```

### Terraform Version Constraint
In your `.tf` files:
```hcl
terraform {
  required_version = "~> 1.13.0"

  required_providers {
    oci = {
      source  = "oracle/oci"
      version = "~> 5.19.0"
    }
  }
}
```

---

## Support & Resources

### Official Documentation
- **Python 3.12:** https://docs.python.org/3.12/
- **Python 3.10:** https://docs.python.org/3.10/
- **Terraform 1.13:** https://www.terraform.io/docs
- **OCI Terraform Provider:** https://registry.terraform.io/providers/oracle/oci/latest

### Download Links
- **Python:** https://www.python.org/downloads/
- **Terraform:** https://releases.hashicorp.com/terraform/
- **Git:** https://git-scm.com/downloads
- **OCI CLI:** https://docs.oracle.com/en-us/iaas/Content/API/SDKDocs/cliinstall.htm

### Package Repositories
- **PyPI:** https://pypi.org/
- **Terraform Registry:** https://registry.terraform.io/
- **Homebrew (macOS):** https://brew.sh/
- **APT (Ubuntu/Debian):** Default repos + PPAs

---

## Change Log

### Version 2.0 (2026-01-09)
- ✅ Updated Python requirement to 3.12 (with 3.10 fallback)
- ✅ Updated Terraform to 1.13.0
- ✅ Added automatic architecture detection for macOS (Intel/Apple Silicon)
- ✅ Enhanced installation scripts with better error handling
- ✅ Added version compatibility matrix

### Version 1.0 (Original)
- Python 3.9
- Terraform 1.5.7
- Basic installation scripts

---

**Last Updated:** 2026-01-09
**Setup Version:** 2.0
**Compatible with:** CD3 Automation Toolkit (latest)
