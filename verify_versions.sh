#!/bin/bash
################################################################################
# CD3 Toolkit - Version Verification Script
# Checks if correct versions are installed
################################################################################

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}╔════════════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║        CD3 Toolkit - Version Verification                  ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════════════════════════╝${NC}\n"

ERRORS=0
WARNINGS=0

# Function to check version
check_version() {
    local name=$1
    local command=$2
    local expected=$3
    local comparison=$4  # "exact", "min", "any"

    echo -e "${BLUE}Checking $name...${NC}"

    if ! command -v $(echo $command | awk '{print $1}') &> /dev/null; then
        echo -e "${RED}✗ $name not found${NC}"
        echo -e "  Install: See SETUP_GUIDE_NO_DOCKER.md\n"
        ((ERRORS++))
        return 1
    fi

    local version=$(eval $command 2>&1 | head -n 1)
    echo -e "${GREEN}✓ $name installed${NC}"
    echo -e "  Version: ${YELLOW}$version${NC}"

    if [ ! -z "$expected" ]; then
        case $comparison in
            "exact")
                if echo "$version" | grep -q "$expected"; then
                    echo -e "  Status: ${GREEN}✓ Matches expected version ($expected)${NC}\n"
                else
                    echo -e "  Status: ${YELLOW}⚠ Version mismatch (expected $expected)${NC}\n"
                    ((WARNINGS++))
                fi
                ;;
            "min")
                echo -e "  Status: ${GREEN}✓ Minimum requirement ($expected)${NC}\n"
                ;;
            "any")
                echo -e "  Status: ${GREEN}✓ Installed${NC}\n"
                ;;
        esac
    else
        echo ""
    fi
}

# Check Python
echo -e "${BLUE}═══════════════════════════════════════════════════════════${NC}"
echo -e "${BLUE}System Components${NC}"
echo -e "${BLUE}═══════════════════════════════════════════════════════════${NC}\n"

PYTHON_VERSION=""
if command -v python3.12 &> /dev/null; then
    check_version "Python 3.12" "python3.12 --version" "3.12" "min"
    PYTHON_VERSION="3.12"
elif command -v python3.10 &> /dev/null; then
    check_version "Python 3.10" "python3.10 --version" "3.10" "min"
    PYTHON_VERSION="3.10"
elif command -v python3.9 &> /dev/null; then
    check_version "Python 3.9" "python3.9 --version" "3.9" "min"
    PYTHON_VERSION="3.9"
    echo -e "${YELLOW}⚠ Python 3.9 is supported but 3.12 or 3.10 recommended${NC}\n"
    ((WARNINGS++))
elif command -v python3 &> /dev/null; then
    check_version "Python 3" "python3 --version" "" "any"
    PYTHON_VERSION=$(python3 --version | grep -oE '[0-9]+\.[0-9]+')
else
    echo -e "${RED}✗ Python 3 not found${NC}\n"
    ((ERRORS++))
fi

# Check Terraform
check_version "Terraform" "terraform version" "1.13" "min"

# Check Git
check_version "Git" "git --version" "" "any"

# Check OCI CLI
check_version "OCI CLI" "oci --version" "3.66" "min"

# Check Virtual Environment
echo -e "${BLUE}═══════════════════════════════════════════════════════════${NC}"
echo -e "${BLUE}Virtual Environment${NC}"
echo -e "${BLUE}═══════════════════════════════════════════════════════════${NC}\n"

VENV_PATH="$HOME/Desktop/Personal_DevOps/CD3/cd3-automation-toolkit/cd3venv"
if [ -d "$VENV_PATH" ]; then
    echo -e "${GREEN}✓ Virtual environment exists${NC}"
    echo -e "  Location: ${YELLOW}$VENV_PATH${NC}"

    if [ -n "$VIRTUAL_ENV" ]; then
        echo -e "  Status: ${GREEN}✓ Currently activated${NC}\n"
    else
        echo -e "  Status: ${YELLOW}○ Not activated${NC}"
        echo -e "  Activate: ${BLUE}source $VENV_PATH/bin/activate${NC}\n"
    fi
else
    echo -e "${YELLOW}⚠ Virtual environment not found${NC}"
    echo -e "  Expected: $VENV_PATH"
    echo -e "  Create: ${BLUE}python${PYTHON_VERSION} -m venv cd3venv${NC}\n"
    ((WARNINGS++))
fi

# Check Python Packages (if venv is active)
if [ -n "$VIRTUAL_ENV" ]; then
    echo -e "${BLUE}═══════════════════════════════════════════════════════════${NC}"
    echo -e "${BLUE}Python Packages (in active venv)${NC}"
    echo -e "${BLUE}═══════════════════════════════════════════════════════════${NC}\n"

    packages=("oci-cli" "pandas" "openpyxl" "xlrd" "Jinja2" "PyYAML" "requests")

    for pkg in "${packages[@]}"; do
        if pip show "$pkg" &> /dev/null; then
            version=$(pip show "$pkg" | grep Version | awk '{print $2}')
            echo -e "${GREEN}✓ $pkg${NC} - ${YELLOW}$version${NC}"
        else
            echo -e "${RED}✗ $pkg${NC} - Not installed"
            ((ERRORS++))
        fi
    done
    echo ""
fi

# Check OCI Configuration
echo -e "${BLUE}═══════════════════════════════════════════════════════════${NC}"
echo -e "${BLUE}OCI Configuration${NC}"
echo -e "${BLUE}═══════════════════════════════════════════════════════════${NC}\n"

if [ -f ~/.oci/config ]; then
    echo -e "${GREEN}✓ OCI config exists${NC}"
    echo -e "  Location: ${YELLOW}~/.oci/config${NC}"

    # Check key file
    key_path=$(grep "key_file" ~/.oci/config | head -n 1 | cut -d'=' -f2 | tr -d ' ' | sed "s|~|$HOME|")
    if [ -f "$key_path" ]; then
        echo -e "${GREEN}✓ Private key exists${NC}"
        echo -e "  Location: ${YELLOW}$key_path${NC}"

        # Check permissions
        perms=$(stat -f "%A" "$key_path" 2>/dev/null || stat -c "%a" "$key_path" 2>/dev/null)
        if [ "$perms" == "600" ]; then
            echo -e "${GREEN}✓ Key permissions correct (600)${NC}\n"
        else
            echo -e "${YELLOW}⚠ Key permissions: $perms (should be 600)${NC}"
            echo -e "  Fix: ${BLUE}chmod 600 $key_path${NC}\n"
            ((WARNINGS++))
        fi
    else
        echo -e "${RED}✗ Private key not found${NC}"
        echo -e "  Expected: $key_path\n"
        ((ERRORS++))
    fi

    # Test connectivity
    echo -e "${BLUE}Testing OCI connectivity...${NC}"
    if oci iam region list --output table &> /dev/null; then
        echo -e "${GREEN}✓ OCI API connection successful${NC}\n"
    else
        echo -e "${RED}✗ OCI API connection failed${NC}"
        echo -e "  Run: ${BLUE}./fix_https_errors.sh${NC}\n"
        ((ERRORS++))
    fi
else
    echo -e "${RED}✗ OCI config not found${NC}"
    echo -e "  Run: ${BLUE}oci setup config${NC}\n"
    ((ERRORS++))
fi

# Check CD3 Configuration
echo -e "${BLUE}═══════════════════════════════════════════════════════════${NC}"
echo -e "${BLUE}CD3 Configuration${NC}"
echo -e "${BLUE}═══════════════════════════════════════════════════════════${NC}\n"

CD3_DIR="$HOME/Desktop/Personal_DevOps/CD3/cd3-automation-toolkit/cd3_automation_toolkit"

if [ -d "$CD3_DIR" ]; then
    echo -e "${GREEN}✓ CD3 directory exists${NC}"
    echo -e "  Location: ${YELLOW}$CD3_DIR${NC}\n"

    # Check property files
    if [ -f "$CD3_DIR/connectOCI.properties" ]; then
        echo -e "${GREEN}✓ connectOCI.properties exists${NC}"
    else
        echo -e "${YELLOW}⚠ connectOCI.properties not found${NC}"
        echo -e "  See: SETUP_GUIDE_NO_DOCKER.md (Post-Installation)${NC}"
        ((WARNINGS++))
    fi

    if [ -f "$CD3_DIR/setUpOCI.properties" ]; then
        echo -e "${GREEN}✓ setUpOCI.properties exists${NC}"
    else
        echo -e "${YELLOW}⚠ setUpOCI.properties not found${NC}"
        echo -e "  See: SETUP_GUIDE_NO_DOCKER.md (Post-Installation)${NC}"
        ((WARNINGS++))
    fi
    echo ""
else
    echo -e "${RED}✗ CD3 directory not found${NC}"
    echo -e "  Expected: $CD3_DIR\n"
    ((ERRORS++))
fi

# Summary
echo -e "${BLUE}═══════════════════════════════════════════════════════════${NC}"
echo -e "${BLUE}Summary${NC}"
echo -e "${BLUE}═══════════════════════════════════════════════════════════${NC}\n"

if [ $ERRORS -eq 0 ] && [ $WARNINGS -eq 0 ]; then
    echo -e "${GREEN}✓ All checks passed!${NC}"
    echo -e "${GREEN}✓ Your CD3 installation is ready to use.${NC}\n"

    echo -e "${BLUE}To run CD3:${NC}"
    if [ -z "$VIRTUAL_ENV" ]; then
        echo -e "  1. source $VENV_PATH/bin/activate"
    fi
    echo -e "  2. cd $CD3_DIR"
    echo -e "  3. python setUpOCI.py\n"

    exit 0
elif [ $ERRORS -eq 0 ]; then
    echo -e "${YELLOW}⚠ $WARNINGS warning(s) found${NC}"
    echo -e "${YELLOW}⚠ CD3 should work but review warnings above.${NC}\n"
    exit 0
else
    echo -e "${RED}✗ $ERRORS error(s) found${NC}"
    if [ $WARNINGS -gt 0 ]; then
        echo -e "${YELLOW}⚠ $WARNINGS warning(s) found${NC}"
    fi
    echo -e "${RED}✗ Please fix errors before using CD3.${NC}\n"

    echo -e "${BLUE}Troubleshooting:${NC}"
    echo -e "  1. Run: ${BLUE}./quick_install_cd3.sh${NC} (Linux/macOS)"
    echo -e "  2. Run: ${BLUE}./fix_https_errors.sh${NC}"
    echo -e "  3. Read: ${BLUE}SETUP_GUIDE_NO_DOCKER.md${NC}\n"

    exit 1
fi
