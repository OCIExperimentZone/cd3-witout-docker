# CD3 Troubleshooting Guide

## Common Issues and Solutions

### ModuleNotFoundError: No module named 'ocicloud'

**Error Message:**
```
Traceback (most recent call last):
  File ".../createTenancyConfig.py", line 23, in <module>
    from ocicloud.python.ociCommonTools import *
ModuleNotFoundError: No module named 'ocicloud'
```

**Cause:** The CD3 toolkit directory is not in the Python path, or the virtual environment is not properly activated.

**Solution 1: Ensure Virtual Environment is Activated**

```bash
# Check if virtual environment is active
which python3
# Should show: .../cd3venv/bin/python3

# If not active, activate it
source ~/Desktop/Personal_DevOps/CD3/cd3-automation-toolkit/cd3venv/bin/activate

# Verify activation
which python3
python3 --version
```

**Solution 2: Run from Correct Directory**

The CD3 toolkit must be run from the `cd3_automation_toolkit` directory:

```bash
# Navigate to correct directory
cd ~/Desktop/Personal_DevOps/CD3/cd3-automation-toolkit/cd3_automation_toolkit

# Verify ocicloud exists
ls -la ocicloud/

# Run CD3
python3 connectCloud.py oci connectOCI.properties
```

**Solution 3: Set PYTHONPATH (If needed)**

If the above doesn't work, manually add the CD3 directory to Python path:

```bash
export PYTHONPATH="${PYTHONPATH}:/path/to/cd3-automation-toolkit/cd3_automation_toolkit"

# For WSL:
export PYTHONPATH="${PYTHONPATH}:/home/pragadeeswar/cd3-without-docker/cd3-automation-toolkit/cd3_automation_toolkit"

# For macOS (your local):
export PYTHONPATH="${PYTHONPATH}:~/Desktop/Personal_DevOps/CD3/cd3-automation-toolkit/cd3_automation_toolkit"
```

**Solution 4: Install CD3 as Package (Advanced)**

```bash
cd ~/Desktop/Personal_DevOps/CD3/cd3-automation-toolkit/cd3_automation_toolkit
pip install -e .
```

**WSL-Specific Fix:**

Your error shows you're in WSL. Make sure:

1. Virtual environment is activated:
```bash
source /home/pragadeeswar/cd3-without-docker/cd3-automation-toolkit/cd3venv/bin/activate
```

2. You're in the correct directory:
```bash
cd /home/pragadeeswar/cd3-without-docker/cd3-automation-toolkit/cd3_automation_toolkit
```

3. Run the command:
```bash
python3 connectCloud.py oci connectOCI.properties
# OR
python3 setUpOCI.py
```

---

## SSL/HTTPS Errors

**Error:** `SSLError: [SSL: CERTIFICATE_VERIFY_FAILED]`

**Solution:**
```bash
# Linux/macOS
./fix_https_errors.sh

# Windows
.\fix_https_errors.ps1

# Manual fix
pip install --upgrade certifi
export SSL_CERT_FILE=$(python -m certifi)
```

---

## OCI Connection Errors

**Error:** `ServiceError: Authorization failed or requested resource not found`

**Solutions:**

1. **Check API Key Configuration:**
```bash
cat ~/.oci/config
```

Should contain:
```
[DEFAULT]
user=ocid1.user.oc1..xxx
fingerprint=xx:xx:xx:xx...
tenancy=ocid1.tenancy.oc1..xxx
region=us-ashburn-1
key_file=/home/user/.oci/oci_api_key.pem
```

2. **Verify Key Permissions:**
```bash
chmod 600 ~/.oci/oci_api_key.pem
chmod 600 ~/.oci/config
```

3. **Test OCI Connectivity:**
```bash
oci iam region list
```

4. **Upload Public Key to OCI Console:**
```bash
cat ~/.oci/oci_api_key_public.pem
```
Then add it in OCI Console → Profile → User Settings → API Keys

---

## Python Version Issues

**Error:** `pandas/numpy compatibility errors`

**Solution:**
```bash
# Use Python 3.12 or 3.10 (not 3.13 or 3.9)
python3.12 --version || python3.10 --version

# Recreate virtual environment with correct version
deactivate
rm -rf cd3venv
python3.12 -m venv cd3venv
source cd3venv/bin/activate

# Install compatible packages
pip install --upgrade pip
pip install numpy==1.26.4 pandas==2.0.3
pip install oci-cli==3.66.1 openpyxl==3.0.10 xlrd==1.2.0 \
    xlsxwriter==3.2.0 Jinja2==3.1.2 PyYAML==6.0.1 \
    pycryptodomex==3.10.1 requests==2.28.2 netaddr==0.8.0 \
    ipaddress==1.0.23 GitPython==3.1.40 regex==2022.10.31 \
    wget==3.2 cfgparse==1.3 simplejson==3.18.3
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

## Getting Help

If you're still stuck:

1. **Check logs:**
   ```bash
   # OCI CLI logs
   cat ~/.oci/logs/oci_cli.log

   # CD3 output logs (if any)
   cat outdir/logs/*.log
   ```

2. **Gather system info:**
   ```bash
   python3 --version
   terraform version
   oci --version
   which python3
   echo $PYTHONPATH
   env | grep -i proxy
   ```

3. **Search GitHub Issues:**
   https://github.com/oracle-devrel/cd3-automation-toolkit/issues

4. **Ask for help with details:**
   - Full error message
   - Steps you took
   - Output of verification commands above
   - Operating system and version
