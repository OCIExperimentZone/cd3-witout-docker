#!/bin/bash

################################################################################
#                    CD3 Complete WSL Helper Script                            #
#                                                                              #
# This script does EVERYTHING:                                                #
# 1. Diagnoses your CD3 installation                                          #
# 2. Shows what's wrong                                                       #
# 3. Offers to fix issues                                                     #
# 4. Runs CD3 when everything is ready                                        #
#                                                                              #
# Usage: bash cd3_wsl_complete.sh                                             #
################################################################################

set +e  # Don't exit on errors, we want to handle them

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

# Configuration - ADJUST THESE IF YOUR PATHS ARE DIFFERENT
CD3_BASE="/home/pragadeeswar/cd3-without-docker/cd3-automation-toolkit"
CD3_TOOLKIT="${CD3_BASE}/cd3_automation_toolkit"
VENV="${CD3_BASE}/cd3venv"

clear
echo -e "${CYAN}╔═══════════════════════════════════════════════════════════════════════╗${NC}"
echo -e "${CYAN}║                                                                       ║${NC}"
echo -e "${CYAN}║              CD3 Complete Helper for WSL                              ║${NC}"
echo -e "${CYAN}║                                                                       ║${NC}"
echo -e "${CYAN}╚═══════════════════════════════════════════════════════════════════════╝${NC}"
echo ""

# Function to check if we're in the right directory
check_directory() {
    echo -e "${BLUE}[1/6] Checking Directory...${NC}"
    if [ -d "$CD3_TOOLKIT" ]; then
        echo -e "${GREEN}✓ CD3 toolkit directory found: $CD3_TOOLKIT${NC}"
        return 0
    else
        echo -e "${RED}✗ CD3 toolkit directory NOT found: $CD3_TOOLKIT${NC}"
        echo -e "${YELLOW}Please check if the path is correct or if CD3 is installed.${NC}"
        return 1
    fi
}

# Function to check virtual environment
check_venv() {
    echo -e "\n${BLUE}[2/6] Checking Virtual Environment...${NC}"
    if [ -d "$VENV" ]; then
        echo -e "${GREEN}✓ Virtual environment found: $VENV${NC}"
        return 0
    else
        echo -e "${RED}✗ Virtual environment NOT found: $VENV${NC}"
        echo -e "${YELLOW}You need to create a virtual environment first.${NC}"
        return 1
    fi
}

# Function to activate virtual environment
activate_venv() {
    echo -e "\n${BLUE}[3/6] Activating Virtual Environment...${NC}"
    if [ -f "$VENV/bin/activate" ]; then
        source "$VENV/bin/activate"
        PYTHON_PATH=$(which python3)
        if [[ "$PYTHON_PATH" == *"cd3venv"* ]]; then
            echo -e "${GREEN}✓ Virtual environment activated${NC}"
            echo -e "  Python: ${CYAN}$PYTHON_PATH${NC}"
            return 0
        else
            echo -e "${RED}✗ Failed to activate virtual environment${NC}"
            return 1
        fi
    else
        echo -e "${RED}✗ Activation script not found${NC}"
        return 1
    fi
}

# Function to check if packages are installed
check_packages() {
    echo -e "\n${BLUE}[4/6] Checking Required Python Packages...${NC}"
    local missing_packages=()
    local required_packages=("oci" "pandas" "numpy" "oci-cli" "openpyxl" "jinja2" "PyYAML")

    for pkg in "${required_packages[@]}"; do
        if pip show "$pkg" &> /dev/null; then
            version=$(pip show "$pkg" | grep Version | cut -d' ' -f2)
            echo -e "${GREEN}✓ $pkg ($version)${NC}"
        else
            echo -e "${RED}✗ MISSING: $pkg${NC}"
            missing_packages+=("$pkg")
        fi
    done

    if [ ${#missing_packages[@]} -eq 0 ]; then
        return 0
    else
        echo -e "\n${YELLOW}Missing packages detected!${NC}"
        echo -e "${YELLOW}Do you want to install them now? (y/n)${NC}"
        read -r response
        if [[ "$response" =~ ^[Yy]$ ]]; then
            install_packages
            return $?
        else
            echo -e "${RED}Cannot proceed without required packages.${NC}"
            return 1
        fi
    fi
}

# Function to install packages
install_packages() {
    echo -e "\n${CYAN}Installing Python packages... This will take 10-15 minutes.${NC}"

    pip install --upgrade pip

    echo -e "${CYAN}Installing core packages...${NC}"
    pip install numpy==1.26.4 pandas==2.0.3

    echo -e "${CYAN}Installing CD3 dependencies...${NC}"
    pip install oci-cli==3.66.1 openpyxl==3.0.10 xlrd==1.2.0 \
        xlsxwriter==3.2.0 Jinja2==3.1.2 PyYAML==6.0.1 \
        pycryptodomex==3.10.1 requests==2.28.2 netaddr==0.8.0 \
        ipaddress==1.0.23 GitPython==3.1.40 regex==2022.10.31 \
        wget==3.2 cfgparse==1.3 simplejson==3.18.3

    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✓ All packages installed successfully${NC}"
        return 0
    else
        echo -e "${RED}✗ Package installation failed${NC}"
        return 1
    fi
}

# Function to check CD3 files
check_cd3_files() {
    echo -e "\n${BLUE}[5/6] Checking CD3 Files...${NC}"
    cd "$CD3_TOOLKIT" || return 1

    local all_good=true

    # Check for critical directories
    for dir in ocicloud common user-scripts; do
        if [ -d "$dir" ]; then
            echo -e "${GREEN}✓ $dir/ directory exists${NC}"
        else
            echo -e "${RED}✗ $dir/ directory MISSING${NC}"
            all_good=false
        fi
    done

    # Check for critical files
    for file in setUpOCI.py connectCloud.py connectOCI.properties; do
        if [ -f "$file" ]; then
            echo -e "${GREEN}✓ $file exists${NC}"
        else
            echo -e "${RED}✗ $file MISSING${NC}"
            all_good=false
        fi
    done

    if [ "$all_good" = true ]; then
        return 0
    else
        echo -e "\n${RED}CD3 installation is incomplete!${NC}"
        echo -e "${YELLOW}You need to reinstall or re-extract CD3.${NC}"
        return 1
    fi
}

# Function to test Python import
test_import() {
    echo -e "\n${BLUE}[6/6] Testing Python Import...${NC}"
    cd "$CD3_TOOLKIT" || return 1

    python3 -c "import sys; sys.path.insert(0, '.'); from ocicloud.python import ociCommonTools" 2>/dev/null

    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✓ Python import test successful${NC}"
        return 0
    else
        echo -e "${RED}✗ Python import test failed${NC}"
        echo -e "${YELLOW}Running detailed test...${NC}"
        python3 -c "import sys; sys.path.insert(0, '.'); from ocicloud.python import ociCommonTools"
        return 1
    fi
}

# Function to run CD3
run_cd3() {
    echo -e "\n${CYAN}╔═══════════════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║                    Ready to Run CD3                                   ║${NC}"
    echo -e "${CYAN}╚═══════════════════════════════════════════════════════════════════════╝${NC}"
    echo ""
    echo -e "${GREEN}Current directory: ${CYAN}$(pwd)${NC}"
    echo -e "${GREEN}Python: ${CYAN}$(which python3)${NC}"
    echo -e "${GREEN}Python version: ${CYAN}$(python3 --version)${NC}"
    echo ""
    echo -e "${YELLOW}What would you like to do?${NC}"
    echo -e "  ${CYAN}1${NC} - Run setUpOCI.py (Main CD3 menu)"
    echo -e "  ${CYAN}2${NC} - Run connectCloud.py oci connectOCI.properties"
    echo -e "  ${CYAN}3${NC} - Drop to shell (stay in this directory with venv active)"
    echo -e "  ${CYAN}4${NC} - Exit"
    echo ""
    read -p "Choice [1-4]: " choice

    case $choice in
        1)
            echo -e "\n${GREEN}Running setUpOCI.py...${NC}\n"
            python3 setUpOCI.py
            ;;
        2)
            echo -e "\n${GREEN}Running connectCloud.py...${NC}\n"
            python3 connectCloud.py oci connectOCI.properties
            ;;
        3)
            echo -e "\n${GREEN}Dropping to shell. Virtual environment is active.${NC}"
            echo -e "${YELLOW}You are in: ${CYAN}$(pwd)${NC}"
            echo -e "${YELLOW}Type 'exit' to return to this script or run CD3 commands manually.${NC}\n"
            bash
            ;;
        4)
            echo -e "\n${GREEN}Goodbye!${NC}\n"
            exit 0
            ;;
        *)
            echo -e "\n${RED}Invalid choice${NC}\n"
            run_cd3
            ;;
    esac
}

# Main execution flow
main() {
    # Run all checks
    check_directory || exit 1
    check_venv || exit 1
    activate_venv || exit 1
    check_packages || exit 1
    check_cd3_files || exit 1
    test_import || exit 1

    # If all checks pass
    echo -e "\n${GREEN}╔═══════════════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║                                                                       ║${NC}"
    echo -e "${GREEN}║                  ✓✓✓ ALL CHECKS PASSED ✓✓✓                           ║${NC}"
    echo -e "${GREEN}║                                                                       ║${NC}"
    echo -e "${GREEN}║                  CD3 is ready to use!                                 ║${NC}"
    echo -e "${GREEN}║                                                                       ║${NC}"
    echo -e "${GREEN}╚═══════════════════════════════════════════════════════════════════════╝${NC}"

    # Change to CD3 directory
    cd "$CD3_TOOLKIT"

    # Run CD3
    run_cd3
}

# Run main function
main
