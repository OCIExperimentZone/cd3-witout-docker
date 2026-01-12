#!/bin/bash

# CD3 Runner Script - Ensures proper environment setup
# This script activates the virtual environment and runs CD3 from the correct directory

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}=== CD3 Automation Toolkit Runner ===${NC}\n"

# Get the directory where this script is located
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
CD3_BASE="${SCRIPT_DIR}/cd3-automation-toolkit"
CD3_TOOLKIT="${CD3_BASE}/cd3_automation_toolkit"
VENV="${CD3_BASE}/cd3venv"

# Check if cd3-automation-toolkit exists
if [ ! -d "$CD3_TOOLKIT" ]; then
    echo -e "${RED}Error: cd3_automation_toolkit directory not found at: $CD3_TOOLKIT${NC}"
    echo -e "${YELLOW}Please ensure CD3 is installed correctly.${NC}"
    exit 1
fi

# Check if virtual environment exists
if [ ! -d "$VENV" ]; then
    echo -e "${RED}Error: Virtual environment not found at: $VENV${NC}"
    echo -e "${YELLOW}Please run: ./quick_install_cd3.sh${NC}"
    exit 1
fi

# Activate virtual environment
echo -e "${GREEN}Activating virtual environment...${NC}"
source "${VENV}/bin/activate"

# Verify Python is from venv
PYTHON_PATH=$(which python3)
if [[ "$PYTHON_PATH" != *"cd3venv"* ]]; then
    echo -e "${RED}Warning: Virtual environment may not be activated correctly${NC}"
    echo -e "Python path: $PYTHON_PATH"
fi

# Change to CD3 toolkit directory (CRITICAL!)
echo -e "${GREEN}Changing to CD3 toolkit directory...${NC}"
cd "$CD3_TOOLKIT"

# Set PYTHONPATH to include current directory
export PYTHONPATH="${CD3_TOOLKIT}:${PYTHONPATH}"

# Display current setup
echo -e "${GREEN}Current directory:${NC} $(pwd)"
echo -e "${GREEN}Python version:${NC} $(python3 --version)"
echo -e "${GREEN}Python path:${NC} $(which python3)"
echo -e "\n${GREEN}=== Ready to run CD3 ===${NC}\n"

# If arguments provided, run them, otherwise run setUpOCI.py
if [ $# -eq 0 ]; then
    echo -e "${YELLOW}Running: python3 setUpOCI.py${NC}\n"
    python3 setUpOCI.py
else
    echo -e "${YELLOW}Running: python3 $@${NC}\n"
    python3 "$@"
fi
