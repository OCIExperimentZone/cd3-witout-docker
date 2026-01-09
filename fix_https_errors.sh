#!/bin/bash
################################################################################
# CD3 Toolkit - HTTPS/SSL Error Troubleshooting Script
# Fixes common SSL/TLS certificate and connection issues
################################################################################

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}CD3 Toolkit - HTTPS Error Fix Script${NC}"
echo -e "${BLUE}========================================${NC}\n"

# Function to detect OS
detect_os() {
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        if [ -f /etc/os-release ]; then
            . /etc/os-release
            OS=$NAME
            VER=$VERSION_ID
        fi
        echo "linux"
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        echo "macos"
    else
        echo "unknown"
    fi
}

OS_TYPE=$(detect_os)

echo -e "${YELLOW}Detected OS: $OS_TYPE${NC}\n"

# Step 1: Update CA Certificates
echo -e "${BLUE}Step 1: Updating CA Certificates...${NC}"
if [ "$OS_TYPE" == "linux" ]; then
    echo "Updating CA certificates for Linux..."
    if command -v apt-get &> /dev/null; then
        sudo apt-get update
        sudo apt-get install -y ca-certificates openssl
        sudo update-ca-certificates --fresh
    elif command -v yum &> /dev/null; then
        sudo yum install -y ca-certificates openssl
        sudo update-ca-trust force-enable
        sudo update-ca-trust extract
    fi
    echo -e "${GREEN}✓ CA certificates updated${NC}\n"
elif [ "$OS_TYPE" == "macos" ]; then
    echo "Updating CA certificates for macOS..."
    if command -v brew &> /dev/null; then
        brew install openssl ca-certificates
    fi
    echo -e "${GREEN}✓ CA certificates updated${NC}\n"
fi

# Step 2: Check Python SSL Support
echo -e "${BLUE}Step 2: Checking Python SSL Support...${NC}"
python3 -c "import ssl; print(f'Python SSL Version: {ssl.OPENSSL_VERSION}')"
python3 -c "import ssl; ssl.create_default_context()" && echo -e "${GREEN}✓ Python SSL working${NC}\n" || echo -e "${RED}✗ Python SSL issues detected${NC}\n"

# Step 3: Test OCI Connectivity
echo -e "${BLUE}Step 3: Testing OCI API Connectivity...${NC}"
if curl -I https://identity.us-ashburn-1.oraclecloud.com 2>/dev/null | head -n 1; then
    echo -e "${GREEN}✓ OCI API reachable${NC}\n"
else
    echo -e "${RED}✗ Cannot reach OCI API - checking for proxy/firewall issues${NC}\n"
fi

# Step 4: Check Proxy Settings
echo -e "${BLUE}Step 4: Checking Proxy Settings...${NC}"
if [ -n "$HTTP_PROXY" ] || [ -n "$HTTPS_PROXY" ] || [ -n "$http_proxy" ] || [ -n "$https_proxy" ]; then
    echo -e "${YELLOW}Proxy detected:${NC}"
    echo "HTTP_PROXY: $HTTP_PROXY"
    echo "HTTPS_PROXY: $HTTPS_PROXY"
    echo "http_proxy: $http_proxy"
    echo "https_proxy: $https_proxy"
    echo ""
    echo -e "${YELLOW}If behind corporate proxy, ensure NO_PROXY includes:${NC}"
    echo "export NO_PROXY=localhost,127.0.0.1,.oraclecloud.com,.oracle.com"
else
    echo -e "${GREEN}✓ No proxy detected${NC}\n"
fi

# Step 5: Fix OCI CLI Configuration
echo -e "${BLUE}Step 5: Fixing OCI CLI Configuration...${NC}"
if [ -d ~/.oci ]; then
    echo "Setting correct permissions for OCI config files..."
    chmod 700 ~/.oci
    [ -f ~/.oci/config ] && chmod 600 ~/.oci/config
    [ -f ~/.oci/oci_api_key.pem ] && chmod 600 ~/.oci/oci_api_key.pem
    [ -f ~/.oci/oci_api_key_public.pem ] && chmod 644 ~/.oci/oci_api_key_public.pem
    echo -e "${GREEN}✓ OCI permissions fixed${NC}\n"
else
    echo -e "${YELLOW}⚠ ~/.oci directory not found. Run 'oci setup config' first.${NC}\n"
fi

# Step 6: Test OCI CLI
echo -e "${BLUE}Step 6: Testing OCI CLI Connection...${NC}"
if command -v oci &> /dev/null; then
    echo "Testing OCI CLI authentication..."
    if oci iam region list --output table 2>&1; then
        echo -e "${GREEN}✓ OCI CLI working correctly${NC}\n"
    else
        echo -e "${RED}✗ OCI CLI authentication failed${NC}"
        echo -e "${YELLOW}Common issues:${NC}"
        echo "1. Check ~/.oci/config has correct OCIDs"
        echo "2. Verify API key fingerprint matches uploaded key"
        echo "3. Ensure private key file path is correct"
        echo "4. Check if API key is uploaded to OCI Console"
        echo ""
    fi
else
    echo -e "${YELLOW}⚠ OCI CLI not installed. Install with: pip install oci-cli${NC}\n"
fi

# Step 7: Configure Requests/urllib3 for Python
echo -e "${BLUE}Step 7: Configuring Python HTTP Libraries...${NC}"
cat > /tmp/test_ssl.py << 'EOF'
import sys
import ssl
import certifi

try:
    import requests
    print(f"Requests version: {requests.__version__}")
    print(f"Certifi CA bundle: {certifi.where()}")

    # Test HTTPS connection
    response = requests.get('https://identity.us-ashburn-1.oraclecloud.com', timeout=10)
    print(f"HTTPS Test: SUCCESS (Status: {response.status_code})")
    sys.exit(0)
except Exception as e:
    print(f"HTTPS Test: FAILED - {str(e)}")
    sys.exit(1)
EOF

if python3 /tmp/test_ssl.py; then
    echo -e "${GREEN}✓ Python HTTPS working${NC}\n"
else
    echo -e "${YELLOW}⚠ Python HTTPS issues detected. Installing/upgrading required packages...${NC}"
    pip install --upgrade certifi urllib3 requests
    echo ""
fi
rm -f /tmp/test_ssl.py

# Step 8: Create OCI Config Validator Script
echo -e "${BLUE}Step 8: Creating OCI Config Validator...${NC}"
cat > ~/.oci/validate_config.py << 'EOF'
#!/usr/bin/env python3
"""
OCI Configuration Validator
Checks ~/.oci/config for common issues
"""
import os
import configparser
from pathlib import Path

RED = '\033[0;31m'
GREEN = '\033[0;32m'
YELLOW = '\033[1;33m'
NC = '\033[0m'

def validate_oci_config():
    config_path = Path.home() / '.oci' / 'config'

    if not config_path.exists():
        print(f"{RED}✗ Config file not found: {config_path}{NC}")
        print(f"{YELLOW}Run: oci setup config{NC}")
        return False

    print(f"{GREEN}✓ Config file exists{NC}")

    config = configparser.ConfigParser()
    config.read(config_path)

    if 'DEFAULT' not in config:
        print(f"{RED}✗ [DEFAULT] section missing{NC}")
        return False

    print(f"{GREEN}✓ [DEFAULT] section found{NC}")

    required_fields = ['user', 'tenancy', 'region', 'key_file', 'fingerprint']

    for field in required_fields:
        if field in config['DEFAULT']:
            value = config['DEFAULT'][field]
            print(f"{GREEN}✓ {field}: {value}{NC}")

            # Validate key file exists
            if field == 'key_file':
                key_path = Path(value.replace('~', str(Path.home())))
                if not key_path.exists():
                    print(f"{RED}  ✗ Key file not found: {key_path}{NC}")
                else:
                    # Check permissions
                    stat = key_path.stat()
                    mode = oct(stat.st_mode)[-3:]
                    if mode != '600':
                        print(f"{YELLOW}  ⚠ Key file permissions: {mode} (should be 600){NC}")
                        print(f"  Run: chmod 600 {key_path}")
                    else:
                        print(f"{GREEN}  ✓ Key file permissions correct{NC}")
        else:
            print(f"{RED}✗ Missing required field: {field}{NC}")

    return True

if __name__ == '__main__':
    print("OCI Configuration Validator")
    print("=" * 40)
    validate_oci_config()
EOF

chmod +x ~/.oci/validate_config.py
echo -e "${GREEN}✓ Validator created at: ~/.oci/validate_config.py${NC}"
echo -e "${BLUE}Run with: python3 ~/.oci/validate_config.py${NC}\n"

# Step 9: Test Actual OCI API Call
echo -e "${BLUE}Step 9: Testing OCI API with Python SDK...${NC}"
cat > /tmp/test_oci_sdk.py << 'EOF'
#!/usr/bin/env python3
import sys
try:
    import oci

    # Load default config
    config = oci.config.from_file()

    # Validate config
    oci.config.validate_config(config)
    print("✓ OCI config validated")

    # Try to create identity client
    identity = oci.identity.IdentityClient(config)

    # Test API call
    regions = identity.list_regions()
    print(f"✓ Successfully retrieved {len(regions.data)} regions")
    print("\nAvailable Regions:")
    for region in regions.data[:5]:  # Show first 5
        print(f"  - {region.name}")

    sys.exit(0)
except oci.exceptions.ConfigFileNotFound:
    print("✗ OCI config file not found. Run: oci setup config")
    sys.exit(1)
except oci.exceptions.InvalidConfig as e:
    print(f"✗ Invalid OCI configuration: {e}")
    sys.exit(1)
except oci.exceptions.ServiceError as e:
    print(f"✗ OCI API Error: {e.message}")
    print(f"  Status: {e.status}")
    sys.exit(1)
except Exception as e:
    print(f"✗ Error: {str(e)}")
    import traceback
    traceback.print_exc()
    sys.exit(1)
EOF

if python3 /tmp/test_oci_sdk.py; then
    echo -e "${GREEN}✓ OCI Python SDK working correctly${NC}\n"
else
    echo -e "${RED}✗ OCI Python SDK issues detected${NC}\n"
fi
rm -f /tmp/test_oci_sdk.py

# Step 10: Summary and Recommendations
echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}Summary and Recommendations${NC}"
echo -e "${BLUE}========================================${NC}\n"

echo -e "${YELLOW}If still experiencing HTTPS errors:${NC}\n"

echo "1. Corporate Proxy Issues:"
echo "   Add to ~/.bashrc or ~/.zshrc:"
echo "   export HTTPS_PROXY=http://proxy.company.com:8080"
echo "   export NO_PROXY=localhost,127.0.0.1,.oraclecloud.com"
echo ""

echo "2. Certificate Issues:"
echo "   export REQUESTS_CA_BUNDLE=/etc/ssl/certs/ca-certificates.crt"
echo "   export SSL_CERT_FILE=/etc/ssl/certs/ca-certificates.crt"
echo ""

echo "3. OCI CLI Debug Mode:"
echo "   export OCI_CLI_DEBUG=true"
echo "   oci iam region list"
echo ""

echo "4. Python Requests Debug:"
echo "   python3 -c 'import requests; requests.get(\"https://identity.us-ashburn-1.oraclecloud.com\")'"
echo ""

echo "5. Disable SSL Verification (TESTING ONLY - NOT RECOMMENDED):"
echo "   Add to connectOCI.properties (if desperate):"
echo "   # WARNING: Insecure!"
echo ""

echo "6. Check Firewall Rules:"
echo "   Ensure outbound HTTPS (443) to *.oraclecloud.com is allowed"
echo ""

echo "7. DNS Issues:"
echo "   Test: ping identity.us-ashburn-1.oraclecloud.com"
echo "   Update DNS: Use 8.8.8.8 or 1.1.1.1"
echo ""

echo -e "${GREEN}Run OCI config validator:${NC}"
echo "python3 ~/.oci/validate_config.py"
echo ""

echo -e "${BLUE}========================================${NC}"
echo -e "${GREEN}Script completed!${NC}"
echo -e "${BLUE}========================================${NC}"
