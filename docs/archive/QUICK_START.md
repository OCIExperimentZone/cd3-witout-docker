# CD3 Toolkit - Quick Start Guide (No Docker/Jenkins)

**Choose your platform and follow the steps below:**

---

## 🐧 Ubuntu / Linux

### Option 1: Automated Installation (Recommended)

```bash
cd ~/Desktop/Personal_DevOps/CD3
./quick_install_cd3.sh
```

### Option 2: Manual Installation

```bash
# 1. Install dependencies
sudo apt update
sudo apt install -y python3.12 python3.12-venv python3-pip git wget curl build-essential || \
sudo apt install -y python3.10 python3.10-venv python3-pip git wget curl build-essential

# 2. Install Terraform
wget https://releases.hashicorp.com/terraform/1.13.0/terraform_1.13.0_linux_amd64.zip
unzip terraform_1.13.0_linux_amd64.zip
sudo mv terraform /usr/local/bin/

# 3. Create virtual environment
cd ~/Desktop/Personal_DevOps/CD3/cd3-automation-toolkit
python3.12 -m venv cd3venv || python3.10 -m venv cd3venv
source cd3venv/bin/activate

# 4. Install Python packages (Python 3.12 compatible)
pip install --upgrade pip
pip install numpy==1.26.4 pandas==2.0.3
pip install oci-cli==3.66.1 openpyxl==3.0.10 xlrd==1.2.0 \
    xlsxwriter==3.2.0 Jinja2==3.1.2 PyYAML==6.0.1 \
    pycryptodomex==3.10.1 requests==2.28.2 netaddr==0.8.0 \
    ipaddress==1.0.23 GitPython==3.1.40 regex==2022.10.31 \
    wget==3.2 cfgparse==1.3 simplejson==3.18.3

# 5. Configure OCI CLI
oci setup config

# 6. Upload public key to OCI Console
cat ~/.oci/oci_api_key_public.pem
# Copy and paste to: OCI Console > Profile > User Settings > API Keys
```

### If HTTPS Errors Occur:

```bash
./fix_https_errors.sh
```

---

## 🍎 macOS

### Option 1: Automated Installation (Recommended)

```bash
cd ~/Desktop/Personal_DevOps/CD3
./quick_install_cd3.sh
```

### Option 2: Manual Installation

```bash
# 1. Install Homebrew (if not installed)
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# 2. Install dependencies
brew install python@3.12 git wget || brew install python@3.10 git wget

# 3. Install Terraform
brew tap hashicorp/tap
brew install hashicorp/tap/terraform

# 4. Create virtual environment
cd ~/Desktop/Personal_DevOps/CD3/cd3-automation-toolkit
python3.12 -m venv cd3venv || python3.10 -m venv cd3venv
source cd3venv/bin/activate

# 5. Install Python packages (Python 3.12 compatible)
pip install --upgrade pip
pip install numpy==1.26.4 pandas==2.0.3
pip install oci-cli==3.66.1 openpyxl==3.0.10 xlrd==1.2.0 \
    xlsxwriter==3.2.0 Jinja2==3.1.2 PyYAML==6.0.1 \
    pycryptodomex==3.10.1 requests==2.28.2 netaddr==0.8.0 \
    ipaddress==1.0.23 GitPython==3.1.40 regex==2022.10.31 \
    wget==3.2 cfgparse==1.3 simplejson==3.18.3

# 6. Configure OCI CLI
oci setup config

# 7. Upload public key to OCI Console
cat ~/.oci/oci_api_key_public.pem
```

### If HTTPS Errors Occur:

```bash
./fix_https_errors.sh
```

---

## 🪟 Windows

### Manual Installation (PowerShell as Administrator)

```powershell
# 1. Install Python 3.12 (or 3.10) from python.org
# Download: https://www.python.org/downloads/
# IMPORTANT: Check "Add Python to PATH" during installation

# 2. Install Git
# Download: https://git-scm.com/download/win

# 3. Install Terraform
# Download: https://releases.hashicorp.com/terraform/1.13.0/terraform_1.13.0_windows_amd64.zip
# Extract to C:\Program Files\Terraform
# Add to PATH: System Properties > Environment Variables > Path

# 4. Install Visual C++ Build Tools (if needed)
# Download: https://visualstudio.microsoft.com/visual-cpp-build-tools/

# 5. Create virtual environment
cd C:\Users\YourUser\Desktop\Personal_DevOps\CD3\cd3-automation-toolkit
python -m venv cd3venv
.\cd3venv\Scripts\activate

# 6. Install Python packages (Python 3.12 compatible)
pip install --upgrade pip
pip install numpy==1.26.4 pandas==2.0.3
pip install oci-cli==3.66.1 openpyxl==3.0.10 xlrd==1.2.0 `
    xlsxwriter==3.2.0 Jinja2==3.1.2 PyYAML==6.0.1 `
    pycryptodomex==3.10.1 requests==2.28.2 netaddr==0.8.0 `
    ipaddress==1.0.23 GitPython==3.1.40 regex==2022.10.31 `
    wget==3.2 cfgparse==1.3 simplejson==3.18.3

# 7. Configure OCI CLI
oci setup config

# 8. Upload public key to OCI Console
type C:\Users\YourUser\.oci\oci_api_key_public.pem
```

### If HTTPS Errors Occur:

```powershell
.\fix_https_errors.ps1
```

---

## ⚙️ Post-Installation Configuration

### 1. Configure OCI Connection

Edit `cd3-automation-toolkit/cd3_automation_toolkit/connectOCI.properties`:

```properties
tenancy_ocid=ocid1.tenancy.oc1..aaaaaaaxxxxxx
user_ocid=ocid1.user.oc1..aaaaaaaxxxxxx
region=us-ashburn-1
key_path=~/.oci/oci_api_key.pem
fingerprint=xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx
auth_mechanism=api_key
```

### 2. Configure CD3 Setup

Edit `cd3-automation-toolkit/cd3_automation_toolkit/setUpOCI.properties`:

```properties
outdir=/path/to/terraform/output
prefix=mycompany
cd3file=/path/to/CD3-Template.xlsx
workflow_type=create_resources
tf_or_tofu=terraform
use_remote_state=no
use_oci_devops_git=no
```

### 3. Download Excel Template

```bash
# Linux/macOS
wget https://github.com/oracle-devrel/cd3-automation-toolkit/releases/latest/download/CD3-Blank-Template.xlsx

# Windows (PowerShell)
Invoke-WebRequest -Uri "https://github.com/oracle-devrel/cd3-automation-toolkit/releases/latest/download/CD3-Blank-Template.xlsx" -OutFile "CD3-Blank-Template.xlsx"
```

---

## 🚀 Running CD3 Toolkit

### Linux/macOS:

```bash
cd ~/Desktop/Personal_DevOps/CD3/cd3-automation-toolkit/cd3_automation_toolkit
source ../cd3venv/bin/activate
python setUpOCI.py
```

### Windows:

```powershell
cd C:\Users\YourUser\Desktop\Personal_DevOps\CD3\cd3-automation-toolkit\cd3_automation_toolkit
..\cd3venv\Scripts\activate
python setUpOCI.py
```

---

## 🎯 CD3 Workflow Options

When you run `python setUpOCI.py`, you'll see:

```
============================================
         CD3 Automation Toolkit
============================================
1. Validate CD3 Excel Template
2. Generate Terraform files from CD3 Excel (Create Resources)
3. Export existing OCI resources to CD3 Excel
4. Add/Modify/Delete Resources
...
```

### For New Infrastructure:
1. Fill in Excel template with desired resources
2. Select option **2** - Generate Terraform files
3. CD3 creates Terraform modules in output directory
4. Run: `terraform init && terraform plan && terraform apply`

### For Existing Infrastructure:
1. Select option **3** - Export existing resources
2. CD3 generates Excel with current OCI state
3. Review and modify as needed
4. Use for documentation or recreation

---

## ✅ Verification Steps

```bash
# Test Python
python --version  # Should show 3.12 or 3.10

# Test Terraform
terraform version  # Should show 1.13+

# Test OCI CLI
oci --version

# Test OCI connectivity
oci iam region list

# Test OCI authentication
oci iam availability-domain list --compartment-id <your-tenancy-ocid>
```

---

## 🐛 Troubleshooting

### Issue: SSL/HTTPS Errors

**Symptom:** `SSLError: [SSL: CERTIFICATE_VERIFY_FAILED]`

**Solution:**
```bash
# Linux/macOS
./fix_https_errors.sh

# Windows
.\fix_https_errors.ps1
```

### Issue: OCI CLI Not Found

**Symptom:** `command not found: oci`

**Solution:**
```bash
# Linux/macOS - Add to PATH
echo 'export PATH=$PATH:~/.local/bin' >> ~/.bashrc
source ~/.bashrc

# Windows - Check Python Scripts in PATH
# C:\Users\YourUser\AppData\Local\Programs\Python\Python39\Scripts
```

### Issue: Permission Denied

**Symptom:** Cannot access ~/.oci/config

**Solution:**
```bash
chmod 700 ~/.oci
chmod 600 ~/.oci/config
chmod 600 ~/.oci/oci_api_key.pem
```

### Issue: Python Package Conflicts

**Symptom:** numpy/pandas version errors

**Solution:**
```bash
deactivate
rm -rf cd3venv
python3.9 -m venv cd3venv
source cd3venv/bin/activate
pip install numpy==1.26.4  # Install numpy first
pip install pandas==1.1.5  # Then pandas
# ... rest of packages
```

### Issue: Corporate Proxy

**Symptom:** Connection timeouts

**Solution:**
```bash
# Linux/macOS
export HTTP_PROXY=http://proxy.company.com:8080
export HTTPS_PROXY=http://proxy.company.com:8080
export NO_PROXY=localhost,127.0.0.1,.oraclecloud.com

# Windows
$env:HTTP_PROXY="http://proxy.company.com:8080"
$env:HTTPS_PROXY="http://proxy.company.com:8080"
```

---

## 📚 Additional Resources

| Resource | Link |
|----------|------|
| **Detailed Setup Guide** | [SETUP_GUIDE_NO_DOCKER.md](SETUP_GUIDE_NO_DOCKER.md) |
| **Scripts Documentation** | [README_SETUP_SCRIPTS.md](README_SETUP_SCRIPTS.md) |
| **CD3 GitHub** | https://github.com/oracle-devrel/cd3-automation-toolkit |
| **OCI Documentation** | https://docs.oracle.com/en-us/iaas/Content/home.htm |
| **Terraform OCI Provider** | https://registry.terraform.io/providers/oracle/oci/latest/docs |

---

## 🎓 Next Steps

1. ✅ **Complete installation** using automated or manual method
2. ✅ **Configure OCI credentials** (connectOCI.properties)
3. ✅ **Download Excel template** from GitHub releases
4. ✅ **Fill in template** with your infrastructure requirements
5. ✅ **Run CD3 toolkit** to generate Terraform
6. ✅ **Review generated code** in output directory
7. ✅ **Apply infrastructure** using Terraform

---

## 💡 Pro Tips

### Create an Alias (Linux/macOS)

Add to `~/.bashrc` or `~/.zshrc`:

```bash
alias cd3='cd ~/Desktop/Personal_DevOps/CD3/cd3-automation-toolkit/cd3_automation_toolkit && source ../cd3venv/bin/activate && python setUpOCI.py'
```

Then just run: `cd3`

### Create a Batch File (Windows)

Create `cd3.bat` in a directory in your PATH:

```batch
@echo off
cd C:\Users\YourUser\Desktop\Personal_DevOps\CD3\cd3-automation-toolkit\cd3_automation_toolkit
call ..\cd3venv\Scripts\activate
python setUpOCI.py
```

Then just run: `cd3`

### Keep Virtual Environment Active

Create a new terminal profile that auto-activates:

```bash
# Linux/macOS - add to profile
cd ~/Desktop/Personal_DevOps/CD3/cd3-automation-toolkit
source cd3venv/bin/activate
```

---

## 🔒 Security Best Practices

1. ✅ **Never commit** `.oci/` directory to version control
2. ✅ **Keep private keys secure** with 600 permissions
3. ✅ **Rotate API keys** every 90 days
4. ✅ **Enable MFA** on OCI account
5. ✅ **Use instance principals** when running in OCI compute
6. ✅ **Review generated Terraform** before applying
7. ✅ **Use remote state** for team collaboration
8. ✅ **Backup configurations** regularly

---

## 🆘 Getting Help

### If Something Goes Wrong:

1. **Read error messages carefully**
2. **Run diagnostics:** `./fix_https_errors.sh` (or .ps1)
3. **Check:** [SETUP_GUIDE_NO_DOCKER.md](SETUP_GUIDE_NO_DOCKER.md) "Common Issues" section
4. **Verify:** All prerequisites are installed correctly
5. **Test:** OCI connectivity with `oci iam region list`
6. **Search:** GitHub issues for similar problems
7. **Ask:** Open new issue on GitHub with error details

### Debug Mode:

```bash
# Enable OCI CLI debug
export OCI_CLI_DEBUG=true
oci iam region list

# Enable Python logging
python -c "import logging; logging.basicConfig(level=logging.DEBUG)"
```

---

## 📊 Time Estimates

| Task | Ubuntu/macOS | Windows |
|------|--------------|---------|
| **Automated Install** | 10-15 min | N/A |
| **Manual Install** | 20-30 min | 30-45 min |
| **OCI Configuration** | 5-10 min | 5-10 min |
| **First Run** | 2-5 min | 2-5 min |
| **HTTPS Troubleshooting** | 5-10 min | 5-10 min |

---

## ✨ What You Get

- ✅ **No Docker** - Native installation
- ✅ **No Jenkins** - Direct Python execution
- ✅ **Cross-platform** - Ubuntu, macOS, Windows
- ✅ **Production-ready** - Pinned package versions
- ✅ **Automated** - One-command setup (Linux/macOS)
- ✅ **Comprehensive** - Full troubleshooting guides
- ✅ **Tested** - Verification at every step
- ✅ **Secure** - Proper permissions and best practices

---

**Ready to Start?**

Choose your platform above and follow the steps!

For detailed instructions, see: [SETUP_GUIDE_NO_DOCKER.md](SETUP_GUIDE_NO_DOCKER.md)

**Questions?** Check [README_SETUP_SCRIPTS.md](README_SETUP_SCRIPTS.md)

---

**Last Updated:** 2026-01-09
**Version:** 1.0
**Tested On:** Ubuntu 20.04/22.04, macOS Monterey/Ventura, Windows 10/11
