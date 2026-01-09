# CD3 Toolkit Setup Scripts - Quick Reference

This directory contains comprehensive setup scripts and guides for installing CD3 Automation Toolkit **without Docker or Jenkins**.

## 📁 Files Overview

| File | Purpose | Platform |
|------|---------|----------|
| **SETUP_GUIDE_NO_DOCKER.md** | Complete step-by-step setup guide | Ubuntu, macOS, Windows |
| **quick_install_cd3.sh** | One-command automated installation | Ubuntu, macOS |
| **fix_https_errors.sh** | Diagnose and fix HTTPS/SSL issues | Ubuntu, macOS |
| **fix_https_errors.ps1** | Diagnose and fix HTTPS/SSL issues | Windows |

---

## 🚀 Quick Start

### For Ubuntu/macOS Users:

```bash
# Navigate to CD3 directory
cd /Users/pragadeeswarpa/Desktop/Personal_DevOps/CD3

# Run automated installation (recommended)
./quick_install_cd3.sh

# If you encounter HTTPS errors:
./fix_https_errors.sh
```

### For Windows Users (PowerShell):

```powershell
# Navigate to CD3 directory
cd C:\Users\YourUser\Desktop\Personal_DevOps\CD3

# Read the setup guide
notepad SETUP_GUIDE_NO_DOCKER.md

# If you encounter HTTPS errors:
.\fix_https_errors.ps1
```

---

## 📖 Detailed Setup Guide

The [SETUP_GUIDE_NO_DOCKER.md](SETUP_GUIDE_NO_DOCKER.md) contains:

### ✅ What's Covered:
- **Prerequisites** for all platforms
- **Ubuntu Setup** (complete walkthrough)
- **macOS Setup** (complete walkthrough)
- **Windows Setup** (complete walkthrough)
- **Common Issues & Solutions** (8+ issues covered)
  - HTTPS/SSL certificate errors
  - Python dependency conflicts
  - Permission issues
  - OCI CLI not found
  - Terraform provider downloads
  - Excel file read errors
  - Memory issues
- **Post-Installation Configuration**
- **Verification Steps**
- **Quick Start Workflows**

### 📝 Key Sections:

1. **System Dependencies**
   - Python 3.12 (or 3.10) installation
   - Git, Terraform 1.13+, build tools
   - Platform-specific requirements

2. **Python Environment**
   - Virtual environment setup
   - Dependency installation (specific versions)
   - Compatibility fixes for each OS

3. **OCI CLI Configuration**
   - API key generation
   - Config file setup
   - Key upload to OCI Console

4. **CD3 Configuration**
   - connectOCI.properties setup
   - setUpOCI.properties customization
   - Excel template download

5. **Troubleshooting**
   - Proxy configuration
   - Certificate issues
   - Network connectivity
   - Permission problems

---

## 🔧 HTTPS Error Troubleshooting

### When to Use:

If you encounter errors like:
- `SSLError: [SSL: CERTIFICATE_VERIFY_FAILED]`
- `Connection timeout to OCI API`
- `HTTPS connection failed`
- `Unable to verify SSL certificate`

### Linux/macOS:

```bash
./fix_https_errors.sh
```

**What it does:**
1. ✅ Updates CA certificates
2. ✅ Checks Python SSL support
3. ✅ Tests OCI API connectivity
4. ✅ Detects proxy settings
5. ✅ Fixes OCI CLI permissions
6. ✅ Tests OCI authentication
7. ✅ Validates Python HTTPS libraries
8. ✅ Creates config validator
9. ✅ Provides detailed recommendations

### Windows:

```powershell
.\fix_https_errors.ps1
```

**What it does:**
- Same checks as Linux/macOS version
- Windows-specific proxy detection
- PowerShell-friendly output
- Registry proxy checking
- Firewall testing

---

## 🎯 Automated Installation (Linux/macOS Only)

### What `quick_install_cd3.sh` Does:

```bash
./quick_install_cd3.sh
```

**Automated Steps:**

1. **Detects OS** - Identifies Ubuntu/macOS and package manager
2. **Installs System Dependencies**
   - Build tools
   - Python 3.9+
   - Git, wget, curl
   - CA certificates

3. **Installs Terraform 1.5.7**
   - Downloads from HashiCorp
   - Installs to /usr/local/bin
   - Verifies installation

4. **Creates Python Virtual Environment**
   - Clean venv in `cd3-automation-toolkit/cd3venv`
   - Activates environment
   - Upgrades pip

5. **Installs Python Dependencies**
   - All required packages (oci-cli, pandas, openpyxl, etc.)
   - Proper installation order to avoid conflicts
   - Pinned versions for stability

6. **Configures OCI CLI**
   - Interactive setup (optional)
   - Creates ~/.oci/config
   - Generates API key pair
   - Sets correct permissions

7. **Creates Example Configs**
   - connectOCI.properties.example
   - setUpOCI.properties.example

8. **Verifies Installation**
   - Tests Python, Terraform, OCI CLI
   - Checks OCI connectivity
   - Displays status

**Time Required:** 5-15 minutes (depending on internet speed)

---

## 🐛 Common Issues Addressed

### 1. HTTPS Certificate Errors

**Problem:** SSL/TLS verification fails when connecting to OCI

**Solution:**
```bash
# Linux
sudo apt update && sudo apt install ca-certificates
sudo update-ca-certificates --fresh

# macOS
brew install ca-certificates openssl

# All platforms
export SSL_CERT_FILE=/etc/ssl/certs/ca-certificates.crt
export REQUESTS_CA_BUNDLE=/etc/ssl/certs/ca-certificates.crt
```

### 2. Corporate Proxy Issues

**Problem:** Behind corporate proxy, connections timeout

**Solution:**
```bash
# Linux/macOS
export HTTP_PROXY=http://proxy.company.com:8080
export HTTPS_PROXY=http://proxy.company.com:8080
export NO_PROXY=localhost,127.0.0.1,.oraclecloud.com

# Windows PowerShell
$env:HTTP_PROXY="http://proxy.company.com:8080"
$env:HTTPS_PROXY="http://proxy.company.com:8080"
```

### 3. Python Dependency Conflicts

**Problem:** numpy/pandas version conflicts

**Solution:**
```bash
# Create fresh environment
deactivate
rm -rf cd3venv
python3.9 -m venv cd3venv
source cd3venv/bin/activate

# Install in correct order
pip install numpy==1.26.4
pip install pandas==1.1.5
# ... rest of dependencies
```

### 4. OCI CLI Not Found

**Problem:** Command 'oci' not recognized after installation

**Solution:**
```bash
# Add to PATH
echo 'export PATH=$PATH:~/.local/bin' >> ~/.bashrc
source ~/.bashrc
```

### 5. Permission Denied

**Problem:** Cannot write to ~/.oci directory

**Solution:**
```bash
chmod 700 ~/.oci
chmod 600 ~/.oci/config
chmod 600 ~/.oci/oci_api_key.pem
```

---

## ✅ Verification Checklist

After installation, verify:

- [ ] Python 3.12 or 3.10 installed (`python3 --version`)
- [ ] Virtual environment activated
- [ ] Terraform 1.13+ installed (`terraform version`)
- [ ] OCI CLI installed (`oci --version`)
- [ ] OCI config exists (`cat ~/.oci/config`)
- [ ] API key uploaded to OCI Console
- [ ] Can list regions (`oci iam region list`)
- [ ] All Python packages installed (`pip list`)
- [ ] connectOCI.properties configured
- [ ] setUpOCI.properties configured
- [ ] CD3 Excel template downloaded

---

## 📊 Installation Matrix

| Component | Ubuntu | macOS | Windows | Required |
|-----------|--------|-------|---------|----------|
| Python 3.12/3.10 | ✅ | ✅ | ✅ | Yes |
| Git | ✅ | ✅ | ✅ | Yes |
| Terraform 1.13+ | ✅ | ✅ | ✅ | Yes |
| OCI CLI | ✅ | ✅ | ✅ | Yes |
| Virtual Env | ✅ | ✅ | ✅ | Recommended |
| Build Tools | ✅ | ✅ | ✅ | Yes |
| Docker | ❌ | ❌ | ❌ | No |
| Jenkins | ❌ | ❌ | ❌ | No |

---

## 🔗 Quick Links

### Documentation
- **Setup Guide**: [SETUP_GUIDE_NO_DOCKER.md](SETUP_GUIDE_NO_DOCKER.md)
- **CD3 GitHub**: https://github.com/oracle-devrel/cd3-automation-toolkit
- **OCI Documentation**: https://docs.oracle.com/en-us/iaas/Content/home.htm

### Downloads
- **Python**: https://www.python.org/downloads/
- **Git**: https://git-scm.com/downloads
- **Terraform**: https://releases.hashicorp.com/terraform/1.5.7/
- **CD3 Templates**: https://github.com/oracle-devrel/cd3-automation-toolkit/releases

### Support
- **GitHub Issues**: https://github.com/oracle-devrel/cd3-automation-toolkit/issues
- **OCI Support**: https://support.oracle.com/

---

## 💡 Tips & Best Practices

### 1. Use Virtual Environment
Always activate the virtual environment before running CD3:
```bash
source cd3venv/bin/activate
```

### 2. Create Aliases
Add to `~/.bashrc` or `~/.zshrc`:
```bash
alias cd3='cd ~/Desktop/Personal_DevOps/CD3/cd3-automation-toolkit/cd3_automation_toolkit && source ../cd3venv/bin/activate && python setUpOCI.py'
```

### 3. Keep Dependencies Updated
```bash
pip install --upgrade oci-cli
```

### 4. Secure Your Keys
- Never commit `.oci/` directory to git
- Keep private keys with 600 permissions
- Rotate API keys regularly
- Enable MFA on OCI account

### 5. Test Before Production
- Use a test compartment first
- Validate Terraform plans carefully
- Keep backups of existing infrastructure

### 6. Use Remote State
Configure in setUpOCI.properties:
```properties
use_remote_state=yes
remote_state_bucket_name=mybucket
```

---

## 🆘 Getting Help

### If Installation Fails:

1. **Read error messages carefully** - they often indicate the exact issue
2. **Run diagnostics**: `./fix_https_errors.sh` (or .ps1 for Windows)
3. **Check the setup guide** for your specific OS
4. **Verify prerequisites** are met
5. **Check network connectivity** to OCI API
6. **Search GitHub issues** for similar problems

### If CD3 Doesn't Work:

1. **Validate OCI config**:
   ```bash
   python ~/.oci/validate_config.py
   ```

2. **Test OCI connectivity**:
   ```bash
   oci iam region list
   ```

3. **Check Python environment**:
   ```bash
   which python
   pip list | grep oci
   ```

4. **Enable debug mode**:
   ```bash
   export OCI_CLI_DEBUG=true
   ```

---

## 📅 Maintenance

### Regular Updates

```bash
# Activate environment
source cd3venv/bin/activate

# Update CD3 toolkit
cd cd3-automation-toolkit
git pull origin main

# Update Python packages
pip install --upgrade oci-cli pandas openpyxl

# Update Terraform
# Download latest from HashiCorp
```

### Backup Configuration

```bash
# Backup OCI config
cp -r ~/.oci ~/.oci.backup

# Backup CD3 properties
cp connectOCI.properties connectOCI.properties.backup
cp setUpOCI.properties setUpOCI.properties.backup
```

---

## 🎓 Learning Resources

### For Beginners:
1. Start with SETUP_GUIDE_NO_DOCKER.md
2. Follow Ubuntu/macOS/Windows section step-by-step
3. Read "Common Issues & Solutions"
4. Run verification steps

### For Advanced Users:
1. Use quick_install_cd3.sh for rapid setup
2. Customize outdir_structure_file.properties
3. Integrate with CI/CD pipelines
4. Use remote state and Git integration

### For Troubleshooting:
1. Run fix_https_errors script first
2. Check specific error in setup guide
3. Review OCI logs: ~/.oci/logs/
4. Enable debug mode for detailed output

---

## 📋 Summary

| Use Case | Script/Guide | Time |
|----------|-------------|------|
| **First-time setup (Ubuntu/macOS)** | `./quick_install_cd3.sh` | 10-15 min |
| **First-time setup (Windows)** | Follow SETUP_GUIDE_NO_DOCKER.md | 20-30 min |
| **HTTPS issues** | `./fix_https_errors.sh` or `.ps1` | 2-5 min |
| **Detailed instructions** | Read SETUP_GUIDE_NO_DOCKER.md | 15 min |
| **Troubleshooting** | Check "Common Issues" in guide | Varies |

---

## ✨ What Makes These Scripts Different

### Compared to Docker Setup:
- ✅ **No Docker overhead** - runs natively
- ✅ **Faster startup** - no container initialization
- ✅ **Easier debugging** - direct access to logs
- ✅ **Lower resource usage** - no containerization
- ✅ **Simpler updates** - standard pip/git workflow

### Compared to Manual Setup:
- ✅ **Automated** - one command installation
- ✅ **Error handling** - built-in checks
- ✅ **Comprehensive** - handles all dependencies
- ✅ **Verified** - tests connectivity
- ✅ **Documented** - detailed guide included

### Advantages:
- ✅ **No Jenkins dependency** - use CD3 directly
- ✅ **Cross-platform** - Ubuntu, macOS, Windows
- ✅ **Production-ready** - pinned versions
- ✅ **Troubleshooting built-in** - HTTPS fix script
- ✅ **Security-focused** - proper permissions

---

## 🔐 Security Notes

1. **Never commit credentials**
   - Add `.oci/` to .gitignore
   - Never share private keys
   - Don't log API keys

2. **File Permissions**
   ```bash
   chmod 700 ~/.oci
   chmod 600 ~/.oci/config
   chmod 600 ~/.oci/oci_api_key.pem
   ```

3. **Use Instance Principals** (when in OCI)
   ```properties
   auth_mechanism=instance_principal
   ```

4. **Rotate Keys Regularly**
   - Generate new API keys every 90 days
   - Remove old keys from OCI Console

5. **Enable MFA**
   - Add multi-factor authentication to OCI account
   - Use hardware security keys if possible

---

**Last Updated:** 2026-01-09
**Compatible With:** CD3 Automation Toolkit (latest)
**Tested On:** Ubuntu 20.04/22.04, macOS Monterey/Ventura, Windows 10/11

---

**Questions or Issues?**

1. Check SETUP_GUIDE_NO_DOCKER.md
2. Run diagnostic scripts
3. Open GitHub issue: https://github.com/oracle-devrel/cd3-automation-toolkit/issues

**Happy Automating! 🚀**
