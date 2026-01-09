# CD3 Toolkit - HTTPS/SSL Error Troubleshooting Script for Windows
# PowerShell version for fixing common SSL/TLS certificate and connection issues

Write-Host "========================================" -ForegroundColor Blue
Write-Host "CD3 Toolkit - HTTPS Error Fix Script" -ForegroundColor Blue
Write-Host "Windows PowerShell Version" -ForegroundColor Blue
Write-Host "========================================`n" -ForegroundColor Blue

# Check if running as Administrator
$isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
if (-not $isAdmin) {
    Write-Host "⚠ Warning: Not running as Administrator. Some fixes may require elevation.`n" -ForegroundColor Yellow
}

# Step 1: Check Python Installation
Write-Host "Step 1: Checking Python Installation..." -ForegroundColor Blue
try {
    $pythonVersion = python --version
    Write-Host "✓ $pythonVersion" -ForegroundColor Green

    # Check SSL support
    python -c "import ssl; print(f'Python SSL Version: {ssl.OPENSSL_VERSION}')"
    Write-Host "✓ Python SSL support available`n" -ForegroundColor Green
} catch {
    Write-Host "✗ Python not found or SSL issues`n" -ForegroundColor Red
}

# Step 2: Test OCI Connectivity
Write-Host "Step 2: Testing OCI API Connectivity..." -ForegroundColor Blue
try {
    $response = Invoke-WebRequest -Uri "https://identity.us-ashburn-1.oraclecloud.com" -Method Head -TimeoutSec 10
    Write-Host "✓ OCI API reachable (Status: $($response.StatusCode))`n" -ForegroundColor Green
} catch {
    Write-Host "✗ Cannot reach OCI API" -ForegroundColor Red
    Write-Host "Error: $($_.Exception.Message)`n" -ForegroundColor Red
}

# Step 3: Check Proxy Settings
Write-Host "Step 3: Checking Proxy Settings..." -ForegroundColor Blue
$httpProxy = $env:HTTP_PROXY
$httpsProxy = $env:HTTPS_PROXY

if ($httpProxy -or $httpsProxy) {
    Write-Host "Proxy detected:" -ForegroundColor Yellow
    Write-Host "HTTP_PROXY: $httpProxy"
    Write-Host "HTTPS_PROXY: $httpsProxy"
    Write-Host "`nIf behind corporate proxy, ensure NO_PROXY includes:" -ForegroundColor Yellow
    Write-Host "`$env:NO_PROXY='localhost,127.0.0.1,.oraclecloud.com,.oracle.com'"
} else {
    Write-Host "✓ No proxy environment variables set`n" -ForegroundColor Green
}

# Check Windows proxy settings
$proxySettings = Get-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings"
if ($proxySettings.ProxyEnable -eq 1) {
    Write-Host "Windows proxy enabled:" -ForegroundColor Yellow
    Write-Host "Proxy Server: $($proxySettings.ProxyServer)"
    Write-Host "Proxy Override: $($proxySettings.ProxyOverride)`n"
} else {
    Write-Host "✓ Windows proxy disabled`n" -ForegroundColor Green
}

# Step 4: Check OCI Config Directory
Write-Host "Step 4: Checking OCI Configuration..." -ForegroundColor Blue
$ociDir = "$env:USERPROFILE\.oci"
$ociConfig = "$ociDir\config"
$ociKey = "$ociDir\oci_api_key.pem"
$ociPublicKey = "$ociDir\oci_api_key_public.pem"

if (Test-Path $ociDir) {
    Write-Host "✓ OCI directory exists: $ociDir" -ForegroundColor Green

    if (Test-Path $ociConfig) {
        Write-Host "✓ Config file exists: $ociConfig" -ForegroundColor Green

        # Display config (without sensitive data)
        Write-Host "`nConfig contents:" -ForegroundColor Cyan
        Get-Content $ociConfig | Select-String -Pattern "^\[.*\]|^user|^tenancy|^region|^fingerprint" | ForEach-Object {
            Write-Host "  $_" -ForegroundColor Gray
        }
    } else {
        Write-Host "✗ Config file not found`n" -ForegroundColor Red
        Write-Host "Run: oci setup config`n" -ForegroundColor Yellow
    }

    if (Test-Path $ociKey) {
        Write-Host "✓ Private key exists" -ForegroundColor Green
    } else {
        Write-Host "✗ Private key not found: $ociKey" -ForegroundColor Red
    }

    if (Test-Path $ociPublicKey) {
        Write-Host "✓ Public key exists`n" -ForegroundColor Green
    } else {
        Write-Host "✗ Public key not found: $ociPublicKey`n" -ForegroundColor Red
    }
} else {
    Write-Host "✗ OCI directory not found: $ociDir" -ForegroundColor Red
    Write-Host "Run: oci setup config`n" -ForegroundColor Yellow
}

# Step 5: Test OCI CLI
Write-Host "Step 5: Testing OCI CLI..." -ForegroundColor Blue
try {
    $ociVersion = oci --version
    Write-Host "✓ OCI CLI version: $ociVersion" -ForegroundColor Green

    Write-Host "`nTesting authentication..." -ForegroundColor Cyan
    $regions = oci iam region list --output json 2>&1

    if ($LASTEXITCODE -eq 0) {
        Write-Host "✓ OCI CLI authentication successful`n" -ForegroundColor Green
        Write-Host "Available regions:" -ForegroundColor Cyan
        ($regions | ConvertFrom-Json).data | Select-Object -First 5 | ForEach-Object {
            Write-Host "  - $($_.name)" -ForegroundColor Gray
        }
    } else {
        Write-Host "✗ OCI CLI authentication failed" -ForegroundColor Red
        Write-Host "$regions`n" -ForegroundColor Red
    }
} catch {
    Write-Host "✗ OCI CLI not found or error occurred" -ForegroundColor Red
    Write-Host "Install with: pip install oci-cli`n" -ForegroundColor Yellow
}

# Step 6: Update Python Packages
Write-Host "`nStep 6: Checking Python SSL Packages..." -ForegroundColor Blue
Write-Host "Checking certifi, urllib3, requests..." -ForegroundColor Cyan

try {
    pip list | Select-String -Pattern "certifi|urllib3|requests" | ForEach-Object {
        Write-Host "  $_" -ForegroundColor Gray
    }

    Write-Host "`nTo upgrade SSL packages, run:" -ForegroundColor Yellow
    Write-Host "pip install --upgrade certifi urllib3 requests oci-cli`n"
} catch {
    Write-Host "✗ Could not check packages`n" -ForegroundColor Red
}

# Step 7: Test Python HTTPS
Write-Host "Step 7: Testing Python HTTPS..." -ForegroundColor Blue
$testScript = @"
import sys
import ssl
try:
    import certifi
    import requests
    print(f'Requests version: {requests.__version__}')
    print(f'Certifi CA bundle: {certifi.where()}')
    response = requests.get('https://identity.us-ashburn-1.oraclecloud.com', timeout=10)
    print(f'HTTPS Test: SUCCESS (Status: {response.status_code})')
    sys.exit(0)
except Exception as e:
    print(f'HTTPS Test: FAILED - {str(e)}')
    sys.exit(1)
"@

$testScript | python - 2>&1
if ($LASTEXITCODE -eq 0) {
    Write-Host "✓ Python HTTPS working`n" -ForegroundColor Green
} else {
    Write-Host "✗ Python HTTPS issues detected" -ForegroundColor Red
    Write-Host "Run: pip install --upgrade certifi urllib3 requests`n" -ForegroundColor Yellow
}

# Step 8: Test OCI Python SDK
Write-Host "Step 8: Testing OCI Python SDK..." -ForegroundColor Blue
$ociTestScript = @"
import sys
try:
    import oci
    config = oci.config.from_file()
    oci.config.validate_config(config)
    print('✓ OCI config validated')
    identity = oci.identity.IdentityClient(config)
    regions = identity.list_regions()
    print(f'✓ Successfully retrieved {len(regions.data)} regions')
    sys.exit(0)
except Exception as e:
    print(f'✗ Error: {str(e)}')
    sys.exit(1)
"@

$ociTestScript | python - 2>&1
if ($LASTEXITCODE -eq 0) {
    Write-Host "✓ OCI Python SDK working`n" -ForegroundColor Green
} else {
    Write-Host "✗ OCI Python SDK issues`n" -ForegroundColor Red
}

# Step 9: Create OCI Config Validator
Write-Host "Step 9: Creating OCI Config Validator..." -ForegroundColor Blue
$validatorPath = "$ociDir\validate_config.py"
$validatorScript = @"
#!/usr/bin/env python3
"""OCI Configuration Validator for Windows"""
import os
import configparser
from pathlib import Path

def validate_oci_config():
    config_path = Path.home() / '.oci' / 'config'

    if not config_path.exists():
        print(f'✗ Config file not found: {config_path}')
        print('Run: oci setup config')
        return False

    print(f'✓ Config file exists')

    config = configparser.ConfigParser()
    config.read(config_path)

    if 'DEFAULT' not in config:
        print('✗ [DEFAULT] section missing')
        return False

    print('✓ [DEFAULT] section found')

    required_fields = ['user', 'tenancy', 'region', 'key_file', 'fingerprint']

    for field in required_fields:
        if field in config['DEFAULT']:
            value = config['DEFAULT'][field]
            print(f'✓ {field}: {value}')

            if field == 'key_file':
                key_path = Path(value.replace('~', str(Path.home())))
                if not key_path.exists():
                    print(f'  ✗ Key file not found: {key_path}')
                else:
                    print(f'  ✓ Key file exists')
        else:
            print(f'✗ Missing required field: {field}')

    return True

if __name__ == '__main__':
    print('OCI Configuration Validator')
    print('=' * 40)
    validate_oci_config()
"@

if (Test-Path $ociDir) {
    $validatorScript | Out-File -FilePath $validatorPath -Encoding UTF8
    Write-Host "✓ Validator created: $validatorPath" -ForegroundColor Green
    Write-Host "Run with: python $validatorPath`n" -ForegroundColor Cyan
}

# Step 10: Summary and Recommendations
Write-Host "========================================" -ForegroundColor Blue
Write-Host "Summary and Recommendations" -ForegroundColor Blue
Write-Host "========================================`n" -ForegroundColor Blue

Write-Host "If still experiencing HTTPS errors:`n" -ForegroundColor Yellow

Write-Host "1. Set Proxy (if behind corporate proxy):" -ForegroundColor Cyan
Write-Host '   $env:HTTP_PROXY="http://proxy.company.com:8080"'
Write-Host '   $env:HTTPS_PROXY="http://proxy.company.com:8080"'
Write-Host '   $env:NO_PROXY="localhost,127.0.0.1,.oraclecloud.com"'
Write-Host ""

Write-Host "2. Make proxy settings permanent:" -ForegroundColor Cyan
Write-Host '   [System.Environment]::SetEnvironmentVariable("HTTPS_PROXY","http://proxy:8080","User")'
Write-Host ""

Write-Host "3. Update Python packages:" -ForegroundColor Cyan
Write-Host "   pip install --upgrade pip certifi urllib3 requests oci-cli"
Write-Host ""

Write-Host "4. Enable OCI CLI debug mode:" -ForegroundColor Cyan
Write-Host '   $env:OCI_CLI_DEBUG="true"'
Write-Host "   oci iam region list"
Write-Host ""

Write-Host "5. Check firewall:" -ForegroundColor Cyan
Write-Host "   Test-NetConnection -ComputerName identity.us-ashburn-1.oraclecloud.com -Port 443"
Write-Host ""

Write-Host "6. Test DNS resolution:" -ForegroundColor Cyan
Write-Host "   Resolve-DnsName identity.us-ashburn-1.oraclecloud.com"
Write-Host ""

Write-Host "7. Disable Windows Firewall temporarily (testing):" -ForegroundColor Cyan
Write-Host "   Set-NetFirewallProfile -Profile Domain,Public,Private -Enabled False"
Write-Host ""

Write-Host "8. Install/Reinstall certificates:" -ForegroundColor Cyan
Write-Host "   python -m pip install --upgrade certifi"
Write-Host '   python -c "import certifi; print(certifi.where())"'
Write-Host ""

Write-Host "9. Check TLS version:" -ForegroundColor Cyan
Write-Host "   [Net.ServicePointManager]::SecurityProtocol"
Write-Host "   Should include: Tls12, Tls13"
Write-Host ""

Write-Host "10. Validate OCI config:" -ForegroundColor Cyan
Write-Host "    python $validatorPath"
Write-Host ""

Write-Host "========================================" -ForegroundColor Blue
Write-Host "Script completed!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Blue
Write-Host ""
Write-Host "Next steps:" -ForegroundColor Yellow
Write-Host "1. Fix any issues shown above" -ForegroundColor Gray
Write-Host "2. Run: python $validatorPath" -ForegroundColor Gray
Write-Host "3. Test: oci iam region list" -ForegroundColor Gray
Write-Host "4. If working, proceed with CD3 setup" -ForegroundColor Gray
