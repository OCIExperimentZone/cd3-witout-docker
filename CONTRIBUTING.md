# Contributing to CD3 Automation Toolkit

Thank you for your interest in contributing to CD3! This guide will help you get started with development, customization, and contributions.

## Table of Contents

- [Development Setup](#development-setup)
- [Project Structure](#project-structure)
- [Coding Standards](#coding-standards)
- [Adding New Resource Types](#adding-new-resource-types)
- [Testing Guidelines](#testing-guidelines)
- [Submitting Changes](#submitting-changes)

---

## Development Setup

### Prerequisites

- Python 3.10 or 3.12
- Git
- An OCI account for testing
- Familiarity with Terraform and Jinja2 templates

### Setting Up Development Environment

```bash
# Clone the repository
git clone https://github.com/oracle-devrel/cd3-automation-toolkit.git
cd cd3-automation-toolkit

# Create virtual environment
python3.12 -m venv cd3venv
source cd3venv/bin/activate

# Install dependencies
pip install --upgrade pip
pip install -r requirements.txt

# Install development dependencies (optional)
pip install pytest black flake8 mypy
```

### IDE Setup

**Recommended**: VS Code or PyCharm

**VS Code Extensions**:
- Python
- Pylance
- Jinja2
- Terraform

**PyCharm Settings**:
- Enable Python virtual environment: Settings → Project → Python Interpreter
- Enable Jinja2 template support

---

## Project Structure

```
cd3-automation-toolkit/
├── cd3_automation_toolkit/         # Main application
│   ├── setUpOCI.py                # Entry point
│   ├── ocicloud/                  # OCI SDK wrappers
│   │   └── python/                # Python modules
│   │       ├── ociCommonTools.py  # Common utilities
│   │       └── [resource]Tools.py # Resource-specific tools
│   ├── user-scripts/              # Generation scripts
│   │   ├── createTenancyConfig.py # Tenancy setup
│   │   ├── create[Resource].py    # Resource generators
│   │   └── export[Resource].py    # Resource exporters
│   └── templates/                 # Jinja2 templates
│       └── [resource]-template.jinja2
├── docs/                          # Documentation
├── requirements.txt               # Python dependencies
└── README.md                      # Main documentation
```

### Key Directories

| Directory | Purpose | When to Modify |
|-----------|---------|----------------|
| `ocicloud/python/` | OCI API wrappers | Adding API functionality |
| `user-scripts/` | Generation/export logic | Adding new resources |
| `templates/` | Terraform templates | Changing Terraform output |
| `docs/` | Documentation | Improving docs |

---

## Coding Standards

### Python Style Guide

We follow **PEP 8** with some modifications:

```python
# Good: Descriptive names, proper spacing
def create_vcn_terraform(vcn_data: dict, region: str) -> str:
    """
    Generate Terraform code for VCN creation.
    
    Args:
        vcn_data: Dictionary containing VCN configuration
        region: OCI region identifier
        
    Returns:
        Terraform HCL code as string
    """
    template = load_template("vcn-template.jinja2")
    return template.render(vcn=vcn_data, region=region)

# Bad: Single-letter variables, no docstring
def c(v,r):
    t=load_template("vcn-template.jinja2")
    return t.render(vcn=v,region=r)
```

### Code Formatting

```bash
# Format code with black
black cd3_automation_toolkit/

# Check style with flake8
flake8 cd3_automation_toolkit/ --max-line-length=120

# Type checking with mypy (optional)
mypy cd3_automation_toolkit/
```

### Git Commit Messages

```bash
# Good commit messages
git commit -m "feat: Add support for Oracle Functions resource"
git commit -m "fix: Handle empty subnet CIDR in VCN template"
git commit -m "docs: Update SETUP.md with macOS M1 instructions"

# Bad commit messages
git commit -m "updates"
git commit -m "fixed stuff"
git commit -m "wip"
```

**Commit Message Format**:
```
<type>: <subject>

<optional body>

<optional footer>
```

**Types**:
- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation changes
- `style`: Code style changes (formatting, etc.)
- `refactor`: Code refactoring
- `test`: Adding tests
- `chore`: Maintenance tasks

---

## Adding New Resource Types

### Step-by-Step Guide

Let's add support for a new OCI resource (example: Oracle Functions).

#### 1. Create Jinja2 Template

**File**: `cd3_automation_toolkit/templates/functions-template.jinja2`

```jinja2
{# Oracle Functions Terraform Template #}
{% for function in functions %}
resource "oci_functions_application" "{{ function.app_name }}" {
  compartment_id = {{ function.compartment_ocid }}
  display_name   = "{{ function.app_name }}"
  subnet_ids     = [{{ function.subnet_ocid }}]
  
  {% if function.config %}
  config = {
    {% for key, value in function.config.items() %}
    "{{ key }}" = "{{ value }}"
    {% endfor %}
  }
  {% endif %}
}

resource "oci_functions_function" "{{ function.name }}" {
  application_id = oci_functions_application.{{ function.app_name }}.id
  display_name   = "{{ function.name }}"
  image          = "{{ function.image }}"
  memory_in_mbs  = {{ function.memory_mb }}
  timeout_in_seconds = {{ function.timeout }}
}
{% endfor %}
```

#### 2. Create Parser Script

**File**: `cd3_automation_toolkit/user-scripts/createFunctions.py`

```python
#!/usr/bin/env python3
"""
Generate Terraform for Oracle Functions from Excel template.
"""

import os
import sys
import pandas as pd
from jinja2 import Environment, FileSystemLoader

# Add parent directory to path for imports
sys.path.append(os.getcwd())
from ocicloud.python.ociCommonTools import *

def create_functions(excel_file, output_dir, prefix):
    """
    Parse Functions sheet from Excel and generate Terraform.
    
    Args:
        excel_file: Path to CD3 Excel template
        output_dir: Directory for Terraform output
        prefix: Prefix for resource names
    """
    # Read Excel sheet
    df = pd.read_excel(excel_file, sheet_name='Functions', engine='openpyxl')
    
    # Validate required columns
    required_cols = ['Region', 'Compartment', 'Application Name', 
                     'Function Name', 'Image', 'Memory MB', 'Timeout']
    missing_cols = [col for col in required_cols if col not in df.columns]
    if missing_cols:
        raise ValueError(f"Missing required columns: {missing_cols}")
    
    # Process each row
    functions = []
    for idx, row in df.iterrows():
        if pd.isna(row['Function Name']):
            continue  # Skip empty rows
            
        function = {
            'region': row['Region'],
            'compartment_ocid': row['Compartment'],
            'app_name': row['Application Name'],
            'name': row['Function Name'],
            'image': row['Image'],
            'memory_mb': row['Memory MB'],
            'timeout': row['Timeout'],
            'config': {}
        }
        
        # Parse optional config columns
        if 'Config' in row and not pd.isna(row['Config']):
            # Expected format: "KEY1=VALUE1,KEY2=VALUE2"
            for pair in row['Config'].split(','):
                if '=' in pair:
                    key, value = pair.split('=', 1)
                    function['config'][key.strip()] = value.strip()
        
        functions.append(function)
    
    # Load template
    template_dir = os.path.join(os.getcwd(), 'templates')
    env = Environment(loader=FileSystemLoader(template_dir))
    template = env.get_template('functions-template.jinja2')
    
    # Render Terraform
    terraform_code = template.render(functions=functions)
    
    # Write output
    output_file = os.path.join(output_dir, f'{prefix}_functions.tf')
    with open(output_file, 'w') as f:
        f.write(terraform_code)
    
    print(f"✓ Generated {output_file}")
    return len(functions)

if __name__ == "__main__":
    # Command-line interface
    import argparse
    parser = argparse.ArgumentParser(description='Generate Functions Terraform')
    parser.add_argument('excel_file', help='Path to CD3 Excel template')
    parser.add_argument('output_dir', help='Output directory for Terraform files')
    parser.add_argument('--prefix', default='cd3', help='Resource name prefix')
    
    args = parser.parse_args()
    count = create_functions(args.excel_file, args.output_dir, args.prefix)
    print(f"Generated Terraform for {count} functions")
```

#### 3. Create Exporter Script

**File**: `cd3_automation_toolkit/user-scripts/exportFunctions.py`

```python
#!/usr/bin/env python3
"""
Export Oracle Functions from OCI to Excel template.
"""

import os
import sys
import pandas as pd
import oci

sys.path.append(os.getcwd())
from ocicloud.python.ociCommonTools import *

def export_functions(config_file, output_excel):
    """
    Export Functions from OCI to Excel.
    
    Args:
        config_file: Path to OCI config file
        output_excel: Path to output Excel file
    """
    # Initialize OCI client
    config = oci.config.from_file(config_file)
    functions_client = oci.functions.FunctionsManagementClient(config)
    
    # Get compartments
    identity_client = oci.identity.IdentityClient(config)
    compartments = get_compartment_list(identity_client, config['tenancy'])
    
    # Collect all functions
    functions_data = []
    
    for compartment in compartments:
        try:
            # Get applications
            apps = functions_client.list_applications(
                compartment_id=compartment.id
            ).data
            
            for app in apps:
                # Get functions in application
                funcs = functions_client.list_functions(
                    application_id=app.id
                ).data
                
                for func in funcs:
                    functions_data.append({
                        'Region': config['region'],
                        'Compartment': compartment.name,
                        'Application Name': app.display_name,
                        'Function Name': func.display_name,
                        'Image': func.image,
                        'Memory MB': func.memory_in_mbs,
                        'Timeout': func.timeout_in_seconds,
                        'Config': ','.join([f"{k}={v}" for k, v in func.config.items()])
                    })
        except oci.exceptions.ServiceError as e:
            print(f"Warning: Could not access {compartment.name}: {e.message}")
            continue
    
    # Create DataFrame and write to Excel
    df = pd.DataFrame(functions_data)
    
    # Write to Excel (append to existing file or create new)
    with pd.ExcelWriter(output_excel, mode='a', engine='openpyxl') as writer:
        df.to_excel(writer, sheet_name='Functions', index=False)
    
    print(f"✓ Exported {len(functions_data)} functions to {output_excel}")
    return len(functions_data)
```

#### 4. Update Excel Template

Add a new sheet called "Functions" with columns:
- Region
- Compartment
- Application Name
- Function Name
- Image
- Memory MB
- Timeout
- Config (optional)

#### 5. Register in Main Script

**File**: `cd3_automation_toolkit/setUpOCI.py`

Add import and menu option:

```python
# Add to imports
from user-scripts.createFunctions import create_functions
from user-scripts.exportFunctions import export_functions

# Add to resource menu
RESOURCE_TYPES = {
    # ... existing resources ...
    'functions': {
        'name': 'Oracle Functions',
        'create': create_functions,
        'export': export_functions
    }
}
```

#### 6. Test Your Addition

```bash
# Activate environment
source cd3venv/bin/activate
cd cd3_automation_toolkit

# Test creation
python user-scripts/createFunctions.py test-template.xlsx ./output --prefix test

# Test export
python user-scripts/exportFunctions.py ~/.oci/config output.xlsx

# Verify Terraform syntax
cd output
terraform init
terraform validate
```

---

## Testing Guidelines

### Manual Testing Checklist

Before submitting changes:

- [ ] Virtual environment activates without errors
- [ ] Excel parsing handles empty rows
- [ ] Template renders valid Terraform syntax
- [ ] Generated Terraform passes `terraform validate`
- [ ] Export captures all expected fields
- [ ] Error messages are helpful and clear
- [ ] Documentation is updated

### Test in Isolated Environment

```bash
# Create test tenancy/compartment
oci iam compartment create --name "CD3-Testing" --description "CD3 development tests"

# Test your changes
python setUpOCI.py

# Clean up
terraform destroy
oci iam compartment delete --compartment-id [test-compartment-ocid]
```

### Edge Cases to Test

1. **Empty Values**: Excel cells with no data
2. **Special Characters**: Names with spaces, hyphens, underscores
3. **Large Datasets**: 100+ resources in one sheet
4. **Unicode**: Non-ASCII characters in names/descriptions
5. **API Limits**: Rate limiting, pagination

---

## Submitting Changes

### Pull Request Process

1. **Fork the Repository**
   ```bash
   # On GitHub, click "Fork"
   git clone https://github.com/YOUR-USERNAME/cd3-automation-toolkit.git
   ```

2. **Create Feature Branch**
   ```bash
   git checkout -b feat/add-oracle-functions
   ```

3. **Make Changes**
   - Write code
   - Add tests
   - Update documentation

4. **Commit Changes**
   ```bash
   git add .
   git commit -m "feat: Add support for Oracle Functions"
   ```

5. **Push to Fork**
   ```bash
   git push origin feat/add-oracle-functions
   ```

6. **Open Pull Request**
   - Go to GitHub
   - Click "New Pull Request"
   - Fill in description template

### Pull Request Template

```markdown
## Description
Brief description of changes

## Motivation
Why is this change needed?

## Changes Made
- Added Functions template
- Created createFunctions.py script
- Updated setUpOCI.py menu

## Testing
- [ ] Tested with sample Excel file
- [ ] Terraform validates successfully
- [ ] Export functionality works
- [ ] Documentation updated

## Screenshots (if applicable)
[Attach screenshots of output]

## Checklist
- [ ] Code follows PEP 8 style guide
- [ ] Commit messages follow convention
- [ ] Documentation updated
- [ ] No breaking changes
```

### Code Review Process

Your PR will be reviewed for:
- Code quality and style
- Test coverage
- Documentation completeness
- Breaking changes
- Security implications

**Typical timeline**: 3-7 days for review

---

## Best Practices

### Error Handling

```python
# Good: Specific exceptions, helpful messages
try:
    vcn = network_client.get_vcn(vcn_id).data
except oci.exceptions.ServiceError as e:
    if e.status == 404:
        print(f"Error: VCN {vcn_id} not found")
    else:
        print(f"Error accessing VCN: {e.message}")
    sys.exit(1)

# Bad: Broad exception, no context
try:
    vcn = network_client.get_vcn(vcn_id).data
except:
    print("Error")
    sys.exit(1)
```

### Logging

```python
# Use print statements for user-facing messages
print("✓ Generated terraform files")
print("⚠ Warning: Large template may take several minutes")
print("✗ Error: Invalid CIDR format")

# Use comments for code documentation
# Calculate subnet CIDR blocks based on VCN CIDR
# This uses the netaddr library for IP arithmetic
```

### Performance

```python
# Good: Batch API calls
compartment_ids = [c.id for c in compartments]
resources = [client.list_resources(cid).data for cid in compartment_ids]

# Bad: Individual API calls in loop
for compartment in compartments:
    resources = client.list_resources(compartment.id).data
    # ... slow with many compartments
```

---

## Resources for Contributors

### Useful Links

- **OCI Python SDK Docs**: https://oracle-cloud-infrastructure-python-sdk.readthedocs.io/
- **Terraform OCI Provider**: https://registry.terraform.io/providers/oracle/oci/latest/docs
- **Jinja2 Documentation**: https://jinja.palletsprojects.com/
- **PEP 8 Style Guide**: https://pep8.org/

### Community

- **GitHub Discussions**: Share ideas and ask questions
- **Issues**: Report bugs and request features
- **Pull Requests**: Contribute code

### Getting Help

- **Architecture Questions**: See [ARCHITECTURE.md](ARCHITECTURE.md)
- **Setup Issues**: See [docs/SETUP.md](docs/SETUP.md)
- **General Questions**: Open a GitHub Discussion

---

## License

By contributing to CD3, you agree that your contributions will be licensed under the same license as the project (Universal Permissive License v1.0).

---

**Thank you for contributing to CD3!** 🎉

Your contributions help make infrastructure automation accessible to everyone.

---

**Document Version**: 1.0  
**Last Updated**: 2026-01-12  
**Questions?** Open an issue on GitHub
