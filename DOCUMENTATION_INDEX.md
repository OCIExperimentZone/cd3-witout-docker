# CD3 Toolkit Documentation Index

**Quick Navigation Guide**

---

## 🎯 Start Here

### New Users - Start with these (in order):

1. **[README_SETUP.md](README_SETUP.md)** ⭐ **START HERE**
   - Complete setup guide for all platforms
   - Ubuntu, macOS, Windows instructions
   - Quick start commands
   - Common issues and solutions
   - **READ THIS FIRST!**

2. **[requirements.txt](requirements.txt)**
   - Python package list
   - Use: `pip install -r requirements.txt`

3. Run installation:
   - Linux/macOS: `./quick_install_cd3.sh`
   - Windows: Follow README_SETUP.md

---

## 🔧 Installation Scripts

| Script | Purpose | Platform |
|--------|---------|----------|
| **[quick_install_cd3.sh](quick_install_cd3.sh)** | Full automated setup | Linux/macOS |
| **[install_packages.sh](install_packages.sh)** | Install Python packages only | Linux/macOS |
| **[verify_versions.sh](verify_versions.sh)** | Check installation | Linux/macOS |
| **[fix_https_errors.sh](fix_https_errors.sh)** | Fix SSL/HTTPS issues | Linux/macOS |
| **[fix_https_errors.ps1](fix_https_errors.ps1)** | Fix SSL/HTTPS issues | Windows |

---

## 📖 Reference Documentation

### When You Need More Details:

| Document | Use When |
|----------|----------|
| **[PYTHON312_COMPATIBILITY.md](PYTHON312_COMPATIBILITY.md)** | Python 3.12 compatibility questions |
| **[COMPATIBILITY_FIX_SUMMARY.md](COMPATIBILITY_FIX_SUMMARY.md)** | Understanding recent fixes |
| **[VERSION_INFO.md](VERSION_INFO.md)** | Version compatibility details |

---

## 📚 Archive (Optional Reading)

These were created during setup but are now superseded by **README_SETUP.md**:

| Document | Status | Note |
|----------|--------|------|
| START_HERE.md | 📦 Archived | Use README_SETUP.md instead |
| QUICK_START.md | 📦 Archived | Use README_SETUP.md instead |
| SETUP_GUIDE_NO_DOCKER.md | 📦 Archived | Use README_SETUP.md instead |
| README_SETUP_SCRIPTS.md | 📦 Archived | Use README_SETUP.md instead |
| CHANGES_SUMMARY.md | 📦 Archived | Merged into COMPATIBILITY_FIX_SUMMARY.md |

*These files contain the same information but in longer form. Keep them for reference if needed.*

---

## 🎯 Quick Decision Guide

### "I want to install CD3"
→ Read **[README_SETUP.md](README_SETUP.md)**
→ Run `./quick_install_cd3.sh` (Linux/macOS)

### "I'm getting pandas/Python errors"
→ Read **[PYTHON312_COMPATIBILITY.md](PYTHON312_COMPATIBILITY.md)**
→ Run `pip install pandas==2.0.3`

### "I'm getting HTTPS/SSL errors"
→ Run `./fix_https_errors.sh` (or `.ps1` for Windows)

### "I want to check my setup"
→ Run `./verify_versions.sh`

### "I need to understand OCI API keys"
→ Read **[README_SETUP.md](README_SETUP.md)** - "Configure OCI" section

### "What versions should I use?"
→ Python 3.12 or 3.10, Terraform 1.13
→ See **[requirements.txt](requirements.txt)**

---

## 📁 File Organization

```
CD3/
├── README_SETUP.md                    ⭐ MAIN GUIDE
├── requirements.txt                   📦 Package list
│
├── Scripts/
│   ├── quick_install_cd3.sh          🚀 Auto installer
│   ├── install_packages.sh           📦 Package installer
│   ├── verify_versions.sh            ✅ Verification
│   ├── fix_https_errors.sh           🔧 HTTPS fixer
│   └── fix_https_errors.ps1          🔧 HTTPS fixer (Win)
│
├── Reference/
│   ├── PYTHON312_COMPATIBILITY.md    📖 Python 3.12 info
│   ├── COMPATIBILITY_FIX_SUMMARY.md  📖 Fix summary
│   └── VERSION_INFO.md               📖 Version details
│
└── Archive/ (Optional)
    ├── START_HERE.md
    ├── QUICK_START.md
    ├── SETUP_GUIDE_NO_DOCKER.md
    ├── README_SETUP_SCRIPTS.md
    └── CHANGES_SUMMARY.md
```

---

## 🚀 Typical Workflow

```
1. Read README_SETUP.md
   ↓
2. Run quick_install_cd3.sh (or manual install)
   ↓
3. Configure OCI (oci setup config)
   ↓
4. Run verify_versions.sh
   ↓
5. Configure CD3 properties files
   ↓
6. Download Excel template
   ↓
7. Run python setUpOCI.py
   ↓
8. Done! 🎉
```

---

## 💡 Tips

- **Don't read everything** - Start with README_SETUP.md
- **Use scripts** - They handle most complexity
- **Check verification** - Run verify_versions.sh after install
- **Keep it simple** - Follow README_SETUP.md step by step

---

## 🆘 Getting Help

1. **Check README_SETUP.md** - "Common Issues" section
2. **Run diagnostics** - `./fix_https_errors.sh` or `./verify_versions.sh`
3. **Read compatibility docs** - PYTHON312_COMPATIBILITY.md
4. **GitHub Issues** - https://github.com/oracle-devrel/cd3-automation-toolkit/issues

---

## 📊 Document Summary

| Priority | Document | Lines | Purpose |
|----------|----------|-------|---------|
| 🔴 **HIGH** | README_SETUP.md | 400 | Main setup guide |
| 🔴 **HIGH** | requirements.txt | 40 | Package versions |
| 🟡 Medium | PYTHON312_COMPATIBILITY.md | 600 | Python 3.12 details |
| 🟡 Medium | COMPATIBILITY_FIX_SUMMARY.md | 500 | Fix explanations |
| 🟢 Low | VERSION_INFO.md | 800 | Version reference |
| ⚪ Archive | Others | Various | Historical reference |

---

**Recommendation:** Read **only** README_SETUP.md to get started. Refer to other documents only if you need specific details.

---

**Last Updated:** 2026-01-09
**Status:** Active Documentation Structure
