#!/bin/bash
################################################################################
# CD3 Toolkit - Package Installation Script
# Installs Python 3.12 compatible packages
################################################################################

set -e

GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${BLUE}════════════════════════════════════════${NC}"
echo -e "${BLUE}CD3 Package Installation${NC}"
echo -e "${BLUE}Python 3.12 Compatible Versions${NC}"
echo -e "${BLUE}════════════════════════════════════════${NC}\n"

# Check if virtual environment is activated
if [ -z "$VIRTUAL_ENV" ]; then
    echo -e "${YELLOW}Virtual environment not activated!${NC}"
    echo -e "${BLUE}Activating cd3venv...${NC}\n"

    if [ -f "cd3-automation-toolkit/cd3venv/bin/activate" ]; then
        source cd3-automation-toolkit/cd3venv/bin/activate
    elif [ -f "cd3venv/bin/activate" ]; then
        source cd3venv/bin/activate
    else
        echo "Error: Could not find virtual environment"
        echo "Please run from CD3 directory or activate venv manually"
        exit 1
    fi
fi

echo -e "${GREEN}✓ Virtual environment active: $VIRTUAL_ENV${NC}\n"

# Upgrade pip
echo -e "${BLUE}Upgrading pip...${NC}"
pip install --upgrade pip setuptools wheel

echo ""
echo -e "${BLUE}Installing packages (this may take 5-10 minutes)...${NC}\n"

# Install numpy first
echo -e "${BLUE}[1/18] Installing numpy...${NC}"
pip install numpy==1.26.4

# Install pandas
echo -e "${BLUE}[2/18] Installing pandas...${NC}"
pip install pandas==2.0.3

# Install OCI CLI
echo -e "${BLUE}[3/18] Installing oci-cli...${NC}"
pip install oci-cli==3.66.1

# Install Excel libraries
echo -e "${BLUE}[4/18] Installing openpyxl...${NC}"
pip install openpyxl==3.0.10

echo -e "${BLUE}[5/18] Installing xlrd...${NC}"
pip install xlrd==1.2.0

echo -e "${BLUE}[6/18] Installing xlsxwriter...${NC}"
pip install xlsxwriter==3.2.0

# Install templating
echo -e "${BLUE}[7/18] Installing Jinja2...${NC}"
pip install Jinja2==3.1.2

echo -e "${BLUE}[8/18] Installing PyYAML...${NC}"
pip install PyYAML==6.0.1

# Install crypto
echo -e "${BLUE}[9/18] Installing pycryptodomex...${NC}"
pip install pycryptodomex==3.10.1

# Install networking
echo -e "${BLUE}[10/18] Installing requests...${NC}"
pip install requests==2.28.2

echo -e "${BLUE}[11/18] Installing netaddr...${NC}"
pip install netaddr==0.8.0

echo -e "${BLUE}[12/18] Installing ipaddress...${NC}"
pip install ipaddress==1.0.23

# Install Git integration
echo -e "${BLUE}[13/18] Installing GitPython...${NC}"
pip install GitPython==3.1.40

# Install utilities
echo -e "${BLUE}[14/18] Installing regex...${NC}"
pip install regex==2022.10.31

echo -e "${BLUE}[15/18] Installing wget...${NC}"
pip install wget==3.2

echo -e "${BLUE}[16/18] Installing cfgparse...${NC}"
pip install cfgparse==1.3

echo -e "${BLUE}[17/18] Installing simplejson...${NC}"
pip install simplejson==3.18.3

echo ""
echo -e "${BLUE}════════════════════════════════════════${NC}"
echo -e "${GREEN}✓ All packages installed successfully!${NC}"
echo -e "${BLUE}════════════════════════════════════════${NC}\n"

# Verify installations
echo -e "${BLUE}Verifying installations...${NC}\n"

python3 -c "import pandas; print('✓ pandas', pandas.__version__)"
python3 -c "import numpy; print('✓ numpy', numpy.__version__)"
python3 -c "import openpyxl; print('✓ openpyxl', openpyxl.__version__)"
python3 -c "import oci; print('✓ oci-cli installed')"
python3 -c "import jinja2; print('✓ Jinja2', jinja2.__version__)"

echo ""
echo -e "${GREEN}✓ All packages working correctly!${NC}"
echo ""
echo -e "${BLUE}Next steps:${NC}"
echo "1. Configure OCI: oci setup config"
echo "2. Configure CD3: Edit connectOCI.properties and setUpOCI.properties"
echo "3. Run CD3: python setUpOCI.py"
echo ""
