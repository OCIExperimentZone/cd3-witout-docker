# CD3 Toolkit Setup Guide

Complete guide to install and configure CD3 Automation Toolkit without Docker.

## Quick Start

### Automated Installation (Recommended)

**Linux/macOS:**
```bash
cd ~/Desktop/Personal_DevOps/CD3
./quick_install_cd3.sh
```

**Estimated time:** 10-15 minutes

### What Gets Installed
- Python 3.12 or 3.10
- Terraform 1.13+
- OCI CLI 3.66+
- All required Python packages
- Virtual environment setup

---

## Manual Installation

### Prerequisites
- Python 3.12 or 3.10
- Git
- 2GB free disk space
- Internet connection
- OCI account with API access

### Ubuntu/Linux

```bash
# Install dependencies
sudo apt update
sudo apt install -y python3.12 python3.12-venv python3-pip git wget

# Install Terraform
wget https://releases.hashicorp.com/terraform/1.13.0/terraform_1.13.0_linux_amd64.zip
unzip terraform_1.13.0_linux_amd64.zip
sudo mv terraform /usr/local/bin/

# Create virtual environment
cd ~/Desktop/Personal_DevOps/CD3/cd3-automation-toolkit
python3.12 -m venv cd3venv
source cd3venv/bin/activate

# Install Python packages
pip install --upgrade pip
pip install numpy==1.26.4 pandas==2.0.3
pip install oci-cli==3.66.1 openpyxl==3.0.10 xlrd==1.2.0 \
    xlsxwriter==3.2.0 Jinja2==3.1.2 PyYAML==6.0.1 \
    pycryptodomex==3.10.1 requests==2.28.2 netaddr==0.8.0 \
    ipaddress==1.0.23 GitPython==3.1.40 regex==2022.10.31 \
    wget==3.2 cfgparse==1.3 simplejson==3.18.3

# Configure OCI CLI
oci setup config
```

### macOS

```bash
# Install Homebrew (if not installed)
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Install dependencies
brew install python@3.12 git wget
brew tap hashicorp/tap
brew install hashicorp/tap/terraform

# Create virtual environment
cd ~/Desktop/Personal_DevOps/CD3/cd3-automation-toolkit
python3.12 -m venv cd3venv
source cd3venv/bin/activate

# Install Python packages
pip install --upgrade pip
pip install numpy==1.26.4 pandas==2.0.3
pip install oci-cli==3.66.1 openpyxl==3.0.10 xlrd==1.2.0 \
    xlsxwriter==3.2.0 Jinja2==3.1.2 PyYAML==6.0.1 \
    pycryptodomex==3.10.1 requests==2.28.2 netaddr==0.8.0 \
    ipaddress==1.0.23 GitPython==3.1.40 regex==2022.10.31 \
    wget==3.2 cfgparse==1.3 simplejson==3.18.3

# Configure OCI CLI
oci setup config
```

### Windows

```powershell
# Install Python 3.12 from python.org
# Download: https://www.python.org/downloads/
# Check "Add Python to PATH" during installation

# Install Git from: https://git-scm.com/download/win
# Install Terraform from: https://www.terraform.io/downloads

# Create virtual environment
cd C:\Users\YourUser\Desktop\Personal_DevOps\CD3\cd3-automation-toolkit
python -m venv cd3venv
.\cd3venv\Scripts\activate

# Install Python packages
pip install --upgrade pip
pip install numpy==1.26.4 pandas==2.0.3
pip install oci-cli==3.66.1 openpyxl==3.0.10 xlrd==1.2.0 `
    xlsxwriter==3.2.0 Jinja2==3.1.2 PyYAML==6.0.1 `
    pycryptodomex==3.10.1 requests==2.28.2 netaddr==0.8.0 `
    ipaddress==1.0.23 GitPython==3.1.40 regex==2022.10.31 `
    wget==3.2 cfgparse==1.3 simplejson==3.18.3

# Configure OCI CLI
oci setup config
```

---

## Configuration

### 1. OCI API Key Setup

During `oci setup config`, you'll need:
- **Tenancy OCID** (from OCI Console > Profile > Tenancy)
- **User OCID** (from OCI Console > Profile > User Settings)
- **Region** (e.g., us-ashburn-1)

The CLI will generate an API key pair at `~/.oci/`

### 2. Upload Public Key to OCI

```bash
# Display your public key
cat ~/.oci/oci_api_key_public.pem
```

Then:
1. Go to OCI Console > Profile Icon > User Settings
2. Click "API Keys" > "Add API Key"
3. Paste your public key
4. Click "Add"

### 3. Configure CD3 Properties

Edit `cd3-automation-toolkit/cd3_automation_toolkit/connectOCI.properties`:

```properties
tenancy_ocid=ocid1.tenancy.oc1..aaaaaaaxxxxxx
user_ocid=ocid1.user.oc1..aaaaaaaxxxxxx
region=us-ashburn-1
key_path=~/.oci/oci_api_key.pem
fingerprint=xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx
auth_mechanism=api_key
```

Edit `setUpOCI.properties`:

```properties
outdir=/path/to/terraform/output
prefix=mycompany
cd3file=/path/to/CD3-Template.xlsx
workflow_type=create_resources
tf_or_tofu=terraform
```

### 4. Download Excel Template

```bash
wget https://github.com/oracle-devrel/cd3-automation-toolkit/releases/latest/download/CD3-Blank-Template.xlsx
```

---

## Running CD3

```bash
# Activate virtual environment
source ~/Desktop/Personal_DevOps/CD3/cd3-automation-toolkit/cd3venv/bin/activate

# Navigate to CD3 directory
cd ~/Desktop/Personal_DevOps/CD3/cd3-automation-toolkit/cd3_automation_toolkit

# Run CD3
python setUpOCI.py
```

---

## Verification

Test your installation:

```bash
# Check versions
python --version        # Should show 3.12 or 3.10
terraform version       # Should show 1.13+
oci --version          # Should show 3.66+

# Test OCI connectivity
oci iam region list

# Run verification script
./verify_versions.sh   # Linux/macOS only
```

---

## Troubleshooting

### Common Issues

**ModuleNotFoundError: No module named 'ocicloud'**

Ensure you're in the correct directory and virtual environment is activated:
```bash
source ~/Desktop/Personal_DevOps/CD3/cd3-automation-toolkit/cd3venv/bin/activate
cd ~/Desktop/Personal_DevOps/CD3/cd3-automation-toolkit/cd3_automation_toolkit
python3 setUpOCI.py
```

**SSL/HTTPS Errors**

```bash
# Linux/macOS
./fix_https_errors.sh

# Windows
.\fix_https_errors.ps1
```

**OCI Connection Issues**

```bash
# Check config file
cat ~/.oci/config

# Test authentication
oci iam region list

# Fix permissions
chmod 600 ~/.oci/oci_api_key.pem
```

**Python Package Conflicts**

```bash
# Recreate virtual environment
deactivate
rm -rf cd3venv
python3.12 -m venv cd3venv
source cd3venv/bin/activate
pip install --upgrade pip
# Reinstall packages
```

### More Help

See [TROUBLESHOOTING.md](TROUBLESHOOTING.md) for detailed solutions to common issues.

---

## Usage Workflow

### Create New Infrastructure

1. Fill in CD3 Excel template with desired resources
2. Run: `python setUpOCI.py`
3. Select: "2. Generate Terraform files"
4. Review generated Terraform code
5. Apply: `cd output && terraform init && terraform plan && terraform apply`

### Document Existing Infrastructure

1. Run: `python setUpOCI.py`
2. Select: "3. Export existing OCI resources"
3. CD3 generates Excel with current state
4. Use for documentation or recreation

---

## Resources

- **CD3 GitHub:** https://github.com/oracle-devrel/cd3-automation-toolkit
- **OCI Documentation:** https://docs.oracle.com/en-us/iaas/Content/home.htm
- **Terraform OCI Provider:** https://registry.terraform.io/providers/oracle/oci/latest/docs

---

## Support

For issues:
1. Check troubleshooting section above
2. See [archived documentation](archive/) for detailed guides
3. GitHub Issues: https://github.com/oracle-devrel/cd3-automation-toolkit/issues
