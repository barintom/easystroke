#!/bin/bash

# Ubuntu Build Test Script for Easystroke
# This script tests the complete build process on Ubuntu

set -e  # Exit on any error

echo "=== Easystroke Ubuntu Build Test ==="
echo "Testing on: $(cat /etc/os-release | grep PRETTY_NAME | cut -d'"' -f2)"
echo "Date: $(date)"
echo

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

print_status() {
    if [ $1 -eq 0 ]; then
        echo -e "${GREEN}✅ $2${NC}"
    else
        echo -e "${RED}❌ $2${NC}"
        exit 1
    fi
}

print_info() {
    echo -e "${YELLOW}ℹ️ $1${NC}"
}

# Function to check if package is installed
check_package() {
    dpkg -l "$1" &> /dev/null
    return $?
}

# Check if we're in the right directory
if [ ! -f "Makefile" ] || [ ! -f "main.cc" ]; then
    echo "❌ Error: Not in easystroke source directory"
    echo "Please run this script from the easystroke source directory"
    exit 1
fi

print_info "Step 1: Checking system requirements"

# Check Ubuntu version
UBUNTU_VERSION=$(lsb_release -rs 2>/dev/null || echo "unknown")
print_info "Ubuntu version: $UBUNTU_VERSION"

# Check for apt package manager
if ! command -v apt &> /dev/null; then
    echo "❌ Error: apt package manager not found. This script is for Ubuntu/Debian systems."
    exit 1
fi
print_status 0 "Package manager (apt) available"

print_info "Step 2: Checking build dependencies"

REQUIRED_PACKAGES=(
    "build-essential"
    "libgtkmm-3.0-dev"
    "libdbus-glib-1-dev"
    "libboost-serialization-dev"
    "libx11-dev"
    "libxext-dev"
    "libxi-dev"
    "libxfixes-dev"
    "libxtst-dev"
    "gettext"
    "pkg-config"
    "xserver-xorg-dev"
)

MISSING_PACKAGES=()

for package in "${REQUIRED_PACKAGES[@]}"; do
    if check_package "$package"; then
        print_status 0 "Package $package is installed"
    else
        echo -e "${YELLOW}⚠️ Package $package is NOT installed${NC}"
        MISSING_PACKAGES+=("$package")
    fi
done

if [ ${#MISSING_PACKAGES[@]} -gt 0 ]; then
    print_info "Installing missing packages..."
    echo "Missing packages: ${MISSING_PACKAGES[*]}"
    
    if [ "$EUID" -eq 0 ]; then
        # Running as root
        apt update
        apt install -y "${MISSING_PACKAGES[@]}"
    else
        # Running as regular user
        echo "Please install missing packages by running:"
        echo "sudo apt update"
        echo "sudo apt install -y ${MISSING_PACKAGES[*]}"
        echo
        read -p "Do you want to install them now? (y/N): " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            sudo apt update
            sudo apt install -y "${MISSING_PACKAGES[@]}"
        else
            echo "❌ Cannot proceed without required packages"
            exit 1
        fi
    fi
fi

print_info "Step 3: Checking compiler and build tools"

# Check GCC version
if command -v gcc &> /dev/null; then
    GCC_VERSION=$(gcc --version | head -n1)
    print_status 0 "GCC available: $GCC_VERSION"
else
    print_status 1 "GCC not found"
fi

# Check G++ version
if command -v g++ &> /dev/null; then
    GPP_VERSION=$(g++ --version | head -n1)
    print_status 0 "G++ available: $GPP_VERSION"
else
    print_status 1 "G++ not found"
fi

# Check make
if command -v make &> /dev/null; then
    MAKE_VERSION=$(make --version | head -n1)
    print_status 0 "Make available: $MAKE_VERSION"
else
    print_status 1 "Make not found"
fi

# Check pkg-config
if command -v pkg-config &> /dev/null; then
    PKG_CONFIG_VERSION=$(pkg-config --version)
    print_status 0 "pkg-config available: $PKG_CONFIG_VERSION"
else
    print_status 1 "pkg-config not found"
fi

print_info "Step 4: Testing library dependencies"

# Test GTK
if pkg-config --exists gtkmm-3.0; then
    GTK_VERSION=$(pkg-config --modversion gtkmm-3.0)
    print_status 0 "GTKmm-3.0 available: $GTK_VERSION"
else
    print_status 1 "GTKmm-3.0 not found"
fi

# Test boost
if pkg-config --exists boost; then
    BOOST_VERSION=$(pkg-config --modversion boost)
    print_status 0 "Boost available: $BOOST_VERSION"
else
    print_info "Boost pkg-config not available (this is normal)"
fi

print_info "Step 5: Building easystroke"

# Clean previous build
print_info "Cleaning previous build..."
make clean &> /dev/null || true
print_status 0 "Build directory cleaned"

# Build the project
print_info "Compiling easystroke..."
make -j$(nproc) 2>&1 | tee build.log
MAKE_EXIT_CODE=${PIPESTATUS[0]}

if [ $MAKE_EXIT_CODE -eq 0 ]; then
    print_status 0 "Build completed successfully"
else
    print_status 1 "Build failed (exit code: $MAKE_EXIT_CODE)"
    echo "Build log (last 20 lines):"
    tail -20 build.log
fi

print_info "Step 6: Verifying the build"

# Check if binary exists
if [ -f "easystroke" ]; then
    print_status 0 "Binary 'easystroke' created"
    
    # Check binary size
    BINARY_SIZE=$(du -h easystroke | cut -f1)
    print_info "Binary size: $BINARY_SIZE"
    
    # Check if binary is executable
    if [ -x "easystroke" ]; then
        print_status 0 "Binary is executable"
    else
        print_status 1 "Binary is not executable"
    fi
else
    print_status 1 "Binary 'easystroke' not found"
fi

print_info "Step 7: Testing basic functionality"

# Test help command
if ./easystroke --help &> /dev/null; then
    print_status 0 "Help command works"
else
    print_status 1 "Help command failed"
fi

# Test version command
if ./easystroke --version &> /dev/null; then
    print_status 0 "Version command works"
else
    print_status 1 "Version command failed"
fi

print_info "Step 8: Build summary"

echo
echo "=== BUILD TEST SUMMARY ==="
echo -e "${GREEN}✅ Easystroke built successfully on Ubuntu!${NC}"
echo
echo "Binary location: $(pwd)/easystroke"
echo "Binary size: $(du -h easystroke | cut -f1)"
echo "Build time: $(date)"
echo
echo "To run easystroke:"
echo "  ./easystroke          # Start in background"
echo "  ./easystroke show     # Show configuration window"
echo "  ./easystroke --help   # Show help"
echo
echo "To install system-wide:"
echo "  sudo make install"
echo
echo -e "${GREEN}Build test completed successfully!${NC}"

# Clean up
rm -f build.log