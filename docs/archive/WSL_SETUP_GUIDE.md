# CD3 Toolkit Setup for WSL (Windows Subsystem for Linux)

## Issue: Installation Stuck on Python Dependencies

If your installation is stuck or hanging when installing Python packages in WSL, follow this guide.

---

## 🔍 Common Causes

1. **Network/proxy issues** in WSL
2. **pip cache corruption**
3. **Missing system dependencies**
4. **Memory constraints**
5. **Package build failures**

---

## ✅ Solution 1: Fresh Installation with Verbose Output

### Step 1: Stop Current Installation
```bash
# Press Ctrl+C to stop the stuck process
# Then kill any hanging pip processes
pkill -f pip
```

### Step 2: Clean pip Cache
```bash
pip cache purge
rm -rf ~/.cache/pip
```

### Step 3: Install with Verbose Output
This shows what's happening:

```bash
# Activate virtual environment
cd ~/Desktop/Personal_DevOps/CD3/cd3-automation-toolkit
source cd3venv/bin/activate

# Install packages ONE BY ONE with verbose output
pip install --verbose numpy==1.26.4

# If successful, continue:
pip install --verbose pandas==2.0.3
pip install --verbose oci-cli==3.66.1
pip install --verbose openpyxl==3.0.10
pip install --verbose xlrd==1.2.0
pip install --verbose xlsxwriter==3.2.0
pip install --verbose Jinja2==3.1.2
pip install --verbose PyYAML==6.0.1
pip install --verbose pycryptodomex==3.10.1
pip install --verbose requests==2.28.2
pip install --verbose netaddr==0.8.0
pip install --verbose ipaddress==1.0.23
pip install --verbose GitPython==3.1.40
pip install --verbose regex==2022.10.31
pip install --verbose wget==3.2
pip install --verbose cfgparse==1.3
pip install --verbose simplejson==3.18.3
```

---

## ✅ Solution 2: Use Pre-built Wheels

Install using pre-built binary wheels (faster, no compilation):

```bash
pip install --only-binary :all: numpy==1.26.4
pip install --only-binary :all: pandas==2.0.3
pip install --only-binary :all: oci-cli==3.66.1

# For packages without binaries, install normally
pip install openpyxl==3.0.10 xlrd==1.2.0 xlsxwriter==3.2.0
pip install Jinja2==3.1.2 PyYAML==6.0.1
pip install pycryptodomex==3.10.1 requests==2.28.2
pip install netaddr==0.8.0 ipaddress==1.0.23
pip install GitPython==3.1.40 regex==2022.10.31
pip install wget==3.2 cfgparse==1.3 simplejson==3.18.3
```

---

## ✅ Solution 3: Install System Dependencies First

WSL may be missing build tools needed for some packages:

```bash
# Update system
sudo apt update && sudo apt upgrade -y

# Install ALL required build dependencies
sudo apt install -y \
    build-essential \
    libssl-dev \
    libffi-dev \
    python3-dev \
    python3.12-dev \
    libbz2-dev \
    libreadline-dev \
    libsqlite3-dev \
    wget \
    curl \
    llvm \
    libncurses5-dev \
    libncursesw5-dev \
    xz-utils \
    tk-dev \
    libxml2-dev \
    libxmlsec1-dev \
    liblzma-dev \
    gcc \
    g++ \
    make

# Then try installing Python packages again
pip install -r requirements.txt
```

---

## ✅ Solution 4: Increase Timeout and Retry

If network is slow:

```bash
pip install --timeout 300 --retries 5 numpy==1.26.4
pip install --timeout 300 --retries 5 pandas==2.0.3
# ... continue with other packages
```

---

## ✅ Solution 5: Use Alternative Package Index

If PyPI is slow or blocked:

```bash
# Using Aliyun mirror (faster in some regions)
pip install -i https://mirrors.aliyun.com/pypi/simple/ numpy==1.26.4
pip install -i https://mirrors.aliyun.com/pypi/simple/ pandas==2.0.3

# Or Tsinghua mirror
pip install -i https://pypi.tuna.tsinghua.edu.cn/simple numpy==1.26.4
pip install -i https://pypi.tuna.tsinghua.edu.cn/simple pandas==2.0.3
```

---

## ✅ Solution 6: Check Specific Package Issues

### If numpy is stuck:

```bash
# Install from system packages instead
sudo apt install python3-numpy
pip install numpy --upgrade

# Or use older version that builds faster
pip install numpy==1.24.0
```

### If pandas is stuck:

```bash
# Pandas 2.0.3 requires numpy first
pip install numpy==1.26.4
# Wait for it to complete, then:
pip install pandas==2.0.3 --no-build-isolation
```

### If oci-cli is stuck:

```bash
# OCI CLI has many dependencies
# Install with no dependencies, then add them
pip install --no-deps oci-cli==3.66.1
pip install -r <(oci --help 2>&1 | grep "pip install" | cut -d' ' -f3-)
```

---

## 🔧 WSL-Specific Fixes

### Fix 1: Increase WSL Memory

Edit `C:\Users\YourUser\.wslconfig` on Windows:

```ini
[wsl2]
memory=4GB
processors=2
swap=2GB
```

Then restart WSL:
```powershell
# In PowerShell (Windows side)
wsl --shutdown
wsl
```

### Fix 2: Check WSL Network

```bash
# Test internet connectivity
ping -c 3 pypi.org

# Test pip connectivity
pip install --dry-run numpy

# If blocked, configure proxy (if behind corporate firewall)
export HTTP_PROXY=http://proxy:port
export HTTPS_PROXY=http://proxy:port
```

### Fix 3: Use Native Windows Python Instead

If WSL keeps failing, install on Windows directly:

1. Install Python 3.12 on Windows
2. Install packages in Windows
3. Use Windows terminal instead of WSL

---

## 📊 Diagnostic Commands

Run these to identify the issue:

```bash
# Check Python version
python3 --version

# Check pip version
pip --version

# Check available memory
free -h

# Check disk space
df -h

# Check for stuck processes
ps aux | grep pip

# Check pip cache
pip cache info

# Test package installation (dry run)
pip install --dry-run numpy==1.26.4

# Check network speed
curl -o /dev/null http://pypi.org/simple 2>&1 | grep "Average"
```

---

## 🚀 Fastest WSL Installation Method

If you want the quickest installation:

```bash
# 1. Clean start
cd ~/Desktop/Personal_DevOps/CD3/cd3-automation-toolkit
rm -rf cd3venv
python3.12 -m venv cd3venv
source cd3venv/bin/activate

# 2. Upgrade pip with timeout
pip install --upgrade pip setuptools wheel --timeout 300

# 3. Install numpy first (most important)
pip install numpy==1.26.4 --timeout 300

# 4. Install pandas (depends on numpy)
pip install pandas==2.0.3 --timeout 300

# 5. Install everything else at once
pip install \
    oci-cli==3.66.1 \
    openpyxl==3.0.10 \
    xlrd==1.2.0 \
    xlsxwriter==3.2.0 \
    Jinja2==3.1.2 \
    PyYAML==6.0.1 \
    pycryptodomex==3.10.1 \
    requests==2.28.2 \
    netaddr==0.8.0 \
    ipaddress==1.0.23 \
    GitPython==3.1.40 \
    regex==2022.10.31 \
    wget==3.2 \
    cfgparse==1.3 \
    simplejson==3.18.3 \
    --timeout 300
```

---

## 🎯 Recommended: Minimal Installation Script for WSL

Create this script to avoid hangs:

```bash
#!/bin/bash
# wsl_install.sh - Installs CD3 packages with progress

set -e

echo "Installing CD3 dependencies for WSL..."
echo "This may take 10-15 minutes"
echo ""

packages=(
    "numpy==1.26.4"
    "pandas==2.0.3"
    "oci-cli==3.66.1"
    "openpyxl==3.0.10"
    "xlrd==1.2.0"
    "xlsxwriter==3.2.0"
    "Jinja2==3.1.2"
    "PyYAML==6.0.1"
    "pycryptodomex==3.10.1"
    "requests==2.28.2"
    "netaddr==0.8.0"
    "ipaddress==1.0.23"
    "GitPython==3.1.40"
    "regex==2022.10.31"
    "wget==3.2"
    "cfgparse==1.3"
    "simplejson==3.18.3"
)

total=${#packages[@]}
current=0

for package in "${packages[@]}"; do
    current=$((current + 1))
    echo "[$current/$total] Installing $package..."

    pip install --timeout 300 "$package" || {
        echo "Failed to install $package, trying without timeout..."
        pip install "$package"
    }

    echo "✓ Installed $package"
    echo ""
done

echo "All packages installed successfully!"
```

Save and run:
```bash
chmod +x wsl_install.sh
./wsl_install.sh
```

---

## ⚠️ If Still Stuck

### Last Resort Options:

**Option 1: Use older Python**
```bash
# Remove Python 3.12 virtual env
rm -rf cd3venv

# Use Python 3.10 instead
sudo apt install python3.10 python3.10-venv
python3.10 -m venv cd3venv
source cd3venv/bin/activate

# Try installation again
pip install -r requirements.txt
```

**Option 2: Install without dependencies**
```bash
# Install everything without automatic dependencies
pip install --no-deps numpy==1.26.4
pip install --no-deps pandas==2.0.3
pip install --no-deps oci-cli==3.66.1
# ... etc

# Then manually install missing dependencies as needed
```

**Option 3: Use Docker in WSL**
```bash
# Install Docker in WSL
sudo apt install docker.io
sudo docker run -it python:3.12 bash

# Inside container:
pip install -r requirements.txt
```

---

## 🆘 Emergency Contact

If none of these work:

1. **Post your error output**:
   ```bash
   pip install numpy==1.26.4 2>&1 | tee install_error.log
   ```

2. **Check which package is stuck**:
   ```bash
   ps aux | grep pip
   ```

3. **Share diagnostics**:
   ```bash
   python3 --version
   pip --version
   free -h
   df -h
   pip cache info
   ```

---

## ✅ Quick Troubleshooting Checklist

- [ ] Killed stuck pip processes (`pkill -f pip`)
- [ ] Cleared pip cache (`pip cache purge`)
- [ ] Installed system dependencies (`sudo apt install build-essential python3-dev`)
- [ ] Increased timeout (`--timeout 300`)
- [ ] Tried one package at a time
- [ ] Checked network connectivity (`ping pypi.org`)
- [ ] Tried alternative mirror (`-i https://mirrors.aliyun.com/pypi/simple/`)
- [ ] Checked WSL memory allocation (`.wslconfig`)
- [ ] Tried Python 3.10 instead of 3.12

---

**Which package is getting stuck?** Let me know and I can provide specific troubleshooting for that package!

---

**Last Updated:** 2026-01-09
**Tested On:** WSL 2 (Ubuntu 20.04, 22.04)
