#!/bin/bash
################################################################################
# CD3 Toolkit - Quick Installation Script (No Docker/Jenkins)
# One-command setup for Ubuntu/macOS
################################################################################

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

echo -e "${BLUE}"
echo "╔════════════════════════════════════════════════════════════╗"
echo "║        CD3 Toolkit Quick Installation Script              ║"
echo "║        (Without Docker/Jenkins)                            ║"
echo "╚════════════════════════════════════════════════════════════╝"
echo -e "${NC}\n"

# Detect OS
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    OS="linux"
    PACKAGE_MANAGER=""
    if command -v apt-get &> /dev/null; then
        PACKAGE_MANAGER="apt"
    elif command -v yum &> /dev/null; then
        PACKAGE_MANAGER="yum"
    fi
    echo -e "${GREEN}Detected OS: Linux ($PACKAGE_MANAGER)${NC}\n"
elif [[ "$OSTYPE" == "darwin"* ]]; then
    OS="macos"
    echo -e "${GREEN}Detected OS: macOS${NC}\n"
else
    echo -e "${RED}Unsupported OS: $OSTYPE${NC}"
    echo "This script supports Linux and macOS only."
    echo "For Windows, use the PowerShell script."
    exit 1
fi

# Get current directory
CURRENT_DIR=$(pwd)
echo -e "${CYAN}Working directory: $CURRENT_DIR${NC}\n"

# Check if cd3-automation-toolkit exists
if [ ! -d "$CURRENT_DIR/cd3-automation-toolkit" ]; then
    echo -e "${YELLOW}cd3-automation-toolkit directory not found.${NC}"
    echo -e "${BLUE}Cloning from GitHub...${NC}"
    git clone https://github.com/oracle-devrel/cd3-automation-toolkit.git
fi

CD3_DIR="$CURRENT_DIR/cd3-automation-toolkit"
VENV_DIR="$CD3_DIR/cd3venv"

echo -e "${BLUE}═══════════════════════════════════════════════════════════${NC}"
echo -e "${BLUE}Step 1: Installing System Dependencies${NC}"
echo -e "${BLUE}═══════════════════════════════════════════════════════════${NC}\n"

if [ "$OS" == "linux" ]; then
    if [ "$PACKAGE_MANAGER" == "apt" ]; then
        echo "Updating package lists..."
        sudo apt-get update -qq

        echo "Installing build essentials and Python..."
        # Try Python 3.12 first, fallback to 3.10
        if sudo apt-get install -y -qq python3.12 python3.12-venv 2>/dev/null; then
            PYTHON_CMD="python3.12"
            echo "Python 3.12 installed"
        else
            echo "Python 3.12 not available, installing Python 3.10..."
            sudo apt-get install -y -qq python3.10 python3.10-venv
            PYTHON_CMD="python3.10"
        fi

        sudo apt-get install -y -qq \
            build-essential \
            libssl-dev \
            libffi-dev \
            python3-dev \
            python3-pip \
            git \
            wget \
            curl \
            unzip \
            ca-certificates
    elif [ "$PACKAGE_MANAGER" == "yum" ]; then
        echo "Installing build tools and Python..."
        # Try Python 3.12 first, fallback to 3.10
        if sudo yum install -y python3.12 python3.12-devel python3.12-pip 2>/dev/null; then
            PYTHON_CMD="python3.12"
            echo "Python 3.12 installed"
        else
            echo "Python 3.12 not available, installing Python 3.10..."
            sudo yum install -y python3.10 python3.10-devel python3.10-pip || \
            sudo yum install -y python310 python310-devel python310-pip
            PYTHON_CMD="python3.10"
        fi

        sudo yum install -y \
            gcc \
            gcc-c++ \
            make \
            openssl-devel \
            libffi-devel \
            git \
            wget \
            curl \
            unzip \
            ca-certificates
    fi
elif [ "$OS" == "macos" ]; then
    if ! command -v brew &> /dev/null; then
        echo -e "${YELLOW}Homebrew not found. Installing...${NC}"
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi

    echo "Installing Python (trying 3.12, fallback to 3.10)..."
    if brew install python@3.12 2>/dev/null; then
        PYTHON_CMD="python3.12"
        echo "Python 3.12 installed"
    else
        echo "Python 3.12 not available, installing Python 3.10..."
        brew install python@3.10
        PYTHON_CMD="python3.10"
    fi

    brew install git wget 2>/dev/null || true
fi

echo -e "${GREEN}✓ System dependencies installed${NC}\n"

# Verify Python
if ! command -v $PYTHON_CMD &> /dev/null; then
    PYTHON_CMD="python3"
fi

PYTHON_VERSION=$($PYTHON_CMD --version)
echo -e "${GREEN}Using: $PYTHON_VERSION${NC}\n"

echo -e "${BLUE}═══════════════════════════════════════════════════════════${NC}"
echo -e "${BLUE}Step 2: Installing Terraform${NC}"
echo -e "${BLUE}═══════════════════════════════════════════════════════════${NC}\n"

if command -v terraform &> /dev/null; then
    TF_VERSION=$(terraform version | head -n 1)
    echo -e "${GREEN}✓ Terraform already installed: $TF_VERSION${NC}\n"
else
    echo "Downloading Terraform 1.13.0..."
    cd /tmp

    if [ "$OS" == "linux" ]; then
        wget -q https://releases.hashicorp.com/terraform/1.13.0/terraform_1.13.0_linux_amd64.zip
        unzip -q terraform_1.13.0_linux_amd64.zip
    elif [ "$OS" == "macos" ]; then
        # Detect Mac architecture
        if [ "$(uname -m)" == "arm64" ]; then
            wget -q https://releases.hashicorp.com/terraform/1.13.0/terraform_1.13.0_darwin_arm64.zip
            unzip -q terraform_1.13.0_darwin_arm64.zip
        else
            wget -q https://releases.hashicorp.com/terraform/1.13.0/terraform_1.13.0_darwin_amd64.zip
            unzip -q terraform_1.13.0_darwin_amd64.zip
        fi
    fi

    sudo mv terraform /usr/local/bin/
    sudo chmod +x /usr/local/bin/terraform
    rm -f terraform*.zip

    echo -e "${GREEN}✓ Terraform 1.13.0 installed${NC}"
    terraform version
    echo ""
fi

cd "$CURRENT_DIR"

echo -e "${BLUE}═══════════════════════════════════════════════════════════${NC}"
echo -e "${BLUE}Step 3: Creating Python Virtual Environment${NC}"
echo -e "${BLUE}═══════════════════════════════════════════════════════════${NC}\n"

if [ -d "$VENV_DIR" ]; then
    echo -e "${YELLOW}Virtual environment exists. Removing...${NC}"
    rm -rf "$VENV_DIR"
fi

echo "Creating virtual environment..."
$PYTHON_CMD -m venv "$VENV_DIR"

echo "Activating virtual environment..."
source "$VENV_DIR/bin/activate"

echo "Upgrading pip..."
pip install --upgrade pip setuptools wheel -q

echo -e "${GREEN}✓ Virtual environment created and activated${NC}\n"

echo -e "${BLUE}═══════════════════════════════════════════════════════════${NC}"
echo -e "${BLUE}Step 4: Installing Python Dependencies${NC}"
echo -e "${BLUE}═══════════════════════════════════════════════════════════${NC}\n"

echo "Installing CD3 dependencies (this may take a few minutes)..."

# Install in specific order to avoid conflicts - Python 3.12 compatible versions
pip install -q numpy==1.26.4
pip install -q pandas==2.0.3

# Install core dependencies
pip install -q oci-cli==3.66.1
pip install -q openpyxl==3.0.10
pip install -q xlrd==1.2.0
pip install -q xlsxwriter==3.2.0
pip install -q Jinja2==3.1.2
pip install -q PyYAML==6.0.1
pip install -q pycryptodomex==3.10.1
pip install -q requests==2.28.2
pip install -q netaddr==0.8.0
pip install -q ipaddress==1.0.23
pip install -q GitPython==3.1.40
pip install -q regex==2022.10.31
pip install -q wget==3.2
pip install -q cfgparse==1.3
pip install -q simplejson==3.18.3

echo -e "${GREEN}✓ All Python dependencies installed${NC}\n"

echo -e "${BLUE}═══════════════════════════════════════════════════════════${NC}"
echo -e "${BLUE}Step 5: Setting Up OCI CLI${NC}"
echo -e "${BLUE}═══════════════════════════════════════════════════════════${NC}\n"

if [ -f ~/.oci/config ]; then
    echo -e "${GREEN}✓ OCI CLI already configured${NC}"
    echo -e "${YELLOW}Config file: ~/.oci/config${NC}"
    echo -e "${CYAN}To reconfigure, run: oci setup config${NC}\n"
else
    echo -e "${YELLOW}OCI CLI not configured yet.${NC}"
    echo -e "${CYAN}You'll need:${NC}"
    echo "  - User OCID"
    echo "  - Tenancy OCID"
    echo "  - Region (e.g., us-ashburn-1)"
    echo ""
    read -p "Configure OCI CLI now? (y/n): " -n 1 -r
    echo ""
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        oci setup config
        echo ""
        echo -e "${GREEN}✓ OCI CLI configured${NC}"
        echo -e "${YELLOW}Don't forget to upload public key to OCI Console!${NC}"
        echo "Public key location: ~/.oci/oci_api_key_public.pem"
        echo ""
        echo "To upload:"
        echo "1. Go to OCI Console"
        echo "2. Profile Icon > User Settings > API Keys"
        echo "3. Click 'Add API Key'"
        echo "4. Paste the public key"
        echo ""
        read -p "Press Enter to see your public key..."
        cat ~/.oci/oci_api_key_public.pem
        echo ""
    else
        echo -e "${YELLOW}Skipping OCI CLI setup. Run 'oci setup config' later.${NC}\n"
    fi
fi

# Fix permissions
if [ -d ~/.oci ]; then
    chmod 700 ~/.oci
    [ -f ~/.oci/config ] && chmod 600 ~/.oci/config
    [ -f ~/.oci/oci_api_key.pem ] && chmod 600 ~/.oci/oci_api_key.pem
    [ -f ~/.oci/oci_api_key_public.pem ] && chmod 644 ~/.oci/oci_api_key_public.pem
    echo -e "${GREEN}✓ OCI file permissions set correctly${NC}\n"
fi

echo -e "${BLUE}═══════════════════════════════════════════════════════════${NC}"
echo -e "${BLUE}Step 6: Configuring CD3 Toolkit${NC}"
echo -e "${BLUE}═══════════════════════════════════════════════════════════${NC}\n"

cd "$CD3_DIR/cd3_automation_toolkit"

# Create example configuration if not exists
if [ ! -f "connectOCI.properties.example" ]; then
    cat > connectOCI.properties.example << 'EOF'
# OCI Authentication Configuration
# Copy this file to connectOCI.properties and fill in your details

[DEFAULT]
# Your OCI Tenancy OCID
tenancy_ocid=ocid1.tenancy.oc1..aaaaaaaxxxxxx

# Your OCI User OCID
user_ocid=ocid1.user.oc1..aaaaaaaxxxxxx

# OCI Region (e.g., us-ashburn-1, us-phoenix-1, eu-frankfurt-1)
region=us-ashburn-1

# Path to your private key file
key_path=~/.oci/oci_api_key.pem

# API Key Fingerprint
fingerprint=xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx

# Authentication Mechanism
# Options: api_key, instance_principal, session_token
auth_mechanism=api_key
EOF
    echo -e "${GREEN}✓ Created connectOCI.properties.example${NC}"
fi

if [ ! -f "setUpOCI.properties.example" ]; then
    cat > setUpOCI.properties.example << EOF
# CD3 Toolkit Setup Configuration
# Copy this file to setUpOCI.properties and customize

# Output directory for generated Terraform files
outdir=$HOME/oci_terraform

# Prefix for resources (usually customer/company name)
prefix=mycompany

# Path to CD3 Excel template
cd3file=$HOME/CD3-Customer-Template.xlsx

# Workflow type
# Options: create_resources, export_resources
workflow_type=create_resources

# Infrastructure as Code tool
# Options: terraform, tofu
tf_or_tofu=terraform

# Remote state (optional)
use_remote_state=no
#remote_state_bucket_name=mybucket

# OCI DevOps Git integration (optional)
use_oci_devops_git=no
#oci_devops_git_repo_name=myproject/myrepo
EOF
    echo -e "${GREEN}✓ Created setUpOCI.properties.example${NC}"
fi

echo ""
echo -e "${CYAN}Configuration files created in:${NC}"
echo "  $CD3_DIR/cd3_automation_toolkit/"
echo ""
echo -e "${YELLOW}Next steps:${NC}"
echo "1. Copy and configure connectOCI.properties"
echo "2. Copy and configure setUpOCI.properties"
echo "3. Download CD3 Excel template"
echo ""

echo -e "${BLUE}═══════════════════════════════════════════════════════════${NC}"
echo -e "${BLUE}Step 7: Verification${NC}"
echo -e "${BLUE}═══════════════════════════════════════════════════════════${NC}\n"

echo "Testing installations..."
echo ""

# Test Python
echo -n "Python: "
$PYTHON_CMD --version

# Test Terraform
echo -n "Terraform: "
terraform version | head -n 1

# Test OCI CLI
echo -n "OCI CLI: "
oci --version

echo ""

# Test OCI connection if configured
if [ -f ~/.oci/config ]; then
    echo "Testing OCI connectivity..."
    if oci iam region list --output table 2>&1 > /dev/null; then
        echo -e "${GREEN}✓ OCI API connection successful${NC}"
    else
        echo -e "${YELLOW}⚠ OCI API connection failed - check configuration${NC}"
    fi
fi

echo ""

echo -e "${BLUE}═══════════════════════════════════════════════════════════${NC}"
echo -e "${GREEN}Installation Complete!${NC}"
echo -e "${BLUE}═══════════════════════════════════════════════════════════${NC}\n"

echo -e "${CYAN}To activate CD3 environment:${NC}"
echo "  cd $CD3_DIR"
echo "  source cd3venv/bin/activate"
echo "  cd cd3_automation_toolkit"
echo "  python setUpOCI.py"
echo ""

echo -e "${CYAN}Create a convenient alias (add to ~/.bashrc or ~/.zshrc):${NC}"
echo "  alias cd3='cd $CD3_DIR/cd3_automation_toolkit && source ../cd3venv/bin/activate && python setUpOCI.py'"
echo ""

echo -e "${YELLOW}Important next steps:${NC}"
echo "  1. Configure connectOCI.properties with your OCI credentials"
echo "  2. Configure setUpOCI.properties with your preferences"
echo "  3. Download CD3 Excel template from GitHub releases"
echo "  4. Run: ./fix_https_errors.sh (if you encounter HTTPS issues)"
echo "  5. Read: SETUP_GUIDE_NO_DOCKER.md for detailed instructions"
echo ""

echo -e "${CYAN}For help:${NC}"
echo "  - Setup Guide: $CURRENT_DIR/SETUP_GUIDE_NO_DOCKER.md"
echo "  - HTTPS Issues: Run ./fix_https_errors.sh"
echo "  - GitHub: https://github.com/oracle-devrel/cd3-automation-toolkit"
echo ""

echo -e "${GREEN}Happy automating! 🚀${NC}"
