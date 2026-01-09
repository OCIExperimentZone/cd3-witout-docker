# 🚀 CD3 Toolkit Setup - START HERE

Welcome to the CD3 Automation Toolkit setup! This guide will help you get started quickly.

---

## 📋 What You Need

- **Python 3.12** or **3.10** (we'll help you install)
- **Terraform 1.13+** (we'll help you install)
- **OCI Account** with API access
- **10-15 minutes** for automated setup
- **Internet connection**

---

## 🎯 Quick Setup (Choose Your Platform)

### 🐧 Ubuntu / Linux

**One-command automated installation:**
```bash
cd ~/Desktop/Personal_DevOps/CD3
./quick_install_cd3.sh
```

That's it! The script will:
- ✅ Install Python 3.12 (or 3.10)
- ✅ Install Terraform 1.13
- ✅ Create virtual environment
- ✅ Install all dependencies
- ✅ Configure OCI CLI (interactive)

---

### 🍎 macOS

**One-command automated installation:**
```bash
cd ~/Desktop/Personal_DevOps/CD3
./quick_install_cd3.sh
```

Works on both:
- ✅ Intel Macs (x86_64)
- ✅ Apple Silicon (M1/M2/M3)

---

### 🪟 Windows

**Follow the manual guide:**
1. Open [QUICK_START.md](QUICK_START.md)
2. Go to "Windows" section
3. Follow step-by-step instructions

Estimated time: 20-30 minutes

---

## 🐛 Having Issues?

### HTTPS/SSL Errors?

Run the diagnostic script:

**Linux/macOS:**
```bash
./fix_https_errors.sh
```

**Windows (PowerShell):**
```powershell
.\fix_https_errors.ps1
```

### Other Issues?

Check the [SETUP_GUIDE_NO_DOCKER.md](SETUP_GUIDE_NO_DOCKER.md) "Common Issues" section.

---

## 📚 Documentation Overview

| File | Purpose | When to Use |
|------|---------|-------------|
| **[START_HERE.md](START_HERE.md)** | You are here! Quick start guide | First time setup |
| **[QUICK_START.md](QUICK_START.md)** | Fast reference for all platforms | Quick lookup |
| **[SETUP_GUIDE_NO_DOCKER.md](SETUP_GUIDE_NO_DOCKER.md)** | Complete detailed guide | Step-by-step help |
| **[README_SETUP_SCRIPTS.md](README_SETUP_SCRIPTS.md)** | Scripts documentation | Understanding tools |
| **[VERSION_INFO.md](VERSION_INFO.md)** | Version details & compatibility | Version questions |
| **[CHANGES_SUMMARY.md](CHANGES_SUMMARY.md)** | What changed in v2.0 | Upgrade guide |

### 🔧 Scripts

| Script | Purpose | Platform |
|--------|---------|----------|
| **[quick_install_cd3.sh](quick_install_cd3.sh)** | Automated installation | Linux/macOS |
| **[fix_https_errors.sh](fix_https_errors.sh)** | Fix SSL/HTTPS issues | Linux/macOS |
| **[fix_https_errors.ps1](fix_https_errors.ps1)** | Fix SSL/HTTPS issues | Windows |
| **[verify_versions.sh](verify_versions.sh)** | Check installation | Linux/macOS |

---

## ✅ Verification

After installation, verify everything works:

**Linux/macOS:**
```bash
./verify_versions.sh
```

**Or manually:**
```bash
python3 --version      # Should show 3.12 or 3.10
terraform version      # Should show 1.13+
oci --version          # Should show 3.66+
oci iam region list    # Should list OCI regions
```

---

## 🎓 Step-by-Step Guide

### 1️⃣ Install (10-15 minutes)

**Choose your method:**

**A. Automated (Linux/macOS):**
```bash
./quick_install_cd3.sh
```

**B. Manual (All platforms):**
- See [QUICK_START.md](QUICK_START.md) for your platform

### 2️⃣ Configure OCI (5 minutes)

The installer will ask for:
- Tenancy OCID
- User OCID
- Region (e.g., us-ashburn-1)

Find these in OCI Console:
- Profile Icon → Tenancy: [Your-Tenancy]
- Copy Tenancy OCID
- Profile Icon → User Settings
- Copy User OCID

### 3️⃣ Upload API Key (2 minutes)

After installation:
1. Copy public key:
   ```bash
   cat ~/.oci/oci_api_key_public.pem
   ```

2. Go to OCI Console:
   - Profile Icon → User Settings
   - API Keys → Add API Key
   - Paste public key → Add

### 4️⃣ Test Connection (1 minute)

```bash
oci iam region list
```

Should display available OCI regions.

### 5️⃣ Configure CD3 (5 minutes)

Edit configuration files:

**connectOCI.properties:**
```bash
cd ~/Desktop/Personal_DevOps/CD3/cd3-automation-toolkit/cd3_automation_toolkit
nano connectOCI.properties
```

Fill in your OCI details (tenancy, user, region, key path, fingerprint).

**setUpOCI.properties:**
```bash
nano setUpOCI.properties
```

Configure:
- Output directory
- Prefix (company name)
- Excel template path
- Workflow type

### 6️⃣ Download Excel Template (1 minute)

```bash
wget https://github.com/oracle-devrel/cd3-automation-toolkit/releases/latest/download/CD3-Blank-Template.xlsx
```

### 7️⃣ Run CD3! 🎉

```bash
# Activate environment (if not already active)
source ~/Desktop/Personal_DevOps/CD3/cd3-automation-toolkit/cd3venv/bin/activate

# Go to CD3 directory
cd ~/Desktop/Personal_DevOps/CD3/cd3-automation-toolkit/cd3_automation_toolkit

# Run CD3
python setUpOCI.py
```

You'll see the CD3 menu!

---

## 🎯 Common Use Cases

### Use Case 1: Create New Infrastructure

1. Fill in CD3 Excel template with desired resources
2. Run CD3: `python setUpOCI.py`
3. Select: "2. Generate Terraform files"
4. CD3 creates Terraform code
5. Apply: `cd output && terraform init && terraform apply`

### Use Case 2: Document Existing Infrastructure

1. Run CD3: `python setUpOCI.py`
2. Select: "3. Export existing OCI resources"
3. CD3 generates Excel with current state
4. Use for documentation or recreation

---

## 💡 Pro Tips

### Create an Alias

**Linux/macOS** - Add to ~/.bashrc or ~/.zshrc:
```bash
alias cd3='cd ~/Desktop/Personal_DevOps/CD3/cd3-automation-toolkit/cd3_automation_toolkit && source ../cd3venv/bin/activate && python setUpOCI.py'
```

Then just run: `cd3`

### Keep Environment Active

Create a dedicated terminal profile that auto-activates the virtual environment.

### Use Tab Completion

Enable bash/zsh completion for faster navigation.

---

## 🆘 Need Help?

### Quick Fixes

| Problem | Solution |
|---------|----------|
| **HTTPS errors** | Run `./fix_https_errors.sh` |
| **Python not found** | Check QUICK_START.md for installation |
| **Terraform not found** | Check PATH or reinstall |
| **OCI connection fails** | Verify API key uploaded to console |
| **Permission denied** | Run `chmod 600 ~/.oci/*` |

### Get More Help

1. **Read the docs:**
   - [SETUP_GUIDE_NO_DOCKER.md](SETUP_GUIDE_NO_DOCKER.md) - "Common Issues" section
   - [VERSION_INFO.md](VERSION_INFO.md) - Version troubleshooting

2. **Run diagnostics:**
   ```bash
   ./fix_https_errors.sh    # Linux/macOS
   ./verify_versions.sh     # Linux/macOS
   ```

3. **Check logs:**
   ```bash
   cat ~/.oci/logs/*.log
   export OCI_CLI_DEBUG=true
   oci iam region list
   ```

4. **Ask for help:**
   - GitHub Issues: https://github.com/oracle-devrel/cd3-automation-toolkit/issues
   - OCI Community: https://community.oracle.com/

---

## 📊 Installation Checklist

Before running CD3, make sure you have:

- [ ] Python 3.12 or 3.10 installed
- [ ] Terraform 1.13+ installed
- [ ] Virtual environment created and activated
- [ ] All Python packages installed
- [ ] OCI CLI configured (~/.oci/config exists)
- [ ] API key uploaded to OCI Console
- [ ] OCI connectivity working (`oci iam region list`)
- [ ] connectOCI.properties configured
- [ ] setUpOCI.properties configured
- [ ] CD3 Excel template downloaded

**Run verification:**
```bash
./verify_versions.sh  # Does all checks for you!
```

---

## 🎓 Learning Path

### Beginner (First Time)
1. Read: START_HERE.md (this file)
2. Run: `./quick_install_cd3.sh` or follow QUICK_START.md
3. Configure OCI
4. Test: `./verify_versions.sh`
5. Download Excel template
6. Fill in a simple resource (e.g., compartment)
7. Generate Terraform
8. Review generated code
9. Apply with Terraform

### Intermediate (Regular Use)
1. Create comprehensive Excel templates
2. Use all supported OCI services
3. Integrate with Git
4. Use remote state
5. Automate with scripts

### Advanced (Power User)
1. Customize output structure
2. Use with CI/CD pipelines
3. Multi-tenancy management
4. Complex network topologies
5. Contribute to project

---

## 🔗 Quick Links

### Documentation
- **Main CD3 Repo:** https://github.com/oracle-devrel/cd3-automation-toolkit
- **OCI Docs:** https://docs.oracle.com/en-us/iaas/Content/home.htm
- **Terraform OCI Provider:** https://registry.terraform.io/providers/oracle/oci/latest/docs

### Downloads
- **Python:** https://www.python.org/downloads/
- **Terraform:** https://releases.hashicorp.com/terraform/1.13.0/
- **Git:** https://git-scm.com/downloads
- **CD3 Templates:** https://github.com/oracle-devrel/cd3-automation-toolkit/releases

### Support
- **GitHub Issues:** https://github.com/oracle-devrel/cd3-automation-toolkit/issues
- **OCI Support:** https://support.oracle.com/
- **Community:** https://community.oracle.com/

---

## ✨ What Makes This Setup Different?

Compared to Docker setup:
- ✅ **No Docker** - Runs natively
- ✅ **Faster** - No container overhead
- ✅ **Simpler** - Standard Python environment
- ✅ **Easier debugging** - Direct access
- ✅ **Lower resources** - Less memory/CPU

Compared to manual setup:
- ✅ **Automated** - One command
- ✅ **Smart version detection** - Tries 3.12, falls back to 3.10
- ✅ **Error handling** - Helpful messages
- ✅ **Verification** - Built-in checks
- ✅ **Cross-platform** - Ubuntu, macOS, Windows

What you get:
- ✅ **No Jenkins** - Direct execution
- ✅ **Python 3.12/3.10** - Latest stable
- ✅ **Terraform 1.13** - Modern version
- ✅ **Comprehensive docs** - Multiple guides
- ✅ **Troubleshooting tools** - Built-in diagnostics

---

## 🎉 Ready to Start?

### Linux/macOS Users:
```bash
./quick_install_cd3.sh
```

### Windows Users:
Open [QUICK_START.md](QUICK_START.md) and follow Windows section.

### Need Help?
Read [SETUP_GUIDE_NO_DOCKER.md](SETUP_GUIDE_NO_DOCKER.md) for detailed instructions.

---

**Estimated Time:**
- ⏱️ Automated setup: 10-15 minutes
- ⏱️ Manual setup: 20-30 minutes
- ⏱️ Configuration: 10 minutes
- ⏱️ Total: 30-45 minutes

**After Setup:**
- ⏱️ Generate Terraform: 2-5 minutes
- ⏱️ Apply infrastructure: Varies by size

---

## 📝 Next Steps After Installation

1. ✅ **Verify installation** - Run `./verify_versions.sh`
2. ✅ **Download template** - Get CD3 Excel file
3. ✅ **Learn the template** - Understand structure
4. ✅ **Start small** - Create one compartment
5. ✅ **Generate code** - Run CD3
6. ✅ **Review Terraform** - Check generated files
7. ✅ **Apply changes** - Deploy to OCI
8. ✅ **Expand** - Add more resources
9. ✅ **Automate** - Create scripts/workflows
10. ✅ **Share** - Help others!

---

**Questions?** Check the docs or open an issue on GitHub!

**Ready?** Let's go! 🚀

---

**Last Updated:** 2026-01-09
**Version:** 2.0
**Status:** Production Ready
**Tested On:** Ubuntu 20.04/22.04, macOS Monterey/Ventura, Windows 10/11
