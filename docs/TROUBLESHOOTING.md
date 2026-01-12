# CD3 Troubleshooting Guide

> **Quick Diagnostic**: Run `./diagnose_cd3.sh` to automatically identify issues

---

## 🔍 Troubleshooting Decision Tree

```
Something not working?
│
├─ Installation Issues?
│  ├─ Packages won't install → See: Package Installation Issues
│  ├─ Python version wrong → See: Python Version Issues
│  └─ Script fails → See: Installation Script Failures
│
├─ Runtime Errors?
│  ├─ ModuleNotFoundError → See: ModuleNotFoundError Section (MOST COMMON)
│  ├─ SSL/HTTPS errors → See: SSL/HTTPS Errors Section
│  ├─ OCI authentication → See: OCI Connection Errors Section
│  └─ Terraform errors → See: Terraform Issues Section
│
├─ Performance Issues?
│  ├─ Slow generation → See: Performance Optimization
│  └─ Timeouts → See: Timeout Issues
│
└─ Not sure?
   └─ Run: ./diagnose_cd3.sh
```

---

## ⚠️ Most Common Issues (Fix These First)

### Issue Frequency Chart

| Issue | Frequency | Quick Fix | Time |
|-------|-----------|-----------|------|
| ModuleNotFoundError: 'ocicloud' | 80% | `./run_cd3.sh` | 1 min |
| Virtual env not activated | 60% | `source cd3venv/bin/activate` | 1 min |
| Wrong directory | 50% | `cd cd3_automation_toolkit` | 1 min |
| SSL certificate errors | 20% | `./fix_https_errors.sh` | 2 min |
| OCI auth failed | 15% | Re-upload public key | 5 min |

---

## Common Issues and Solutions

### 1. ModuleNotFoundError: No module named 'ocicloud'

**Frequency**: 🔥🔥🔥🔥🔥 (Most common issue - 80% of support requests)

#### Error Message:
```
Traceback (most recent call last):
  File ".../createTenancyConfig.py", line 23, in <module>
    from ocicloud.python.ociCommonTools import *
ModuleNotFoundError: No module named 'ocicloud'
```

#### Diagnosis Flowchart

```
ModuleNotFoundError occurred?
│
├─ Is virtual environment activated?
│  ├─ No → FIX: source cd3venv/bin/activate
│  └─ Yes ↓
│
├─ Are you in correct directory?
│  ├─ No → FIX: cd cd3_automation_toolkit/cd3_automation_toolkit
│  └─ Yes ↓
│
├─ Does ocicloud/ directory exist?
│  ├─ No → FIX: Re-clone repository
│  └─ Yes ↓
│
└─ PYTHONPATH set correctly?
   ├─ No → FIX: export PYTHONPATH=...
   └─ Yes → Contact support (rare edge case)
```

#### Quick Fix (Use Helper Script)

```bash
# macOS/Linux
./run_cd3.sh

# WSL
./run_cd3_wsl.sh

# These scripts handle everything automatically!
```

#### Manual Fix (Understanding the Problem)

**Why This Happens:**

CD3 uses a local module called `ocicloud` that's not a pip package. Python needs to find it, which requires:
1. ✅ Virtual environment activated (provides dependencies)
2. ✅ Correct working directory (so Python can find ocicloud/)
3. ✅ ocicloud/ exists in current directory

**Step-by-Step Fix:**

```bash
# Step 1: Check current directory
pwd
# MUST end with: cd3_automation_toolkit
# Example: /home/user/cd3-automation-toolkit/cd3_automation_toolkit

# If wrong, navigate to correct location:
cd /path/to/cd3-automation-toolkit/cd3_automation_toolkit

# Step 2: Check if virtual environment is active
which python3
# MUST contain: cd3venv
# Example: /home/user/cd3-automation-toolkit/cd3venv/bin/python3

# If not active:
source ../cd3venv/bin/activate
# Your prompt should now show (cd3venv)

# Step 3: Verify ocicloud exists
ls -la ocicloud/
# Should show:
# drwxr-xr-x ... ocicloud
# -rw-r--r-- ... __init__.py
# drwxr-xr-x ... python/

# Step 4: Test import
python3 -c "from ocicloud.python import ociCommonTools; print('SUCCESS')"
# Should print: SUCCESS

# Step 5: Run CD3
python3 setUpOCI.py
```

#### Platform-Specific Notes

**WSL Users:**
```bash
# Use absolute Linux paths, not Windows paths
# Wrong: cd /mnt/c/Users/...
# Correct: cd /home/username/cd3-automation-toolkit/...
```

**macOS Users:**
```bash
# Use helper script to avoid path issues
./run_cd3.sh
```

**Windows Native:**
```powershell
# Use backslashes in paths
cd C:\Users\Username\cd3-automation-toolkit\cd3_automation_toolkit
.\cd3venv\Scripts\activate
python setUpOCI.py
```

#### Advanced Troubleshooting

If the above doesn't work:

```bash
# Check Python sys.path
python3 -c "import sys; print('\n'.join(sys.path))"
# Should include current directory (.)

# Manually add to PYTHONPATH (temporary)
export PYTHONPATH="${PYTHONPATH}:$(pwd)"

# Check for typos in directory name
ls -la | grep -i cd3
# Verify spelling matches exactly

# Verify Python can see the module
python3 -c "import os; print(os.path.exists('ocicloud'))"
# Should print: True
```

#### Prevention

To avoid this issue:

1. **Always use helper scripts**: `./run_cd3.sh` or `./run_cd3_wsl.sh`
2. **Create an alias** (add to `~/.bashrc` or `~/.zshrc`):
   ```bash
   alias cd3='cd /path/to/cd3-automation-toolkit/cd3_automation_toolkit && source ../cd3venv/bin/activate && python3 setUpOCI.py'
   ```
3. **Use absolute paths** in scripts to avoid confusion

**See Also**: [FINAL_FIX.md](../FINAL_FIX.md) for detailed explanation

---

### 2. SSL/HTTPS Errors

**Frequency**: 🔥🔥 (20% of issues)

#### Error Messages:
```
SSLError: [SSL: CERTIFICATE_VERIFY_FAILED] certificate verify failed
urllib3.exceptions.SSLError: SSL certificate problem
requests.exceptions.SSLError: HTTPSConnectionPool
```

#### Quick Fix

```bash
# Linux/macOS
./fix_https_errors.sh

# Windows
.\fix_https_errors.ps1
```

#### Manual Fix

```bash
# Update certifi package
pip install --upgrade certifi

# Set environment variable
export SSL_CERT_FILE=$(python -m certifi)

# Make permanent (add to ~/.bashrc or ~/.zshrc)
echo 'export SSL_CERT_FILE=$(python -m certifi)' >> ~/.bashrc
source ~/.bashrc
```

#### Corporate/Enterprise Environments

If using corporate proxy or custom CA:

```bash
# Set custom certificate bundle
export REQUESTS_CA_BUNDLE=/path/to/corporate-ca-bundle.crt
export SSL_CERT_FILE=/path/to/corporate-ca-bundle.crt

# Or disable SSL verification (NOT recommended for production)
export PYTHONHTTPSVERIFY=0
```

#### Verification

```bash
# Test SSL connection
python3 -c "import requests; r = requests.get('https://www.oracle.com'); print('SSL OK')"

# Test OCI connection
oci iam region list
```

---

### 3. OCI Connection Errors

**Frequency**: 🔥🔥 (15% of issues)

#### Error Messages:
```
ServiceError: Authorization failed or requested resource not found
ServiceError: The required information to complete authentication was not provided
ConfigFileNotFound: Config file not found
```

#### Diagnosis Flowchart

```
OCI authentication failing?
│
├─ Does ~/.oci/config exist?
│  ├─ No → FIX: Run 'oci setup config'
│  └─ Yes ↓
│
├─ Is public key uploaded to OCI Console?
│  ├─ No → FIX: Upload via User Settings > API Keys
│  └─ Yes ↓
│
├─ Does fingerprint match?
│  ├─ No → FIX: Re-upload key or update config
│  └─ Yes ↓
│
├─ Are file permissions correct?
│  ├─ No → FIX: chmod 600 ~/.oci/*.pem
│  └─ Yes ↓
│
└─ Test with 'oci iam region list'
   ├─ Works → Config OK, check CD3 properties
   └─ Fails → Contact OCI support
```

#### Solution Steps

**Step 1: Verify Config Exists**
```bash
# Check if config file exists
cat ~/.oci/config

# Should show:
# [DEFAULT]
# user=ocid1.user.oc1..xxx
# fingerprint=xx:xx:xx...
# tenancy=ocid1.tenancy.oc1..xxx
# region=us-ashburn-1
# key_file=/path/to/oci_api_key.pem
```

**Step 2: Check File Permissions**
```bash
# Set correct permissions
chmod 700 ~/.oci
chmod 600 ~/.oci/config
chmod 600 ~/.oci/*.pem

# Verify ownership
ls -la ~/.oci/
# Should show your username, not root
```

**Step 3: Verify Public Key Upload**
```bash
# Display public key
cat ~/.oci/oci_api_key_public.pem

# Copy the output
# Go to OCI Console > Profile > User Settings > API Keys
# Check if this key is listed
# If not, click "Add API Key" and paste
```

**Step 4: Check Fingerprint Match**
```bash
# From OCI Console
# User Settings > API Keys > Copy fingerprint

# From local config
cat ~/.oci/config | grep fingerprint

# These MUST match exactly!
```

**Step 5: Test Connection**
```bash
# Basic test
oci iam region list

# Should list all OCI regions
# If this works, OCI config is correct
```

#### Common Causes

| Error | Cause | Solution |
|-------|-------|----------|
| "Authorization failed" | Public key not uploaded | Upload to OCI Console |
| "Config file not found" | OCI not configured | Run `oci setup config` |
| "Invalid fingerprint" | Mismatch between config and OCI | Re-upload or fix fingerprint |
| "Permission denied" | Wrong file permissions | `chmod 600 ~/.oci/*.pem` |
| "Invalid key format" | Corrupted key file | Regenerate with `oci setup config` |

#### Regenerate Configuration

If nothing works, start fresh:

```bash
# Backup current config
cp ~/.oci/config ~/.oci/config.backup
cp ~/.oci/oci_api_key.pem ~/.oci/oci_api_key.pem.backup

# Delete API key from OCI Console
# User Settings > API Keys > Delete old key

# Regenerate
oci setup config

# Upload new public key to OCI Console
cat ~/.oci/oci_api_key_public.pem
# Copy and upload via User Settings > API Keys > Add
```

---

### 4. Python Version Issues

**Frequency**: 🔥 (10% of issues)

#### Error Messages:
```
pandas requires Python '>=3.9,<3.13'
numpy.dtype size changed, may indicate binary incompatibility
ModuleNotFoundError: No module named '_sqlite3'
```

#### Check Your Python Version

```bash
python3 --version
# OR
python --version

# Acceptable versions: 3.10.x or 3.12.x
# NOT supported: 3.13+, 3.9 or earlier
```

#### Version Decision Tree

```
What Python version do you have?
│
├─ Python 3.13+ → INCOMPATIBLE
│  └─ FIX: Install Python 3.12
│     ├─ macOS: brew install python@3.12
│     ├─ Ubuntu: sudo apt install python3.12
│     └─ Windows: Download from python.org
│
├─ Python 3.12 → ✅ PERFECT (recommended)
│
├─ Python 3.11 → ⚠️ May work but not tested
│  └─ Recommended: Switch to 3.12
│
├─ Python 3.10 → ✅ SUPPORTED
│
└─ Python 3.9 or earlier → INCOMPATIBLE
   └─ FIX: Upgrade to Python 3.12
```

#### Fix: Use Correct Python Version

**Ubuntu/Debian:**
```bash
# Install Python 3.12
sudo apt update
sudo apt install python3.12 python3.12-venv

# Recreate virtual environment
cd cd3-automation-toolkit
rm -rf cd3venv
python3.12 -m venv cd3venv
source cd3venv/bin/activate

# Reinstall packages
pip install --upgrade pip
pip install -r requirements.txt
```

**macOS:**
```bash
# Install Python 3.12
brew install python@3.12

# Recreate venv
rm -rf cd3venv
python3.12 -m venv cd3venv
source cd3venv/bin/activate
pip install -r requirements.txt
```

**Windows:**
1. Download Python 3.12 from https://www.python.org/downloads/
2. Install (check "Add to PATH")
3. Recreate virtual environment:
   ```powershell
   cd cd3-automation-toolkit
   Remove-Item -Recurse cd3venv
   python3.12 -m venv cd3venv
   .\cd3venv\Scripts\activate
   pip install -r requirements.txt
   ```

---

### 5. Virtual Environment Issues

**Frequency**: 🔥 (10% of issues)

#### Symptoms:
- Commands not found after activation
- Wrong Python version in venv
- Packages not found after installation

#### Check Virtual Environment Status

```bash
# Is it activated?
echo $VIRTUAL_ENV
# Should show path to cd3venv

# Which Python is being used?
which python3
# Should show: .../cd3venv/bin/python3

# Check prompt
# Should show: (cd3venv) user@host:~$
```

#### Recreate Virtual Environment

```bash
# Deactivate if active
deactivate

# Remove old venv
cd cd3-automation-toolkit
rm -rf cd3venv

# Create new venv
python3.12 -m venv cd3venv

# Activate
source cd3venv/bin/activate

# Verify
which python3
python3 --version

# Install packages
pip install --upgrade pip
pip install -r requirements.txt

# Verify packages
pip list | grep -E "oci|pandas|numpy"
```

#### Make Activation Easier

Add alias to your shell config:

```bash
# For bash (~/.bashrc)
echo 'alias cd3-activate="source ~/cd3-automation-toolkit/cd3venv/bin/activate && cd ~/cd3-automation-toolkit/cd3_automation_toolkit"' >> ~/.bashrc
source ~/.bashrc

# For zsh (~/.zshrc)
echo 'alias cd3-activate="source ~/cd3-automation-toolkit/cd3venv/bin/activate && cd ~/cd3-automation-toolkit/cd3_automation_toolkit"' >> ~/.zshrc
source ~/.zshrc

# Now just run:
cd3-activate
```

---

## Terraform Not Found

**Error:** `terraform: command not found`

**Solution:**

**Linux:**
```bash
wget https://releases.hashicorp.com/terraform/1.13.0/terraform_1.13.0_linux_amd64.zip
unzip terraform_1.13.0_linux_amd64.zip
sudo mv terraform /usr/local/bin/
terraform version
```

**macOS:**
```bash
brew tap hashicorp/tap
brew install hashicorp/tap/terraform
```

**Windows:**
Download from: https://releases.hashicorp.com/terraform/1.13.0/
Add to PATH in System Properties → Environment Variables

---

## Permission Denied Errors

**Error:** `Permission denied: '/home/user/.oci/config'`

**Solution:**
```bash
# Fix OCI directory permissions
chmod 700 ~/.oci
chmod 600 ~/.oci/config
chmod 600 ~/.oci/*.pem

# If using sudo, own the files
sudo chown -R $USER:$USER ~/.oci
```

---

## Virtual Environment Issues

**Problem:** Commands not found after activation

**Solution:**
```bash
# Ensure virtual environment exists
ls -la cd3-automation-toolkit/cd3venv/

# If missing, recreate it
cd cd3-automation-toolkit
python3.12 -m venv cd3venv

# Activate properly
source cd3venv/bin/activate

# Verify activation
which python3
# Should show: .../cd3venv/bin/python3
```

---

## Excel Template Issues

**Error:** Cannot read Excel file

**Solution:**
```bash
# Ensure openpyxl is installed
pip install openpyxl==3.0.10

# Download template
wget https://github.com/oracle-devrel/cd3-automation-toolkit/releases/latest/download/CD3-Blank-Template.xlsx

# Check file permissions
chmod 644 CD3-Blank-Template.xlsx
```

---

## Corporate Proxy Issues

**Error:** Connection timeout when installing packages

**Solution:**
```bash
# Set proxy environment variables
export HTTP_PROXY=http://proxy.company.com:8080
export HTTPS_PROXY=http://proxy.company.com:8080
export NO_PROXY=localhost,127.0.0.1,.oraclecloud.com

# Configure pip to use proxy
pip install --proxy http://proxy.company.com:8080 package-name

# Configure OCI CLI for proxy
oci setup repair-file-permissions --file ~/.oci/config
```

---

## WSL-Specific Issues

### Windows Path vs Linux Path

Make sure you're using Linux paths in WSL:
```bash
# Wrong (Windows path)
cd /mnt/c/Users/Username/Desktop/CD3

# Correct (Linux path)
cd /home/username/cd3-without-docker
```

### Line Ending Issues

If scripts fail with `^M` errors:
```bash
# Convert Windows line endings to Unix
dos2unix quick_install_cd3.sh
# OR
sed -i 's/\r$//' quick_install_cd3.sh
```

---

## Checking Installation Status

Run these commands to verify your setup:

```bash
# 1. Check Python version
python3 --version
# Expected: 3.12.x or 3.10.x

# 2. Check virtual environment
which python3
# Expected: .../cd3venv/bin/python3

# 3. Check Terraform
terraform version
# Expected: Terraform v1.13.0 or higher

# 4. Check OCI CLI
oci --version
# Expected: 3.66.x or higher

# 5. Test OCI connection
oci iam region list
# Expected: List of OCI regions

# 6. Check Python packages
pip list | grep -E "oci|pandas|numpy"
# Expected: All packages installed

# 7. Verify CD3 structure
ls -la cd3-automation-toolkit/cd3_automation_toolkit/ocicloud/
# Expected: Directory exists with __init__.py
```

---

## Debug Mode

Enable detailed logging for troubleshooting:

```bash
# OCI CLI debug mode
export OCI_CLI_DEBUG=true
oci iam region list

# Python debug mode
python3 -u setUpOCI.py

# Check CD3 logs
tail -f ~/.oci/logs/*.log
```

---

## 🔧 Diagnostic Tools

### Automated Diagnostics

```bash
# Run comprehensive diagnostic
./diagnose_cd3.sh

# Check installation status
./verify_versions.sh

# Check specific components
python -c "import oci; print('✓ OCI SDK OK')"
python -c "import pandas; print('✓ Pandas OK')"
python -c "from ocicloud.python import ociCommonTools; print('✓ ocicloud OK')"
```

### Manual System Check

```bash
# 1. Check Python version
python3 --version
# Expected: 3.12.x or 3.10.x

# 2. Check virtual environment
which python3
# Expected: .../cd3venv/bin/python3

# 3. Check Terraform
terraform version
# Expected: Terraform v1.13.0 or higher

# 4. Check OCI CLI
oci --version
# Expected: 3.66.x or higher

# 5. Test OCI connection
oci iam region list
# Expected: List of OCI regions

# 6. Check Python packages
pip list | grep -E "oci|pandas|numpy"
# Expected: All packages installed

# 7. Verify CD3 structure
ls -la cd3-automation-toolkit/cd3_automation_toolkit/ocicloud/
# Expected: Directory exists with __init__.py

# 8. Check current directory
pwd
# Expected: Path ending with cd3_automation_toolkit

# 9. Check environment variables
env | grep -i python
env | grep -i oci

# 10. Test CD3 import
cd cd3-automation-toolkit/cd3_automation_toolkit
python3 -c "from ocicloud.python import ociCommonTools; print('SUCCESS')"
# Expected: SUCCESS
```

### Environment Information Collection

When asking for help, run this and share the output:

```bash
#!/bin/bash
echo "=== CD3 Diagnostic Report ==="
echo "Date: $(date)"
echo ""
echo "=== System Information ==="
uname -a
echo ""
echo "=== Python ==="
python3 --version
which python3
echo ""
echo "=== Terraform ==="
terraform version
echo ""
echo "=== OCI CLI ==="
oci --version
echo ""
echo "=== Virtual Environment ==="
echo "VIRTUAL_ENV: $VIRTUAL_ENV"
echo ""
echo "=== Current Directory ==="
pwd
ls -la
echo ""
echo "=== OCI Config ==="
ls -la ~/.oci/
cat ~/.oci/config | grep -v "user\|tenancy\|key_file"
echo ""
echo "=== Python Packages ==="
pip list | grep -E "oci|pandas|numpy|jinja2"
echo ""
echo "=== CD3 Structure ==="
ls -la ocicloud/ 2>/dev/null || echo "ocicloud not in current directory"
echo ""
echo "=== Environment Variables ==="
env | grep -i python
env | grep -i oci
```

---

## 📋 Pre-Flight Checklist

Before running CD3, verify:

- [ ] **Virtual environment activated**
  ```bash
  echo $VIRTUAL_ENV  # Should show path
  ```

- [ ] **Correct directory**
  ```bash
  pwd  # Should end with cd3_automation_toolkit
  ```

- [ ] **Python version correct**
  ```bash
  python3 --version  # Should be 3.10.x or 3.12.x
  ```

- [ ] **OCI configured**
  ```bash
  oci iam region list  # Should list regions
  ```

- [ ] **Packages installed**
  ```bash
  pip list | grep oci  # Should show oci and oci-cli
  ```

- [ ] **ocicloud exists**
  ```bash
  ls ocicloud/  # Should show directory
  ```

---

## 🆘 Getting Help

### Before Asking for Help

1. **Run diagnostics:**
   ```bash
   ./diagnose_cd3.sh
   ```

2. **Check existing solutions:**
   - [FINAL_FIX.md](../FINAL_FIX.md) - Common ocicloud error
   - [GETTING_STARTED.md](../GETTING_STARTED.md) - Beginner guide
   - [SETUP.md](SETUP.md) - Installation guide

3. **Search existing issues:**
   - GitHub Issues: https://github.com/oracle-devrel/cd3-automation-toolkit/issues

### How to Ask Good Questions

**Bad Question:**
> "It doesn't work, help!"

**Good Question:**
> **Title:** ModuleNotFoundError when running setUpOCI.py on Ubuntu 22.04
> 
> **Environment:**
> - OS: Ubuntu 22.04 LTS
> - Python: 3.12.2
> - CD3 Version: Latest (cloned 2026-01-12)
> - Installation method: ./quick_install_cd3.sh
> 
> **What I'm trying to do:**
> Run CD3 to generate Terraform files from Excel
> 
> **Steps I followed:**
> 1. Ran `./quick_install_cd3.sh` (completed successfully)
> 2. Ran `source cd3venv/bin/activate`
> 3. Ran `cd cd3_automation_toolkit`
> 4. Ran `python setUpOCI.py`
> 
> **Error message:**
> ```
> ModuleNotFoundError: No module named 'ocicloud'
> ```
> 
> **What I've tried:**
> - Verified virtual environment is active (prompt shows cd3venv)
> - Checked directory with `pwd` - shows cd3_automation_toolkit
> - Verified ocicloud exists with `ls ocicloud/`
> 
> **Diagnostic output:**
> ```
> python3 --version: Python 3.12.2
> which python3: /home/user/cd3-automation-toolkit/cd3venv/bin/python3
> pip list | grep oci: [output here]
> ```

### Where to Get Help

1. **GitHub Issues**
   - Report bugs: https://github.com/oracle-devrel/cd3-automation-toolkit/issues
   - Label appropriately: bug, question, help wanted

2. **GitHub Discussions**
   - General questions
   - Feature requests
   - Share experiences

3. **Documentation**
   - [ARCHITECTURE.md](../ARCHITECTURE.md) - Technical details
   - [CONTRIBUTING.md](../CONTRIBUTING.md) - Development guide
   - [QUICK_REFERENCE.md](QUICK_REFERENCE.md) - Command reference

### Information to Include

When asking for help, always provide:

1. **Environment details:**
   - Operating system and version
   - Python version
   - Terraform version
   - OCI CLI version

2. **Full error message:**
   - Complete stack trace
   - Not just "it doesn't work"

3. **Steps to reproduce:**
   - Exact commands you ran
   - In what order

4. **What you've tried:**
   - Solutions you attempted
   - Results of those attempts

5. **Diagnostic output:**
   - Output of `./diagnose_cd3.sh`
   - Output of `./verify_versions.sh`

---

## 💡 Tips for Success

### General Tips

1. **Use helper scripts** - They handle environment setup automatically
2. **Check prerequisites** - Python version matters!
3. **Read error messages** - They usually tell you what's wrong
4. **One step at a time** - Don't skip installation steps
5. **Ask for help early** - Don't waste hours stuck

### Platform-Specific Tips

**Linux:**
- Use package manager for dependencies: `apt`, `yum`, `dnf`
- Check SELinux if permission issues persist
- Use `sudo` only when necessary

**macOS:**
- Use Homebrew for easy package management
- Apple Silicon (M1/M2) may need Rosetta for some packages
- Avoid using system Python - use Homebrew Python

**Windows:**
- WSL is strongly recommended over native Windows
- Use Linux paths in WSL, not Windows paths
- Line endings matter - use Unix (LF) not Windows (CRLF)

### Debugging Mindset

```
When something doesn't work:
1. Read the error message carefully
2. Identify what component failed (Python? OCI? Terraform?)
3. Check that component specifically
4. Isolate the problem (does oci CLI work alone?)
5. Fix one thing at a time
6. Verify the fix worked
7. Continue to next issue
```

---

## 📚 Related Documentation

- **[README.md](../README.md)** - Start here for navigation
- **[GETTING_STARTED.md](../GETTING_STARTED.md)** - Beginner's complete guide
- **[SETUP.md](SETUP.md)** - Detailed installation instructions
- **[ARCHITECTURE.md](../ARCHITECTURE.md)** - How CD3 works internally
- **[QUICK_REFERENCE.md](QUICK_REFERENCE.md)** - Command cheat sheet
- **[CONTRIBUTING.md](../CONTRIBUTING.md)** - Extend CD3
- **[FINAL_FIX.md](../FINAL_FIX.md)** - ocicloud error deep dive

---

**Document Version**: 2.0  
**Last Updated**: 2026-01-12  
**Still stuck?** Run `./diagnose_cd3.sh` and open a GitHub issue with the output!
