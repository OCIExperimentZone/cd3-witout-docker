# WSL Quick Fix - ocicloud Error

## Your Error
```
ModuleNotFoundError: No module named 'ocicloud'
```

## The Problem
Your WSL virtual environment doesn't have the required Python packages installed.

## The Solution (Copy these commands to WSL)

```bash
# 1. Go to CD3 directory
cd /home/pragadeeswar/cd3-without-docker/cd3-automation-toolkit

# 2. Activate virtual environment
source cd3venv/bin/activate

# 3. Install packages (takes 10-15 minutes)
pip install --upgrade pip
pip install numpy==1.26.4 pandas==2.0.3
pip install oci-cli==3.66.1 openpyxl==3.0.10 xlrd==1.2.0 xlsxwriter==3.2.0 Jinja2==3.1.2 PyYAML==6.0.1 pycryptodomex==3.10.1 requests==2.28.2 netaddr==0.8.0 ipaddress==1.0.23 GitPython==3.1.40 regex==2022.10.31 wget==3.2 cfgparse==1.3 simplejson==3.18.3

# 4. Verify installation
pip list | grep oci
pip list | grep pandas

# 5. Run CD3 (from the correct directory!)
cd /home/pragadeeswar/cd3-without-docker/cd3-automation-toolkit/cd3_automation_toolkit
python3 setUpOCI.py
```

## Why This Happens
- You created a virtual environment but didn't install packages in it
- The `ocicloud` module is part of CD3 toolkit, but it imports `oci` package which needs to be installed
- Must run CD3 from `cd3_automation_toolkit` directory (note: TWO levels deep)

## After Installing Packages
Your CD3 will work perfectly. Just remember to:
1. Always activate the virtual environment: `source cd3venv/bin/activate`
2. Always run from the correct directory: `cd cd3_automation_toolkit`

## Alternative: Use the Helper Script
Copy `run_cd3_wsl.sh` to WSL and run:
```bash
bash run_cd3_wsl.sh
```

This handles everything automatically!

---

**Full details:** See [FIX_OCICLOUD_ERROR.md](FIX_OCICLOUD_ERROR.md)
