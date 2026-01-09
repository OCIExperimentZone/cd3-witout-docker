#!/usr/bin/env python3
"""
CD3 Automation Toolkit Setup Script
Installs all dependencies and sets up CD3 toolkit locally without Docker
"""

import os
import sys
import platform
import subprocess
import urllib.request
import zipfile
import shutil
from pathlib import Path

class CD3Setup:
    def __init__(self):
        self.os_type = platform.system()
        self.home_dir = Path.home()
        self.script_dir = Path(__file__).parent.absolute()  # Directory where script is located
        self.cd3_dir = None  # Will be set based on user choice
        self.python_version = f"{sys.version_info.major}.{sys.version_info.minor}"
        
    def print_header(self, message):
        """Print formatted header"""
        print("\n" + "="*60)
        print(f"  {message}")
        print("="*60 + "\n")
    
    def run_command(self, command, shell=True, check=True):
        """Run shell command and return result"""
        try:
            print(f"Running: {command}")
            result = subprocess.run(
                command,
                shell=shell,
                check=check,
                stdout=subprocess.PIPE,
                stderr=subprocess.PIPE,
                text=True
            )
            if result.stdout:
                print(result.stdout)
            return True
        except subprocess.CalledProcessError as e:
            print(f"Error: {e.stderr}")
            return False
    
    def check_command_exists(self, command):
        """Check if a command exists"""
        try:
            subprocess.run(
                ["which", command] if self.os_type != "Windows" else ["where", command],
                check=True,
                stdout=subprocess.PIPE,
                stderr=subprocess.PIPE
            )
            return True
        except subprocess.CalledProcessError:
            return False
    
    def detect_os(self):
        """Detect operating system"""
        self.print_header("Detecting Operating System")
        print(f"OS Type: {self.os_type}")
        print(f"Platform: {platform.platform()}")
        print(f"Python Version: {self.python_version}")
        
        if self.os_type not in ["Linux", "Darwin", "Windows"]:
            print(f"Unsupported OS: {self.os_type}")
            sys.exit(1)
        
        return self.os_type
    
    def install_homebrew_macos(self):
        """Install Homebrew on macOS"""
        if self.check_command_exists("brew"):
            print("✓ Homebrew already installed")
            return True
        
        print("Installing Homebrew...")
        install_cmd = '/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"'
        return self.run_command(install_cmd)
    
    def install_git(self):
        """Install Git"""
        self.print_header("Installing Git")
        
        if self.check_command_exists("git"):
            print("✓ Git already installed")
            return True
        
        if self.os_type == "Darwin":  # macOS
            return self.run_command("brew install git")
        elif self.os_type == "Linux":
            if self.check_command_exists("apt-get"):
                return self.run_command("sudo apt-get update && sudo apt-get install -y git")
            elif self.check_command_exists("yum"):
                return self.run_command("sudo yum install -y git")
            elif self.check_command_exists("dnf"):
                return self.run_command("sudo dnf install -y git")
        elif self.os_type == "Windows":
            print("Please install Git from: https://git-scm.com/download/win")
            return False
        
        return False
    
    def install_python_packages(self):
        """Install required Python packages"""
        self.print_header("Installing Python Packages")
        
        packages = [
            "oci",
            "oci-cli",
            "requests",
            "jinja2",
            "pandas",
            "openpyxl",
            "xlrd",
            "configparser",
            "cryptography",
            "PyYAML",
            "python-dateutil",
            "pytz",
            "argparse",
        ]
        
        print("Installing required Python packages...")
        for package in packages:
            print(f"\nInstalling {package}...")
            self.run_command(f"{sys.executable} -m pip install --upgrade {package}")
        
        print("\n✓ All Python packages installed")
        return True
    
    def install_terraform(self):
        """Install Terraform"""
        self.print_header("Installing Terraform")
        
        if self.check_command_exists("terraform"):
            print("✓ Terraform already installed")
            self.run_command("terraform version")
            return True
        
        if self.os_type == "Darwin":  # macOS
            return self.run_command("brew tap hashicorp/tap && brew install hashicorp/tap/terraform")
        elif self.os_type == "Linux":
            commands = [
                "sudo apt-get update",
                "sudo apt-get install -y gnupg software-properties-common",
                "wget -O- https://apt.releases.hashicorp.com/gpg | gpg --dearmor | sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg",
                'echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list',
                "sudo apt-get update",
                "sudo apt-get install -y terraform"
            ]
            for cmd in commands:
                if not self.run_command(cmd, check=False):
                    print("Note: If this fails, please install Terraform manually from: https://www.terraform.io/downloads")
            return True
        elif self.os_type == "Windows":
            print("Please install Terraform from: https://www.terraform.io/downloads")
            return False
        
        return False
    
    def install_oci_cli(self):
        """Install OCI CLI"""
        self.print_header("Installing OCI CLI")
        
        if self.check_command_exists("oci"):
            print("✓ OCI CLI already installed")
            self.run_command("oci --version")
            return True
        
        print("OCI CLI will be installed via pip (already done in Python packages)")
        if self.check_command_exists("oci"):
            print("✓ OCI CLI installed successfully")
            return True
        
        print("Installing OCI CLI using installer script...")
        if self.os_type in ["Darwin", "Linux"]:
            install_cmd = "bash -c \"$(curl -L https://raw.githubusercontent.com/oracle/oci-cli/master/scripts/install/install.sh)\" -- --accept-all-defaults"
            return self.run_command(install_cmd, check=False)
        
        return True
    
    def choose_installation_directory(self):
        """Let user choose where to install CD3 toolkit"""
        self.print_header("Choose Installation Location")
        
        print("Where would you like to install CD3 toolkit?")
        print(f"1. Current directory (same as script): {self.script_dir}/cd3-automation-toolkit")
        print(f"2. Home directory: {self.home_dir}/cd3-automation-toolkit")
        print("3. Custom location (enter full path)")
        
        while True:
            choice = input("\nEnter your choice (1/2/3) [default: 1]: ").strip() or "1"
            
            if choice == "1":
                self.cd3_dir = self.script_dir / "cd3-automation-toolkit"
                break
            elif choice == "2":
                self.cd3_dir = self.home_dir / "cd3-automation-toolkit"
                break
            elif choice == "3":
                custom_path = input("Enter full path: ").strip()
                if custom_path:
                    self.cd3_dir = Path(custom_path) / "cd3-automation-toolkit"
                    break
                else:
                    print("Invalid path. Please try again.")
            else:
                print("Invalid choice. Please enter 1, 2, or 3.")
        
        print(f"\n✓ CD3 toolkit will be installed at: {self.cd3_dir}")
        return True
    
    def install_cd3_dependencies(self):
        """Install CD3 toolkit specific dependencies from requirements.txt"""
        self.print_header("Installing CD3 Toolkit Dependencies")
        
        if not self.cd3_dir.exists():
            print("CD3 toolkit not found. Please run clone_cd3_toolkit first.")
            return False
        
        # Install CD3 toolkit Python dependencies
        requirements_file = self.cd3_dir / "requirements.txt"
        if requirements_file.exists():
            print(f"Found requirements.txt at: {requirements_file}")
            print("Installing CD3 toolkit specific dependencies...")
            self.run_command(f"{sys.executable} -m pip install -r {requirements_file}")
            print("✓ CD3 dependencies installed")
        else:
            print("⚠ No requirements.txt found, installing common packages...")
            self.install_python_packages()
        
        return True
    
    def setup_cd3_environment(self):
        """Setup CD3 environment"""
        self.print_header("Setting up CD3 Environment")
        
        if not self.cd3_dir.exists():
            print("CD3 toolkit not found. Please run clone_cd3_toolkit first.")
            return False
        
        # Checkprint("Updating CD3 toolkit...")
                os.chdir(self.cd3_dir)
                return self.run_command("git pull")
            else:
                print("Skipping download...")
                return True
        
        print(f"Cloning CD3 toolkit to: {self.cd3_dir}")
        clone_cmd = f"git clone https://github.com/oracle-devrel/cd3-automation-toolkit.git {self.cd3_dir}"
        
        if not self.run_command(clone_cmd):
            print("Failed to clone repository. Please check your internet connection.")
            return False
        
        print("✓ CD3 toolkit downloaded successfully")
        return True
    
    def setup_cd3_environment(self):
        """Setup CD3 environment"""
        self.print_header("Setting up CD3 Environment")
        
        if not self.cd3_dir.exists():
            print("CD3 toolkit not found. Please run clone_cd3_toolkit first.")
            return False
        
        # Install CD3 toolkit Python dependencies
        requirements_file = self.cd3_dir / "requirements.txt"
        if requirements_file.exists():
            print("Installing CD3 toolkit dependencies...")
            self.run_command(f"{sys.executable} -m pip install -r {requirements_file}")
        
        # Create necessary directories
        directories = [
            self.cd3_dir / "user-scripts",
            self.cd3_dir / "setUpOCI",
            self.cd3_dir / "cd3_automation_toolkit",
        ]
        
        for directory in directories:
            if directory.exists():
                print(f"✓ Directory exists: {directory}")
            else:
                print(f"Note: Directory not found: {directory}")
        
        return True
    
    def configure_oci_cli(self):
        """Configure OCI CLI"""
        self.print_header("OCI CLI Configuration")
        
        oci_config = self.home_dir / ".oci" / "config"
        
        if oci_config.exists():
            print(f"✓ OCI config already exists at: {oci_config}")
            print("You can reconfigure it by running: oci setup config")
        else:
            print("OCI CLI needs to be configured.")
            response = input("Do you want to configure it now? (y/n): ").lower()
            if response == 'y':
                self.run_command("oci setup config")
            else:
                print("You can configure it later by running: oci setup config")
        
        return True
    
    def verify_installation(self):
        """Verify all installations"""
        self.print_header("Verifying Installation")
        
        checks = [
            ("Git", "git --version"),
            ("Python", f"{sys.executable} --version"),
            ("Pip", f"{sys.executable} -m pip --version"),
            ("Terraform", "terraform version"),
            ("OCI CLI", "oci --version"),
        ]
        
        results = []
        for name, command in checks:
            print(f"\nChecking {name}...")
            if self.run_command(command, check=False):
                results.append((name, "✓ Installed"))
            else:
                results.append((name, "✗ Not found"))
        
        print("\n" + "="*60)
        print("Installation Summary:")
        print("="*60)
        for name, status in results:
            print(f"{name:15} : {status}")
        
        print(f"\nCD3 Toolkit Location: {self.cd3_dir}")
        
        return True
    
    def print_next_steps(self):
        """Print next steps for user"""
        self.print_header("Next Steps")
        
        print("""
1. Configure OCI CLI (if not done):
   oci setup config

2. Navigate to CD3 toolkit directory:
   cd ~/cd3-automation-toolkit

3. Review the documentation:
   cat README.md

4. Set up your Excel template:
   - Download the CD3 Excel template
   - Fill in your infrastructure details

5. Run CD3 toolkit:
   cd ~/cd3-automation-toolkit
   python setUpOCI.py

6. For more information, visit:
   https://github.com/oracle-devrel/cd3-automation-toolkit

Note: Make sure you have:
- OCI account credentials
- Appropriate IAM permissions
- OCI tenancy OCID
- User OCID
- API key pair

Happy automating! 🚀
        """)
     first
            self.install_git()
            self.install_terraform()
            self.install_oci_cli()
            
            # Let user choose installation location
            self.choose_installation_directory()
            
            # Download CD3 toolkit FIRST
            self.clone_cd3_toolkit()
            
            # Install dependencies AFTER downloading CD3 (uses requirements.txt from CD3)
            self.install_cd3_dependencies()
            
            # Setup CD3 environment
            # Detect OS
            os_type = self.detect_os()
            
            # Install dependencies based on OS
            if os_type == "Darwin":  # macOS
                self.install_homebrew_macos()
            
            # Install core tools
            self.install_git()
            self.install_python_packages()
            self.install_terraform()
            self.install_oci_cli()
            
            # Download and setup CD3 toolkit
            self.clone_cd3_toolkit()
            self.setup_cd3_environment()
            
            # Configure OCI CLI
            self.configure_oci_cli()
            
            # Verify installation
            self.verify_installation()
            
            # Print next steps
            self.print_next_steps()
            
            self.print_header("Setup Complete!")
            print("CD3 toolkit is ready to use!")
            
        except KeyboardInterrupt:
            print("\n\nSetup interrupted by user.")
            sys.exit(1)
        except Exception as e:
            print(f"\n\nError during setup: {e}")
            import traceback
            traceback.print_exc()
            sys.exit(1)


def main():
    """Main entry point"""
    print("""
    ╔══════════════════════════════════════════════════════════╗
    ║     CD3 Automation Toolkit - Local Setup Script         ║
    ║     Oracle Cloud Infrastructure Automation               ║
    ╚══════════════════════════════════════════════════════════╝
    """)
    
    setup = CD3Setup()
    setup.run_full_setup()


if __name__ == "__main__":
    main()
