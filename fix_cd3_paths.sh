#!/bin/bash

# CD3 Path Fix Script
# This script creates a proper Python package structure to fix the ocicloud import issue

set -e

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${GREEN}=== CD3 Path Fix Script ===${NC}\n"

# Get script directory
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
CD3_TOOLKIT="${SCRIPT_DIR}/cd3-automation-toolkit/cd3_automation_toolkit"

if [ ! -d "$CD3_TOOLKIT" ]; then
    echo -e "${YELLOW}Error: CD3 toolkit not found at: $CD3_TOOLKIT${NC}"
    exit 1
fi

cd "$CD3_TOOLKIT"

# Create __init__.py in cd3_automation_toolkit if it doesn't exist
if [ ! -f "__init__.py" ]; then
    echo -e "${GREEN}Creating __init__.py in cd3_automation_toolkit...${NC}"
    touch __init__.py
fi

# Verify ocicloud structure
if [ ! -f "ocicloud/__init__.py" ]; then
    echo -e "${YELLOW}Warning: ocicloud/__init__.py not found${NC}"
else
    echo -e "${GREEN}✓ ocicloud package structure is correct${NC}"
fi

# Create a .pth file in the virtual environment to add cd3_automation_toolkit to Python path
VENV_SITE_PACKAGES=$(find ../cd3venv/lib -type d -name "site-packages" | head -1)

if [ -d "$VENV_SITE_PACKAGES" ]; then
    echo -e "${GREEN}Adding cd3_automation_toolkit to Python path...${NC}"
    echo "$CD3_TOOLKIT" > "$VENV_SITE_PACKAGES/cd3_toolkit.pth"
    echo -e "${GREEN}✓ Created: $VENV_SITE_PACKAGES/cd3_toolkit.pth${NC}"
fi

# Test the import
echo -e "\n${GREEN}Testing Python import...${NC}"
cd "$CD3_TOOLKIT"
source ../cd3venv/bin/activate

python3 -c "import sys; sys.path.insert(0, '.'); from ocicloud.python import ociCommonTools; print('✓ Import successful!')" 2>&1

if [ $? -eq 0 ]; then
    echo -e "\n${GREEN}=== Fix Applied Successfully! ===${NC}"
    echo -e "${GREEN}You can now run CD3 with:${NC}"
    echo -e "  cd ${CD3_TOOLKIT}"
    echo -e "  source ../cd3venv/bin/activate"
    echo -e "  python3 setUpOCI.py"
    echo -e "\n${GREEN}Or simply use: ./run_cd3.sh${NC}"
else
    echo -e "\n${YELLOW}Import test failed. Please check the error above.${NC}"
    exit 1
fi
