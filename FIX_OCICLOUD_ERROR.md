# Fix for "ModuleNotFoundError: No module named 'ocicloud'"

## The Problem

You're getting this error:
```
ModuleNotFoundError: No module named 'ocicloud'
```

## Root Causes

There are **TWO** issues causing this error:

### Issue 1: Missing Python Packages (PRIMARY CAUSE)
The virtual environment (`cd3venv`) doesn't have the OCI SDK and other required packages installed.

### Issue 2: Wrong Directory
Running CD3 scripts from the wrong directory prevents Python from finding the `ocicloud` module.

---

## Solution: Complete Fix

### Step 1: Install All Required Packages

Run this command on your **LOCAL MACHINE** (macOS):

```bash
cd ~/Desktop/Personal_DevOps/CD3/cd3-automation-toolkit
source cd3venv/bin/activate

# Install core packages first
pip install --upgrade pip
pip install numpy==1.26.4 pandas==2.0.3

# Install all CD3 dependencies
pip install oci-cli==3.66.1 openpyxl==3.0.10 xlrd==1.2.0 \
    xlsxwriter==3.2.0 Jinja2==3.1.2 PyYAML==6.0.1 \
    pycryptodomex==3.10.1 requests==2.28.2 netaddr==0.8.0 \
    ipaddress==1.0.23 GitPython==3.1.40 regex==2022.10.31 \
    wget==3.2 cfgparse==1.3 simplejson==3.18.3
```

### Step 2: Verify Installation

```bash
# Check if OCI is installed
pip list | grep oci

# Should show:
# oci              2.x.x
# oci-cli          3.66.1
```

### Step 3: Use the Helper Script

I've created `run_cd3.sh` for you. Just run:

```bash
cd ~/Desktop/Personal_DevOps/CD3
./run_cd3.sh
```

This script:
- ✓ Activates virtual environment automatically
- ✓ Changes to the correct directory
- ✓ Sets up PYTHONPATH correctly
- ✓ Runs CD3

---

## For WSL (Your Error Location) - MOST IMPORTANT!

Your WSL virtual environment does NOT have any packages installed. This is why you're getting the error.

### Step 1: Install Packages in WSL (CRITICAL!)

Run these commands **IN WSL** (not on your Mac):

```bash
# Go to CD3 directory
cd /home/pragadeeswar/cd3-without-docker/cd3-automation-toolkit

# Activate virtual environment (you should see (cd3venv) in your prompt)
source cd3venv/bin/activate

# Verify you're in the virtual environment
which python3
# Should show: /home/pragadeeswar/cd3-without-docker/cd3-automation-toolkit/cd3venv/bin/python3

# Upgrade pip first
pip install --upgrade pip

# Install core packages (this takes ~5 minutes)
pip install numpy==1.26.4 pandas==2.0.3

# Install all CD3 dependencies (this takes ~10 minutes)
pip install oci-cli==3.66.1 openpyxl==3.0.10 xlrd==1.2.0 \
    xlsxwriter==3.2.0 Jinja2==3.1.2 PyYAML==6.0.1 \
    pycryptodomex==3.10.1 requests==2.28.2 netaddr==0.8.0 \
    ipaddress==1.0.23 GitPython==3.1.40 regex==2022.10.31 \
    wget==3.2 cfgparse==1.3 simplejson==3.18.3
```

**Wait for all packages to finish installing before proceeding!**

### Step 2: Verify Installation

```bash
# Check if packages are installed
pip list | grep -i oci

# You should see:
# oci              2.x.x
# oci-cli          3.66.1

pip list | grep pandas
# You should see:
# pandas           2.0.3
```

### Step 3: Copy and Use the Helper Script

Copy the `run_cd3_wsl.sh` file to your WSL machine, then:

```bash
cd /home/pragadeeswar/cd3-without-docker
chmod +x run_cd3_wsl.sh
bash run_cd3_wsl.sh
```

### Step 3: Run CD3 in WSL

**Option A: Use the helper script (recommended)**
```bash
cd /home/pragadeeswar/cd3-without-docker
bash run_cd3_wsl.sh
```

**Option B: Manual commands**
```bash
cd /home/pragadeeswar/cd3-without-docker/cd3-automation-toolkit/cd3_automation_toolkit
source ../cd3venv/bin/activate
python3 setUpOCI.py
```

---

## Why This Happens

1. **Virtual Environment Not Complete**: The virtual environment was created but packages weren't installed
2. **Wrong Directory**: Running from parent directory instead of `cd3_automation_toolkit`
3. **Python Can't Find ocicloud**: The `ocicloud` module is local, not a pip package

---

## Quick Commands Reference

### Local (macOS)
```bash
# Quick run
cd ~/Desktop/Personal_DevOps/CD3
./run_cd3.sh

# Manual run
cd ~/Desktop/Personal_DevOps/CD3/cd3-automation-toolkit/cd3_automation_toolkit
source ../cd3venv/bin/activate
python3 setUpOCI.py
```

### WSL
```bash
# Quick run
cd /home/pragadeeswar/cd3-without-docker
bash run_cd3_wsl.sh

# Manual run
cd /home/pragadeeswar/cd3-without-docker/cd3-automation-toolkit/cd3_automation_toolkit
source ../cd3venv/bin/activate
python3 setUpOCI.py
```

---

## Verification Steps

After installing packages, verify everything works:

```bash
# 1. Activate environment
source cd3-automation-toolkit/cd3venv/bin/activate

# 2. Check Python packages
pip list | grep -E "oci|pandas|numpy"

# 3. Test ocicloud import
cd cd3-automation-toolkit/cd3_automation_toolkit
python3 -c "from ocicloud.python import ociCommonTools; print('Success!')"

# 4. Run CD3
python3 setUpOCI.py
```

---

## Still Not Working?

If you still get errors after installing packages:

### Check 1: Are you in a virtual environment?
```bash
which python3
# Should show: .../cd3venv/bin/python3
```

### Check 2: Are packages installed in the right place?
```bash
pip list | grep oci
# Should show oci and oci-cli
```

### Check 3: Are you in the correct directory?
```bash
pwd
# Should end with: .../cd3_automation_toolkit/cd3_automation_toolkit
```

### Check 4: Does ocicloud exist?
```bash
ls -la ocicloud/
# Should show __init__.py and python/ directory
```

---

## Alternative: Install from requirements.txt

If the CD3 toolkit has a requirements.txt:

```bash
cd ~/Desktop/Personal_DevOps/CD3/cd3-automation-toolkit
source cd3venv/bin/activate
pip install -r requirements.txt
```

---

## Summary

**The main issue**: Your virtual environment is missing the OCI Python SDK and other dependencies.

**The solution**:
1. Install all required packages (see Step 1 above)
2. Run CD3 from the correct directory
3. Use the helper scripts provided (`run_cd3.sh` or `run_cd3_wsl.sh`)

**After fixing**, you should be able to run:
```bash
./run_cd3.sh
```

And CD3 will work without errors!
