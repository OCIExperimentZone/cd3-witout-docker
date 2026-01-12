# DEFINITIVE FIX - ocicloud Error

## You Said: "All packages are installed but still getting error"

I understand! Here's what's actually wrong and the **exact fix**.

---

## The REAL Problem

Even with all packages installed, you're getting the error because of **THREE CRITICAL REQUIREMENTS** that must ALL be met:

1. ✅ Packages must be installed (you said this is done)
2. ❌ **Virtual environment must be ACTIVATED**
3. ❌ **You must run from the CORRECT DIRECTORY**

If even ONE of these is wrong, you get the error!

---

## The EXACT Fix (Copy to WSL Terminal)

Run these commands **EXACTLY** in WSL:

```bash
# Step 1: Navigate to the correct directory (CRITICAL!)
cd /home/pragadeeswar/cd3-without-docker/cd3-automation-toolkit/cd3_automation_toolkit

# Step 2: Activate virtual environment (CRITICAL!)
source ../cd3venv/bin/activate

# Step 3: Verify you're in the right place
pwd
# MUST show: /home/pragadeeswar/cd3-without-docker/cd3-automation-toolkit/cd3_automation_toolkit

# Step 4: Verify virtual env is active
which python3
# MUST show: /home/pragadeeswar/cd3-without-docker/cd3-automation-toolkit/cd3venv/bin/python3

# Step 5: Now run CD3
python3 connectCloud.py oci connectOCI.properties
```

---

## Why This Is Critical

Look at this from `user-scripts/createTenancyConfig.py` line 21-23:

```python
sys.path.append(os.getcwd())           # Line 21: Adds CURRENT directory to path
sys.path.append(os.getcwd()+"/..")     # Line 22: Adds parent directory
from ocicloud.python.ociCommonTools import *  # Line 23: Imports ocicloud
```

**This means:**
- `os.getcwd()` must be `cd3_automation_toolkit` directory
- If you're in the wrong directory, Python can't find `ocicloud`
- If venv is not active, Python can't find `oci` package

---

## Use the Diagnostic Tool

I created a diagnostic tool for you. Copy `diagnose_cd3.sh` to WSL and run:

```bash
# In WSL, from any directory:
cd /home/pragadeeswar/cd3-without-docker/cd3-automation-toolkit/cd3_automation_toolkit
source ../cd3venv/bin/activate
bash diagnose_cd3.sh
```

This will tell you **EXACTLY** what's wrong:
- ✓ or ✗ for each requirement
- What to fix if something is wrong
- Confirms when everything is correct

---

## Common Mistakes (Why It's Not Working)

### Mistake 1: Wrong Directory
```bash
# WRONG - Parent directory
cd /home/pragadeeswar/cd3-without-docker/cd3-automation-toolkit
python3 connectCloud.py oci connectOCI.properties  # ❌ FAILS

# CORRECT - Inside cd3_automation_toolkit
cd /home/pragadeeswar/cd3-without-docker/cd3-automation-toolkit/cd3_automation_toolkit
python3 connectCloud.py oci connectOCI.properties  # ✅ WORKS
```

### Mistake 2: Virtual Environment Not Activated
```bash
# WRONG - No (cd3venv) in prompt
root@hostname:/path#
python3 connectCloud.py oci connectOCI.properties  # ❌ FAILS

# CORRECT - Shows (cd3venv) in prompt
(cd3venv) root@hostname:/path#
python3 connectCloud.py oci connectOCI.properties  # ✅ WORKS
```

### Mistake 3: Running from Wrong Location
```bash
# WRONG - Running parent script that calls child
cd /home/pragadeeswar/cd3-without-docker
python3 cd3-automation-toolkit/cd3_automation_toolkit/connectCloud.py ...  # ❌ FAILS

# CORRECT - CD to the directory first
cd /home/pragadeeswar/cd3-without-docker/cd3-automation-toolkit/cd3_automation_toolkit
python3 connectCloud.py oci connectOCI.properties  # ✅ WORKS
```

---

## The Helper Script Solution

To avoid this confusion forever, use the helper script:

### Copy `run_cd3_wsl.sh` to WSL

On WSL, create this file `/home/pragadeeswar/cd3-without-docker/run_cd3.sh`:

```bash
#!/bin/bash
set -e

# WSL CD3 Runner
CD3_BASE="/home/pragadeeswar/cd3-without-docker/cd3-automation-toolkit"
CD3_TOOLKIT="${CD3_BASE}/cd3_automation_toolkit"
VENV="${CD3_BASE}/cd3venv"

echo "=== CD3 Automation Toolkit (WSL) ==="
echo "Activating virtual environment..."
source "${VENV}/bin/activate"

echo "Changing to CD3 directory..."
cd "$CD3_TOOLKIT"

echo "Current directory: $(pwd)"
echo "Python: $(which python3)"
echo ""
echo "=== Ready ==="
echo ""

if [ $# -eq 0 ]; then
    python3 setUpOCI.py
else
    python3 "$@"
fi
```

Then just run:
```bash
cd /home/pragadeeswar/cd3-without-docker
chmod +x run_cd3.sh
./run_cd3.sh connectCloud.py oci connectOCI.properties
```

---

## Verification Steps

To confirm everything is correct, run these in WSL:

```bash
# 1. Check current directory
pwd
# Expected: /home/pragadeeswar/cd3-without-docker/cd3-automation-toolkit/cd3_automation_toolkit

# 2. Check for (cd3venv) in your prompt
echo $PS1
# Should contain "cd3venv" somewhere

# 3. Check Python location
which python3
# Expected: /home/pragadeeswar/cd3-without-docker/cd3-automation-toolkit/cd3venv/bin/python3

# 4. Check ocicloud directory exists
ls -la ocicloud/
# Should show __init__.py and python/ directory

# 5. Test import directly
python3 -c "import sys; sys.path.insert(0, '.'); from ocicloud.python import ociCommonTools; print('SUCCESS')"
# Expected: SUCCESS
```

---

## If You're STILL Getting the Error

Run the diagnostic script and send me the output:

```bash
cd /home/pragadeeswar/cd3-without-docker/cd3-automation-toolkit/cd3_automation_toolkit
source ../cd3venv/bin/activate
bash ../../diagnose_cd3.sh
```

Copy the entire output and I can tell you exactly what's wrong.

---

## Summary - The Three Commandments

**ALWAYS follow these three rules:**

1. **BE in the directory**: `cd .../cd3_automation_toolkit/cd3_automation_toolkit`
2. **ACTIVATE venv**: `source ../cd3venv/bin/activate`
3. **RUN from there**: `python3 connectCloud.py ...`

**OR just use the helper script** which does it all for you!

---

## Quick Reference Card

```bash
# === THE ONLY WAY THAT WORKS ===

# Navigate to correct directory
cd /home/pragadeeswar/cd3-without-docker/cd3-automation-toolkit/cd3_automation_toolkit

# Activate virtual environment
source ../cd3venv/bin/activate

# Verify (both must be true):
pwd    # Must end with: cd3_automation_toolkit
which python3   # Must contain: cd3venv

# Now run CD3
python3 setUpOCI.py
# or
python3 connectCloud.py oci connectOCI.properties
```

Copy this and keep it handy!
