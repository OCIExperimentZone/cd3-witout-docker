# Getting Started with CD3 - Beginner's Guide

> **Target Audience**: New to infrastructure automation, DevOps, or OCI? Start here!

## What You'll Learn

By the end of this guide, you'll:
- ✅ Understand what CD3 is and why it's useful
- ✅ Have CD3 installed on your computer
- ✅ Be able to run your first CD3 command
- ✅ Know how to get help when stuck

**Estimated Time**: 30-45 minutes

---

## 🤔 What is CD3?

### The Simple Explanation

**CD3** (Cloud Deployment & Design) helps you create cloud infrastructure in Oracle Cloud (OCI) using Excel spreadsheets instead of writing code.

Think of it like this:
- **Without CD3**: You write complex code files to create cloud servers, networks, databases, etc.
- **With CD3**: You fill out an Excel spreadsheet, and CD3 creates the code for you!

### Why Would I Use It?

1. **Easier to Learn**: If you know Excel, you're halfway there!
2. **Faster Setup**: Create hundreds of resources in bulk
3. **Documentation Built-in**: Your Excel file IS your documentation
4. **No Coding Required**: Let CD3 write the Terraform code for you

### Real-World Example

Let's say you need to create:
- 10 servers
- 5 networks
- 3 databases
- Security rules for all of them

**Manual way**: Write 500+ lines of Terraform code (takes hours, error-prone)  
**CD3 way**: Fill 20 rows in Excel, run CD3, done! (takes minutes)

---

## 📋 Prerequisites (What You Need First)

### Required Knowledge
- ✅ Basic computer skills (using terminal/command line)
- ✅ Basic Excel knowledge
- ⚠️ Nice to have: Understanding of cloud computing concepts (but not required!)

### Required Software

Don't worry if you don't have these yet - we'll install them together!

| Software | What It Does | Version Needed |
|----------|--------------|----------------|
| **Python** | Programming language CD3 runs on | 3.10 or 3.12 |
| **Git** | Version control (to download CD3) | Any recent version |
| **Terraform** | Creates cloud infrastructure | 1.13 or higher |
| **OCI CLI** | Talks to Oracle Cloud | 3.66 or higher |

### Required Access
- An **Oracle Cloud account** (you can create a free trial account)
- **Admin permissions** on your computer (to install software)

---

## 🚀 Installation Guide

### Step 1: Check Your Operating System

**Choose your path:**
- **Windows Users**: Jump to [Windows Installation](#windows-installation)
- **Mac Users**: Jump to [macOS Installation](#macos-installation)
- **Linux Users**: Jump to [Linux Installation](#linux-installation)

---

### Windows Installation

#### Option 1: WSL (Recommended for Windows)

**What is WSL?** Windows Subsystem for Linux - it lets you run Linux commands on Windows.

1. **Install WSL** (if you don't have it):
   - Open PowerShell as Administrator
   - Run: `wsl --install`
   - Restart your computer
   - Set up Ubuntu username and password when prompted

2. **Open WSL**:
   - Press `Windows Key + R`
   - Type `wsl` and press Enter
   - You should see a Linux terminal!

3. **Run the Automatic Installer**:
   ```bash
   # Download CD3
   git clone https://github.com/oracle-devrel/cd3-automation-toolkit.git
   cd cd3-automation-toolkit
   
   # Run installer (takes 10-15 minutes)
   ./quick_install_cd3.sh
   ```

4. **Wait for completion** - grab a coffee! ☕

5. **Verify it worked**:
   ```bash
   ./verify_versions.sh
   ```

**Done!** If you see green checkmarks, you're ready to go! 🎉

#### Option 2: Native Windows (Advanced)

See [docs/SETUP.md](docs/SETUP.md) for detailed Windows installation steps.

---

### macOS Installation

**Good news**: macOS installation is super easy!

1. **Open Terminal**:
   - Press `Cmd + Space`
   - Type "Terminal" and press Enter

2. **Install Homebrew** (if you don't have it):
   ```bash
   /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
   ```

3. **Download CD3**:
   ```bash
   cd ~/Desktop
   git clone https://github.com/oracle-devrel/cd3-automation-toolkit.git
   cd cd3-automation-toolkit
   ```

4. **Run the Automatic Installer**:
   ```bash
   ./quick_install_cd3.sh
   ```

5. **Wait 10-15 minutes** while it installs everything

6. **Verify it worked**:
   ```bash
   ./verify_versions.sh
   ```

**Done!** You should see green checkmarks! ✅

---

### Linux Installation

**Ubuntu/Debian Example** (other distros are similar):

1. **Open Terminal**:
   - Press `Ctrl + Alt + T`

2. **Download CD3**:
   ```bash
   cd ~
   git clone https://github.com/oracle-devrel/cd3-automation-toolkit.git
   cd cd3-automation-toolkit
   ```

3. **Run the Automatic Installer**:
   ```bash
   ./quick_install_cd3.sh
   ```

4. **Wait 10-15 minutes** for installation

5. **Verify it worked**:
   ```bash
   ./verify_versions.sh
   ```

**All green?** You're ready! 🎉

---

## 🔑 Setting Up Oracle Cloud Access

Now we need to connect CD3 to your Oracle Cloud account.

### Step 1: Get Your Oracle Cloud Information

1. **Log in to Oracle Cloud Console**: https://cloud.oracle.com
2. Click your **profile icon** (top right)
3. Click **"Tenancy: [your-tenancy-name]"**
4. **Copy these values** (you'll need them):
   - **Tenancy OCID** (looks like: `ocid1.tenancy.oc1..aaaa...`)
   - **Region** (looks like: `us-ashburn-1`)

5. Go back to profile icon → **"User Settings"**
6. **Copy your User OCID** (looks like: `ocid1.user.oc1..aaaa...`)

### Step 2: Generate API Keys

In your terminal, run:

```bash
# Activate CD3 environment
source cd3-automation-toolkit/cd3venv/bin/activate

# Generate API keys
oci setup config
```

**You'll be asked several questions:**

```
Enter a location for your config [~/.oci/config]: 
[Press Enter - use default]

Enter a user OCID: 
[Paste your User OCID from Step 1]

Enter a tenancy OCID: 
[Paste your Tenancy OCID from Step 1]

Enter a region: 
[Type your region, like: us-ashburn-1]

Do you want to generate a new API Signing RSA key pair? [Y/n]: 
[Press Y]

Enter a directory for your keys [~/.oci]: 
[Press Enter - use default]

Enter a name for your key [oci_api_key]: 
[Press Enter - use default]

Enter a passphrase for your private key (empty for no passphrase): 
[Press Enter - no passphrase is easier]
```

**Great!** Your API key is generated! 🔑

### Step 3: Upload Public Key to Oracle Cloud

1. **Display your public key**:
   ```bash
   cat ~/.oci/oci_api_key_public.pem
   ```

2. **Copy the entire output** (including `BEGIN PUBLIC KEY` and `END PUBLIC KEY`)

3. **Go to Oracle Cloud Console**:
   - Click profile icon → "User Settings"
   - Scroll down to "API Keys"
   - Click **"Add API Key"**
   - Select **"Paste Public Key"**
   - Paste your key
   - Click **"Add"**

4. **You'll see a configuration preview** - you can close this

**Perfect!** CD3 can now talk to Oracle Cloud! 🌐

---

## 🎯 Running CD3 for the First Time

### The Easy Way (Helper Script)

```bash
# macOS/Linux
cd ~/cd3-automation-toolkit
./run_cd3.sh

# WSL
cd /home/[your-username]/cd3-automation-toolkit
./run_cd3_wsl.sh
```

### The Manual Way (Learn What's Happening)

```bash
# Step 1: Activate the virtual environment
source cd3-automation-toolkit/cd3venv/bin/activate

# You should see (cd3venv) appear in your terminal prompt

# Step 2: Go to the CD3 directory
cd cd3-automation-toolkit/cd3_automation_toolkit

# Step 3: Run CD3
python setUpOCI.py
```

### What You'll See

```
============================
CD3 Automation Toolkit
============================

Choose an option:
1. Validate Excel Template
2. Create Terraform Files from Excel
3. Export OCI Resources to Excel
4. Exit

Enter your choice [1-4]:
```

**Congratulations!** 🎊 CD3 is running!

For now, type `4` to exit - we'll do actual work in the next section.

---

## 📝 Your First CD3 Project

Let's create a simple virtual network in OCI using CD3.

### Step 1: Download the Excel Template

```bash
cd ~/Downloads
wget https://github.com/oracle-devrel/cd3-automation-toolkit/releases/latest/download/CD3-Blank-Template.xlsx
```

Or download manually from: [CD3 Releases](https://github.com/oracle-devrel/cd3-automation-toolkit/releases)

### Step 2: Open the Template

Open `CD3-Blank-Template.xlsx` in Excel or LibreOffice.

**What you'll see:**
- Multiple tabs at the bottom (VCN, Instances, Storage, etc.)
- Each tab represents a type of cloud resource

### Step 3: Configure a Simple Network

1. **Go to the "VCN" tab** (Virtual Cloud Network)

2. **Fill in one row** with these values:
   - **Region**: `us-ashburn-1` (or your region)
   - **Compartment**: `root` (we'll use the root compartment for simplicity)
   - **VCN Name**: `my-first-network`
   - **VCN CIDR**: `10.0.0.0/16`
   - **DNS Label**: `myfirstnet`

3. **Save the file** as `my-first-project.xlsx`

### Step 4: Generate Terraform Code

```bash
# Run CD3
python setUpOCI.py

# Choose option 2: "Create Terraform Files from Excel"

# When prompted:
# - Excel file path: /path/to/my-first-project.xlsx
# - Output directory: ./output
# - Prefix: my-project
```

CD3 will create Terraform files in the `output` directory!

### Step 5: Review the Generated Code

```bash
ls -la output/
cat output/vcn.tf
```

**You'll see Terraform code** that CD3 created from your Excel file! 🎉

### Step 6: Apply to Oracle Cloud (Optional)

⚠️ **Warning**: This will create real resources in your OCI account (but they're free tier eligible!)

```bash
cd output
terraform init
terraform plan
terraform apply
```

Type `yes` when prompted.

**Wait 1-2 minutes** and your network will be created in OCI! 🌐

---

## 🆘 Help! Something Went Wrong

### Most Common Issues

#### Error: "ModuleNotFoundError: No module named 'ocicloud'"

**What it means**: You're not in the right directory or virtual environment isn't activated.

**Fix**:
```bash
# Make sure you're in the right place
cd cd3-automation-toolkit/cd3_automation_toolkit

# Activate virtual environment
source ../cd3venv/bin/activate

# Try again
python setUpOCI.py
```

#### Error: "SSL Certificate Error"

**What it means**: SSL certificates need updating.

**Fix**:
```bash
./fix_https_errors.sh
```

#### Error: "OCI Authentication Failed"

**What it means**: Your API key isn't configured correctly.

**Fix**:
1. Check if `~/.oci/config` exists: `cat ~/.oci/config`
2. Verify API key is uploaded to OCI Console
3. Try regenerating: `oci setup config`

### Get More Help

1. **Troubleshooting Guide**: [docs/TROUBLESHOOTING.md](docs/TROUBLESHOOTING.md)
2. **Diagnostic Tool**: `./diagnose_cd3.sh`
3. **GitHub Issues**: https://github.com/oracle-devrel/cd3-automation-toolkit/issues

---

## 🎓 Learning Path: What's Next?

### Week 1: Basics
- ✅ Complete this guide
- ✅ Create a simple VCN
- ✅ Export existing OCI resources to Excel

### Week 2: Intermediate
- 📖 Read [docs/SETUP.md](docs/SETUP.md) for more options
- 🏗️ Create compute instances
- 🔒 Set up security lists

### Week 3: Advanced
- 🏛️ Read [ARCHITECTURE.md](ARCHITECTURE.md) to understand how CD3 works
- 🔄 Set up CI/CD automation
- 🛠️ Customize templates for your organization

---

## 📚 Understanding Key Concepts

### What is Terraform?

**Simple explanation**: Terraform is like a recipe book for cloud infrastructure. Instead of manually clicking in the cloud console, you write down what you want, and Terraform creates it automatically.

**CD3's role**: CD3 writes the Terraform recipes for you based on your Excel spreadsheet!

### What is a Virtual Environment?

**Simple explanation**: A "virtual environment" is like a sandbox for Python programs. It keeps CD3's software separate from your computer's main software, preventing conflicts.

**When you see `(cd3venv)`** in your terminal, you're "inside" the virtual environment.

### What is OCI CLI?

**Simple explanation**: OCI CLI (Command Line Interface) is a program that lets you control Oracle Cloud from your terminal instead of the web browser.

**CD3 uses it** to talk to Oracle Cloud on your behalf.

---

## 🎯 Quick Reference Card

**Print this and keep it handy!**

```bash
# Activate CD3
source cd3-automation-toolkit/cd3venv/bin/activate
cd cd3-automation-toolkit/cd3_automation_toolkit

# Run CD3
python setUpOCI.py

# Diagnose problems
./diagnose_cd3.sh

# Check installation
./verify_versions.sh

# Fix SSL errors
./fix_https_errors.sh

# Test OCI connection
oci iam region list
```

---

## 💡 Tips for Success

1. **Always activate the virtual environment** before running CD3
2. **Start small** - create one resource before creating hundreds
3. **Keep your Excel files** - they're your documentation!
4. **Use Git** to version control your Excel files and Terraform output
5. **Test in a sandbox** environment before production
6. **Ask for help early** - the community is friendly!

---

## 🤝 Getting Help from the Community

### Where to Ask Questions

1. **GitHub Issues**: https://github.com/oracle-devrel/cd3-automation-toolkit/issues
   - Search existing issues first
   - Provide error messages and steps to reproduce

2. **OCI Documentation**: https://docs.oracle.com/en-us/iaas/
   - Learn about OCI concepts

3. **Terraform Documentation**: https://www.terraform.io/docs
   - Understand the generated code

### How to Ask Good Questions

**Bad question**: "It doesn't work, help!"

**Good question**:
```
I'm trying to create a VCN using CD3 on macOS.

Steps I followed:
1. Ran ./quick_install_cd3.sh
2. Created Excel file with VCN configuration
3. Ran python setUpOCI.py

Error I got:
[paste full error message]

Already tried:
- Verifying virtual environment is active
- Checking ~/.oci/config exists
```

---

## 🎉 Congratulations!

You've completed the beginner's guide to CD3! You now know:
- ✅ What CD3 is and why it's useful
- ✅ How to install CD3 on your system
- ✅ How to set up Oracle Cloud authentication
- ✅ How to run your first CD3 command
- ✅ Where to get help when stuck

**Next Steps**:
1. Explore more resource types in the Excel template
2. Read [docs/SETUP.md](docs/SETUP.md) for advanced configuration
3. Check out [ARCHITECTURE.md](ARCHITECTURE.md) when you're ready to go deeper

**Happy cloud building!** ☁️🚀

---

**Document Version**: 1.0  
**Last Updated**: 2026-01-12  
**Feedback**: Please open an issue if anything is unclear!
