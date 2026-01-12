# CD3 Quick Reference

> **For experienced users**: Command cheat sheet and common workflows

## Installation

```bash
# Automated setup
./quick_install_cd3.sh

# Manual setup
python3.12 -m venv cd3venv
source cd3venv/bin/activate
pip install -r requirements.txt
oci setup config
```

## Daily Operations

```bash
# Activate environment and navigate
source cd3-automation-toolkit/cd3venv/bin/activate
cd cd3-automation-toolkit/cd3_automation_toolkit

# Run CD3
python setUpOCI.py
```

## Helper Scripts

| Script | Purpose | Example |
|--------|---------|---------|
| `quick_install_cd3.sh` | One-command installation | `./quick_install_cd3.sh` |
| `run_cd3.sh` | Auto-activate and run (macOS) | `./run_cd3.sh` |
| `run_cd3_wsl.sh` | Auto-activate and run (WSL) | `./run_cd3_wsl.sh` |
| `cd3_wsl_complete.sh` | Complete WSL setup helper | `./cd3_wsl_complete.sh` |
| `verify_versions.sh` | Check installation status | `./verify_versions.sh` |
| `diagnose_cd3.sh` | Troubleshoot issues | `./diagnose_cd3.sh` |
| `fix_https_errors.sh` | Fix SSL certificate issues | `./fix_https_errors.sh` |

## Common Workflows

### 1. Generate Infrastructure from Excel

```bash
# Edit Excel template with desired resources
# Run CD3
python setUpOCI.py

# Select option 2: "Create Terraform Files"
# Provide:
#   - Excel file path
#   - Output directory
#   - Resource prefix

# Apply Terraform
cd output
terraform init
terraform plan
terraform apply
```

### 2. Export Existing Infrastructure

```bash
python setUpOCI.py

# Select option 3: "Export OCI Resources"
# Choose compartments to export
# Output: Excel file with current state
```

### 3. Validate Excel Template

```bash
python setUpOCI.py

# Select option 1: "Validate Excel Template"
# Checks for:
#   - Required fields
#   - Valid CIDR blocks
#   - Compartment existence
#   - Name conflicts
```

## Configuration Files

### OCI Config (`~/.oci/config`)

```ini
[DEFAULT]
user=ocid1.user.oc1..aaaaaa...
fingerprint=aa:bb:cc:dd:ee:ff:00:11:22:33:44:55:66:77:88:99
tenancy=ocid1.tenancy.oc1..aaaaaa...
region=us-ashburn-1
key_file=/home/user/.oci/oci_api_key.pem
```

### CD3 Connection (`connectOCI.properties`)

```properties
tenancy_ocid=ocid1.tenancy.oc1..aaaaaa...
user_ocid=ocid1.user.oc1..aaaaaa...
region=us-ashburn-1
key_path=~/.oci/oci_api_key.pem
fingerprint=aa:bb:cc:...
auth_mechanism=api_key
```

### Setup Properties (`setUpOCI.properties`)

```properties
outdir=/path/to/terraform/output
prefix=mycompany
cd3file=/path/to/CD3-Template.xlsx
workflow_type=create_resources
tf_or_tofu=terraform
```

## Troubleshooting Quick Fixes

### ModuleNotFoundError: 'ocicloud'

```bash
# Check directory
pwd  # Must be: .../cd3_automation_toolkit

# Check venv
which python3  # Must contain: cd3venv

# Fix
cd /path/to/cd3-automation-toolkit/cd3_automation_toolkit
source ../cd3venv/bin/activate
```

### SSL Certificate Errors

```bash
./fix_https_errors.sh
# OR
pip install --upgrade certifi
export SSL_CERT_FILE=$(python -m certifi)
```

### OCI Authentication Failed

```bash
# Verify config
cat ~/.oci/config

# Test connection
oci iam region list

# Fix permissions
chmod 600 ~/.oci/oci_api_key.pem
chmod 600 ~/.oci/config

# Regenerate if needed
oci setup config
```

### Python Package Conflicts

```bash
# Recreate venv
deactivate
rm -rf cd3venv
python3.12 -m venv cd3venv
source cd3venv/bin/activate
pip install --upgrade pip
pip install -r requirements.txt
```

## Terraform Commands

```bash
# Initialize
terraform init

# Validate syntax
terraform validate

# Format code
terraform fmt

# Plan changes
terraform plan -out=tfplan

# Apply changes
terraform apply tfplan

# Show current state
terraform show

# List resources
terraform state list

# Destroy all
terraform destroy
```

## OCI CLI Commands

```bash
# List regions
oci iam region list

# List compartments
oci iam compartment list --all

# List VCNs
oci network vcn list --compartment-id <ocid>

# List compute instances
oci compute instance list --compartment-id <ocid>

# Get instance details
oci compute instance get --instance-id <ocid>
```

## Excel Template Tips

### VCN Tab
- **CIDR**: Use /16 or /24 (e.g., 10.0.0.0/16)
- **DNS Label**: Lowercase, no spaces, max 15 chars
- **Subnets**: Must be within VCN CIDR

### Compute Tab
- **Shape**: VM.Standard.E4.Flex recommended
- **Image**: Use image OCID for region
- **SSH Key**: Public key content (not file path)

### Security Lists
- **Stateful**: Most common use case
- **CIDR**: 0.0.0.0/0 for internet access
- **Ports**: 22 (SSH), 80 (HTTP), 443 (HTTPS), 3389 (RDP)

## Environment Variables

```bash
# Python path (if needed)
export PYTHONPATH="${PYTHONPATH}:/path/to/cd3_automation_toolkit"

# OCI config location
export OCI_CONFIG_FILE=~/.oci/config

# Proxy settings
export HTTP_PROXY=http://proxy.company.com:8080
export HTTPS_PROXY=http://proxy.company.com:8080
export NO_PROXY=localhost,127.0.0.1,.oraclecloud.com

# SSL certificate
export SSL_CERT_FILE=$(python -m certifi)
```

## Performance Optimization

### Large Templates
```bash
# Process in batches
# Split Excel into multiple files by resource type
# Run CD3 separately for each

# Example:
python setUpOCI.py --resources network  # Only VCNs
python setUpOCI.py --resources compute  # Only instances
```

### Parallel Terraform
```bash
# Increase parallelism
terraform apply -parallelism=20

# Target specific resources
terraform apply -target=oci_core_vcn.vcn1
```

## CI/CD Integration

### GitLab CI Example

```yaml
variables:
  TF_VERSION: "1.13.0"
  PYTHON_VERSION: "3.12"

stages:
  - validate
  - plan
  - apply

before_script:
  - source cd3venv/bin/activate
  - cd cd3-automation-toolkit/cd3_automation_toolkit

validate:
  stage: validate
  script:
    - python setUpOCI.py --validate-only

plan:
  stage: plan
  script:
    - python setUpOCI.py --generate
    - cd output
    - terraform init
    - terraform plan -out=tfplan
  artifacts:
    paths:
      - output/tfplan

apply:
  stage: apply
  script:
    - cd output
    - terraform apply tfplan
  when: manual
  only:
    - main
```

### GitHub Actions Example

```yaml
name: CD3 Terraform Deploy

on:
  push:
    branches: [main]
  pull_request:
    branches: [main]

jobs:
  terraform:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      
      - name: Setup Python
        uses: actions/setup-python@v4
        with:
          python-version: '3.12'
      
      - name: Install CD3
        run: |
          python -m venv cd3venv
          source cd3venv/bin/activate
          pip install -r requirements.txt
      
      - name: Generate Terraform
        run: |
          source cd3venv/bin/activate
          cd cd3-automation-toolkit/cd3_automation_toolkit
          python setUpOCI.py --auto
      
      - name: Terraform Plan
        run: |
          cd output
          terraform init
          terraform plan
```

## Advanced Usage

### Custom Templates

```bash
# Create custom Jinja2 template
vi cd3_automation_toolkit/templates/my-resource-template.jinja2

# Reference in generation script
from jinja2 import Environment, FileSystemLoader
env = Environment(loader=FileSystemLoader('templates'))
template = env.get_template('my-resource-template.jinja2')
output = template.render(resources=data)
```

### Extend Python Scripts

```python
# Import CD3 utilities
sys.path.append(os.getcwd())
from ocicloud.python.ociCommonTools import *

# Use existing functions
config = get_oci_config()
compartments = get_compartment_list(identity_client, tenancy_ocid)
```

### Batch Operations

```bash
# Process multiple Excel files
for file in templates/*.xlsx; do
    python setUpOCI.py --input "$file" --output "output/${file%.xlsx}"
done

# Combine Terraform outputs
cat output/*/*.tf > combined.tf
```

## Version Requirements

| Component | Minimum Version | Recommended | Notes |
|-----------|----------------|-------------|-------|
| Python | 3.10 | 3.12 | 3.13 not supported |
| Terraform | 1.13 | 1.13+ | Latest stable |
| OCI CLI | 3.66 | 3.66+ | Latest stable |
| pandas | 2.0.3 | 2.0.3 | Exact version |
| numpy | 1.26.4 | 1.26.4 | Exact version |

## Common OCIDs

```bash
# Phoenix region
region=us-phoenix-1

# Ashburn region  
region=us-ashburn-1

# Compartment (root)
compartment_ocid=$(oci iam compartment list --all | jq -r '.data[0].id')

# Latest Oracle Linux image
image_ocid=$(oci compute image list --compartment-id $compartment_ocid \
  --operating-system "Oracle Linux" --limit 1 | jq -r '.data[0].id')
```

## File Locations

```
~/.oci/                              # OCI config directory
  ├── config                         # OCI CLI config
  ├── oci_api_key.pem               # Private key
  └── oci_api_key_public.pem        # Public key

cd3-automation-toolkit/
  ├── cd3venv/                       # Virtual environment
  ├── cd3_automation_toolkit/        # Main application
  │   ├── setUpOCI.py               # Entry point
  │   ├── connectOCI.properties     # Connection config
  │   ├── setUpOCI.properties       # Setup config
  │   └── ocicloud/                 # OCI modules
  └── output/                        # Generated Terraform
```

## Keyboard Shortcuts (in CD3 menu)

- `1` - Validate Excel
- `2` - Create Terraform
- `3` - Export Resources
- `4` - Exit
- `Ctrl+C` - Force quit

## Resource Limits

| Resource Type | OCI Limit | Terraform Limit | Notes |
|---------------|-----------|-----------------|-------|
| VCNs per compartment | 5-300 | No limit | Request increase via console |
| Subnets per VCN | 300 | No limit | - |
| Instances per compartment | Varies by shape | No limit | Check service limits |
| Block volumes | Varies | No limit | - |

## Backup and Recovery

```bash
# Backup Excel templates
cp CD3-Template.xlsx CD3-Template-$(date +%Y%m%d).xlsx

# Backup Terraform state
terraform state pull > terraform.tfstate.backup

# Version control
git init
git add CD3-Template.xlsx
git commit -m "Infrastructure snapshot $(date)"
```

## Security Best Practices

1. **Never commit secrets**
   ```bash
   # Add to .gitignore
   echo "*.pem" >> .gitignore
   echo "connectOCI.properties" >> .gitignore
   echo ".oci/" >> .gitignore
   ```

2. **Rotate API keys** every 90 days
   ```bash
   oci iam api-key create --user-id $USER_OCID
   # Upload new key, delete old key
   ```

3. **Use compartments** for isolation
   - Separate prod/dev/test
   - Apply IAM policies per compartment

4. **Encrypt Terraform state**
   ```bash
   # Use OCI Object Storage with encryption
   terraform {
     backend "s3" {
       bucket = "terraform-state"
       key    = "prod/terraform.tfstate"
       encrypt = true
     }
   }
   ```

## Links

- **CD3 GitHub**: https://github.com/oracle-devrel/cd3-automation-toolkit
- **OCI Docs**: https://docs.oracle.com/en-us/iaas/
- **Terraform OCI**: https://registry.terraform.io/providers/oracle/oci/latest/docs
- **Architecture**: [ARCHITECTURE.md](../ARCHITECTURE.md)
- **Setup Guide**: [SETUP.md](SETUP.md)
- **Troubleshooting**: [TROUBLESHOOTING.md](TROUBLESHOOTING.md)

---

**Quick Start**: `./quick_install_cd3.sh && ./run_cd3.sh`

**Document Version**: 1.0  
**Last Updated**: 2026-01-12
