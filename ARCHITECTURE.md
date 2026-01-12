# CD3 Automation Toolkit - Architecture Overview

> **Target Audience**: Infrastructure architects, senior DevOps engineers, and cloud professionals with 10+ years of experience.

## Executive Summary

CD3 (Cloud Deployment & Design) is an infrastructure-as-code (IaC) automation toolkit that bridges Excel-based infrastructure design and Terraform provisioning for Oracle Cloud Infrastructure (OCI). It provides bi-directional transformation: Excel → Terraform (provisioning) and OCI → Excel (documentation/migration).

**Core Value Proposition**: Enables non-developer stakeholders to participate in infrastructure design while maintaining IaC best practices.

---

## High-Level Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│                    CD3 Automation Toolkit                       │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  ┌──────────────┐         ┌──────────────┐                     │
│  │ Excel Reader │────────▶│   Template   │                     │
│  │  (openpyxl)  │         │    Engine    │                     │
│  └──────────────┘         │  (Jinja2)    │                     │
│                           └───────┬──────┘                      │
│                                   │                             │
│                                   ▼                             │
│  ┌──────────────┐         ┌──────────────┐                     │
│  │  OCI SDK     │◀───────▶│  Core Engine │                     │
│  │  (oci-cli)   │         │  (Python)    │                     │
│  └──────────────┘         └───────┬──────┘                      │
│                                   │                             │
│                                   ▼                             │
│  ┌──────────────┐         ┌──────────────┐                     │
│  │  Terraform   │◀────────│   TF Code    │                     │
│  │   Provider   │         │  Generator   │                     │
│  └──────────────┘         └──────────────┘                      │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
         │                                    │
         ▼                                    ▼
  ┌─────────────┐                    ┌──────────────┐
  │ OCI Console │                    │  Terraform   │
  │   (Read)    │                    │   State      │
  └─────────────┘                    └──────────────┘
```

---

## System Components

### 1. Core Engine (`cd3_automation_toolkit/`)
- **Language**: Python 3.10/3.12
- **Entry Point**: `setUpOCI.py`
- **Key Modules**:
  - `ocicloud/`: OCI SDK wrappers and abstraction layer
  - `user-scripts/`: Resource-specific generators (VCN, compute, security, etc.)
  - Template files: Jinja2 templates for Terraform code generation

### 2. Dependencies
```
Core:
  - Python: 3.10 or 3.12 (3.13 incompatible due to numpy)
  - Terraform: 1.13+
  - OCI CLI: 3.66+

Python Packages:
  - oci-cli: Oracle Cloud SDK
  - pandas/numpy: Data manipulation
  - openpyxl: Excel processing
  - Jinja2: Template engine
  - requests: HTTP client
  - netaddr: Network calculations
```

### 3. Data Flow

#### Provisioning Flow (Excel → OCI)
```
Excel Template → Parser → Validation → Terraform Generation → terraform apply → OCI Resources
```

#### Export Flow (OCI → Excel)
```
OCI Resources → API Query → Data Transformation → Excel Generation → Documentation
```

---

## Deployment Patterns

### Pattern 1: Standalone Installation (Recommended)
```bash
# No Docker, direct Python virtual environment
python3.12 -m venv cd3venv
source cd3venv/bin/activate
pip install -r requirements.txt
```

**Use Cases**: 
- Development environments
- CI/CD integration
- Air-gapped environments

### Pattern 2: WSL Integration
```bash
# Windows Subsystem for Linux
# Allows Windows users to run Linux-based CD3
```

**Use Cases**:
- Windows enterprise environments
- Developers on Windows workstations

---

## Integration Points

### 1. OCI Authentication
```
Method: API Key Authentication
Config: ~/.oci/config
Required: 
  - Tenancy OCID
  - User OCID
  - API key pair (RSA)
  - Fingerprint
```

### 2. Terraform Backend
```
State Management: Local or OCI Object Storage
Remote Backend: Configurable for team collaboration
```

### 3. Excel Template Structure
```
Workbook Tabs:
  - Variables: Global configuration
  - VCN: Network topology
  - Instances: Compute resources
  - Block Volumes: Storage
  - Security Lists: Firewall rules
  - Load Balancers: Traffic distribution
  ... (additional resource types)
```

---

## Key Technical Decisions

### Why Python?
- Native OCI SDK support
- Rich ecosystem for data manipulation (pandas)
- Template engine availability (Jinja2)
- Cross-platform compatibility

### Why Excel as Input?
- Low barrier to entry for non-technical stakeholders
- Familiar interface for infrastructure architects
- Enables bulk operations and patterns
- Easy version control with Git (when exported to CSV)

### Why Not Docker?
This fork specifically removes Docker dependency for:
- Reduced complexity in corporate environments
- Better IDE integration for development
- Easier debugging and customization
- Lighter resource footprint

---

## Security Considerations

### Credentials Management
- **API Keys**: Stored in `~/.oci/` with 600 permissions
- **Never commit**: Keys, tenancy OCIDs, or sensitive data to Git
- **Rotation**: Follow OCI best practices for key rotation

### Network Security
- **SSL/TLS**: All OCI API calls use HTTPS
- **Proxy Support**: Corporate proxy configuration available
- **Firewall**: No inbound connections required

### Terraform State
- **Contains Secrets**: SSH keys, passwords may be in state
- **Encryption**: Use OCI Object Storage with encryption at rest
- **Access Control**: Restrict state file access via IAM

---

## Performance Characteristics

### Resource Discovery (Export)
- **Small Tenancy** (<100 resources): 2-5 minutes
- **Medium Tenancy** (100-1000 resources): 5-15 minutes
- **Large Tenancy** (>1000 resources): 15-45 minutes

**Bottleneck**: OCI API rate limits

### Terraform Generation
- **Small Template** (<50 resources): <1 minute
- **Large Template** (>500 resources): 1-3 minutes

**Bottleneck**: Jinja2 template rendering

---

## Extension Points

### Adding New Resource Types
1. Create Jinja2 template in `templates/`
2. Add parser in `user-scripts/`
3. Update Excel template with new tab
4. Register in `setUpOCI.properties`

### Custom Validation Rules
```python
# Add to user-scripts/validation.py
def validate_custom_rule(data):
    # Your validation logic
    pass
```

### Alternative Input Formats
Current: Excel  
Possible: YAML, JSON, HCL (requires parser modification)

---

## Operational Considerations

### CI/CD Integration
```yaml
# Example GitLab CI
stages:
  - validate
  - plan
  - apply

validate:
  script:
    - source cd3venv/bin/activate
    - python setUpOCI.py --validate-only

plan:
  script:
    - terraform plan -out=tfplan

apply:
  script:
    - terraform apply tfplan
  when: manual
```

### Disaster Recovery
- **Excel Templates**: Version control in Git
- **Terraform State**: Backup to OCI Object Storage
- **API Keys**: Secure offline backup

### Monitoring
- **OCI Audit Logs**: Track all API calls
- **Terraform Outputs**: Resource IDs and endpoints
- **CD3 Logs**: Debug information in console output

---

## Comparison with Alternatives

| Tool | CD3 | Terraform Alone | OCI Resource Manager | Ansible |
|------|-----|-----------------|----------------------|---------|
| **Learning Curve** | Low | High | Medium | Medium |
| **Bulk Operations** | Excellent | Manual | Good | Good |
| **Non-technical Users** | Yes | No | Limited | No |
| **State Management** | Terraform | Terraform | OCI-managed | Stateless |
| **Multi-cloud** | No | Yes | No | Yes |
| **OCI-specific** | Yes | No | Yes | No |

**CD3 Sweet Spot**: Organizations with mixed technical teams needing bulk OCI provisioning.

---

## Known Limitations

1. **OCI-Only**: No multi-cloud support
2. **Resource Coverage**: Not all OCI resources supported (60-70% coverage)
3. **Python Version**: Requires 3.10 or 3.12 (numpy/pandas compatibility)
4. **Excel Dependencies**: Requires specific template format
5. **No GUI**: Command-line interface only

---

## Troubleshooting Decision Tree

```
Error Occurred?
├─ ModuleNotFoundError: 'ocicloud'
│  ├─ Check: Virtual environment activated?
│  ├─ Check: Running from cd3_automation_toolkit/?
│  └─ Solution: source ../cd3venv/bin/activate && cd to correct directory
│
├─ SSL/HTTPS Errors
│  └─ Solution: ./fix_https_errors.sh
│
├─ OCI Authentication Failed
│  ├─ Check: ~/.oci/config exists?
│  ├─ Check: API key uploaded to OCI console?
│  └─ Solution: oci setup config
│
└─ Terraform Errors
   ├─ Check: terraform init run?
   ├─ Check: OCI provider version?
   └─ Solution: terraform init -upgrade
```

---

## Quick Reference Commands

```bash
# Setup (one-time)
./quick_install_cd3.sh

# Daily usage
source cd3-automation-toolkit/cd3venv/bin/activate
cd cd3-automation-toolkit/cd3_automation_toolkit
python setUpOCI.py

# Export existing infrastructure
# Select option 3 in menu

# Generate new infrastructure
# Select option 2 in menu

# Verify installation
./verify_versions.sh

# Diagnose issues
./diagnose_cd3.sh
```

---

## Additional Resources

- **Official CD3 Repo**: https://github.com/oracle-devrel/cd3-automation-toolkit
- **OCI Terraform Provider**: https://registry.terraform.io/providers/oracle/oci/latest
- **OCI Documentation**: https://docs.oracle.com/en-us/iaas/
- **Terraform Documentation**: https://www.terraform.io/docs

---

## Contributing

For developers extending CD3:
- See [CONTRIBUTING.md](CONTRIBUTING.md) for development guidelines
- Python code style: PEP 8
- Template format: Jinja2 with consistent indentation
- Testing: Manual validation against test OCI tenancy

---

**Document Version**: 1.0  
**Last Updated**: 2026-01-12  
**Maintained By**: CD3 Community
