#!/bin/bash

# CD3 Diagnostic Script - Find out exactly what's wrong

set +e  # Don't exit on error, we want to see all diagnostics

GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}   CD3 Diagnostic Tool${NC}"
echo -e "${BLUE}========================================${NC}\n"

# Check 1: Current Directory
echo -e "${YELLOW}[1] Current Directory Check${NC}"
echo -e "Current directory: ${GREEN}$(pwd)${NC}"
CORRECT_DIR="cd3_automation_toolkit"
if [[ $(basename $(pwd)) == "$CORRECT_DIR" ]]; then
    echo -e "${GREEN}✓ You are in the correct directory${NC}\n"
else
    echo -e "${RED}✗ ERROR: You must be in the cd3_automation_toolkit directory${NC}"
    echo -e "${YELLOW}  Run: cd <path>/cd3-automation-toolkit/cd3_automation_toolkit${NC}\n"
fi

# Check 2: Virtual Environment
echo -e "${YELLOW}[2] Virtual Environment Check${NC}"
PYTHON_PATH=$(which python3)
echo -e "Python path: ${GREEN}${PYTHON_PATH}${NC}"
if [[ "$PYTHON_PATH" == *"cd3venv"* ]]; then
    echo -e "${GREEN}✓ Virtual environment is activated${NC}\n"
else
    echo -e "${RED}✗ ERROR: Virtual environment is NOT activated${NC}"
    echo -e "${YELLOW}  Run: source ../cd3venv/bin/activate${NC}\n"
fi

# Check 3: Python Version
echo -e "${YELLOW}[3] Python Version Check${NC}"
PYTHON_VERSION=$(python3 --version)
echo -e "Python version: ${GREEN}${PYTHON_VERSION}${NC}\n"

# Check 4: Critical Packages
echo -e "${YELLOW}[4] Required Packages Check${NC}"
packages=("oci" "pandas" "numpy" "oci-cli" "openpyxl" "jinja2")
all_installed=true
for pkg in "${packages[@]}"; do
    if pip show "$pkg" &> /dev/null; then
        version=$(pip show "$pkg" | grep Version | cut -d' ' -f2)
        echo -e "${GREEN}✓ $pkg ($version)${NC}"
    else
        echo -e "${RED}✗ MISSING: $pkg${NC}"
        all_installed=false
    fi
done

if [ "$all_installed" = false ]; then
    echo -e "\n${RED}Some packages are missing!${NC}"
    echo -e "${YELLOW}Install them with:${NC}"
    echo -e "pip install oci-cli openpyxl pandas numpy jinja2\n"
else
    echo -e "\n${GREEN}All critical packages are installed${NC}\n"
fi

# Check 5: ocicloud Module Structure
echo -e "${YELLOW}[5] ocicloud Module Structure Check${NC}"
if [ -d "ocicloud" ]; then
    echo -e "${GREEN}✓ ocicloud directory exists${NC}"
    if [ -f "ocicloud/__init__.py" ]; then
        echo -e "${GREEN}✓ ocicloud/__init__.py exists${NC}"
    else
        echo -e "${RED}✗ ocicloud/__init__.py is missing${NC}"
    fi
    if [ -d "ocicloud/python" ]; then
        echo -e "${GREEN}✓ ocicloud/python directory exists${NC}"
    else
        echo -e "${RED}✗ ocicloud/python directory is missing${NC}"
    fi
else
    echo -e "${RED}✗ ERROR: ocicloud directory not found${NC}"
    echo -e "${YELLOW}  You are probably in the wrong directory!${NC}"
fi
echo ""

# Check 6: Test Import
echo -e "${YELLOW}[6] Python Import Test${NC}"
echo -e "Testing: ${BLUE}from ocicloud.python import ociCommonTools${NC}"

python3 << 'PYTHON_TEST'
import sys
import os

# Add current directory to path (like the CD3 scripts do)
sys.path.insert(0, os.getcwd())

try:
    from ocicloud.python import ociCommonTools
    print("\033[0;32m✓ Import successful!\033[0m")
    exit(0)
except ModuleNotFoundError as e:
    print(f"\033[0;31m✗ Import failed: {e}\033[0m")
    print("\n\033[1;33mMissing package detected. Install it with:\033[0m")
    print(f"\033[1;33mpip install {str(e).split("'")[1]}\033[0m")
    exit(1)
except Exception as e:
    print(f"\033[0;31m✗ Import failed: {e}\033[0m")
    exit(1)
PYTHON_TEST

import_result=$?
echo ""

# Check 7: Summary
echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}   Diagnostic Summary${NC}"
echo -e "${BLUE}========================================${NC}\n"

if [[ $(basename $(pwd)) == "$CORRECT_DIR" ]] && \
   [[ "$PYTHON_PATH" == *"cd3venv"* ]] && \
   [ "$all_installed" = true ] && \
   [ $import_result -eq 0 ]; then
    echo -e "${GREEN}✓✓✓ All checks passed! CD3 should work.${NC}\n"
    echo -e "${GREEN}You can now run:${NC}"
    echo -e "  ${BLUE}python3 setUpOCI.py${NC}"
    echo -e "  ${BLUE}python3 connectCloud.py oci connectOCI.properties${NC}\n"
else
    echo -e "${RED}✗ Some checks failed. Fix the issues above.${NC}\n"
    echo -e "${YELLOW}Quick Fix Checklist:${NC}"
    if [[ $(basename $(pwd)) != "$CORRECT_DIR" ]]; then
        echo -e "1. ${YELLOW}cd <path>/cd3-automation-toolkit/cd3_automation_toolkit${NC}"
    fi
    if [[ "$PYTHON_PATH" != *"cd3venv"* ]]; then
        echo -e "2. ${YELLOW}source ../cd3venv/bin/activate${NC}"
    fi
    if [ "$all_installed" = false ]; then
        echo -e "3. ${YELLOW}pip install oci-cli openpyxl pandas numpy jinja2 PyYAML${NC}"
    fi
    echo ""
fi

echo -e "${BLUE}========================================${NC}\n"
