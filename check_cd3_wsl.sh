#!/bin/bash

# Quick CD3 WSL Verification Script

echo "=== CD3 WSL Quick Check ==="
echo ""

# Check 1: Are you in the right directory?
echo "Current directory:"
pwd
echo ""

# Check 2: List contents to see what's here
echo "Directory contents:"
ls -la
echo ""

# Check 3: Check for critical directories
echo "Checking for critical CD3 components:"
for dir in ocicloud common user-scripts; do
    if [ -d "$dir" ]; then
        echo "✓ $dir exists"
    else
        echo "✗ $dir MISSING!"
    fi
done
echo ""

# Check 4: Check for main scripts
echo "Checking for main scripts:"
for file in setUpOCI.py connectCloud.py connectOCI.properties; do
    if [ -f "$file" ]; then
        echo "✓ $file exists"
    else
        echo "✗ $file MISSING!"
    fi
done
echo ""

# Check 5: If ocicloud exists, check its structure
if [ -d "ocicloud" ]; then
    echo "ocicloud directory structure:"
    ls -la ocicloud/
    echo ""
    if [ -d "ocicloud/python" ]; then
        echo "ocicloud/python contents:"
        ls -la ocicloud/python/ | head -10
    fi
else
    echo "❌ ocicloud directory does NOT exist!"
    echo ""
    echo "This means your CD3 installation is incomplete."
    echo "You need to reinstall or extract CD3 properly."
fi
