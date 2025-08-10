#!/bin/bash

# Enhanced Prerequisites Checker for React Native Development
# Validates system requirements before project creation

set -e

# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

echo -e "${BLUE}🔍 React Native Development Prerequisites Checker${NC}"
echo -e "${BLUE}===============================================${NC}"
echo ""

ERRORS=0
WARNINGS=0

# Check Node.js
check_nodejs() {
    echo -e "${CYAN}📦 Checking Node.js...${NC}"
    
    if ! command -v node &> /dev/null; then
        echo -e "${RED}❌ Node.js not found${NC}"
        echo -e "${YELLOW}👉 Install from: https://nodejs.org (LTS version recommended)${NC}"
        echo -e "${YELLOW}💡 Minimum version: 18.x | Recommended: 20.x or later${NC}"
        ((ERRORS++))
        return 1
    fi
    
    NODE_VERSION=$(node --version | sed 's/v//')
    NODE_MAJOR=$(echo $NODE_VERSION | cut -d. -f1)
    
    if [[ $NODE_MAJOR -lt 18 ]]; then
        echo -e "${RED}❌ Node.js $NODE_VERSION (minimum required: 18.x)${NC}"
        echo -e "${YELLOW}👉 Update from: https://nodejs.org${NC}"
        ((ERRORS++))
        return 1
    elif [[ $NODE_MAJOR -lt 20 ]]; then
        echo -e "${YELLOW}⚠️  Node.js $NODE_VERSION (recommended: 20.x+)${NC}"
        echo -e "${GREEN}✅ Compatible but consider upgrading${NC}"
        ((WARNINGS++))
    else
        echo -e "${GREEN}✅ Node.js $NODE_VERSION (excellent!)${NC}"
    fi
    
    return 0
}

# Check npm
check_npm() {
    echo -e "${CYAN}📦 Checking npm...${NC}"
    
    if ! command -v npm &> /dev/null; then
        echo -e "${RED}❌ npm not found (should come with Node.js)${NC}"
        ((ERRORS++))
        return 1
    fi
    
    NPM_VERSION=$(npm --version)
    echo -e "${GREEN}✅ npm $NPM_VERSION${NC}"
    return 0
}

# Check Xcode
check_xcode() {
    echo -e "${CYAN}🔨 Checking Xcode...${NC}"
    
    if ! command -v xcodebuild &> /dev/null; then
        echo -e "${RED}❌ Xcode Command Line Tools not found${NC}"
        echo -e "${YELLOW}👉 Install from Mac App Store: search 'Xcode'${NC}"
        echo -e "${YELLOW}💡 After installation, run: xcode-select --install${NC}"
        ((ERRORS++))
        return 1
    fi
    
    XCODE_VERSION=$(xcodebuild -version 2>/dev/null | head -1 | awk '{print $2}')
    if [[ -n "$XCODE_VERSION" ]]; then
        echo -e "${GREEN}✅ Xcode $XCODE_VERSION${NC}"
    else
        echo -e "${YELLOW}⚠️  Xcode installed but version detection failed${NC}"
        ((WARNINGS++))
    fi
    
    # Check if license is accepted
    if xcodebuild -checkFirstLaunchStatus 2>/dev/null; then
        echo -e "${GREEN}✅ Xcode license accepted${NC}"
    else
        echo -e "${YELLOW}⚠️  Xcode license may need to be accepted${NC}"
        echo -e "${YELLOW}👉 Open Xcode and accept the license agreement${NC}"
        ((WARNINGS++))
    fi
    
    return 0
}

# Check CocoaPods
check_cocoapods() {
    echo -e "${CYAN}🍎 Checking CocoaPods...${NC}"
    
    if ! command -v pod &> /dev/null; then
        echo -e "${YELLOW}⚠️  CocoaPods not found (will be auto-installed)${NC}"
        echo -e "${YELLOW}💡 If issues occur, install manually: sudo gem install cocoapods${NC}"
        ((WARNINGS++))
        return 1
    fi
    
    POD_VERSION=$(pod --version)
    echo -e "${GREEN}✅ CocoaPods $POD_VERSION${NC}"
    return 0
}

# Check available disk space
check_disk_space() {
    echo -e "${CYAN}💾 Checking available disk space...${NC}"
    
    # Get available space in GB (macOS)
    AVAILABLE_GB=$(df -h / | awk 'NR==2{print $4}' | sed 's/Gi*//')
    
    if [[ "$AVAILABLE_GB" =~ ^[0-9]+$ ]]; then
        if [[ $AVAILABLE_GB -lt 5 ]]; then
            echo -e "${RED}❌ Low disk space: ${AVAILABLE_GB}GB available (minimum: 5GB)${NC}"
            echo -e "${YELLOW}👉 Free up disk space before proceeding${NC}"
            ((ERRORS++))
        elif [[ $AVAILABLE_GB -lt 10 ]]; then
            echo -e "${YELLOW}⚠️  Limited disk space: ${AVAILABLE_GB}GB available (recommended: 10GB+)${NC}"
            ((WARNINGS++))
        else
            echo -e "${GREEN}✅ Sufficient disk space: ${AVAILABLE_GB}GB available${NC}"
        fi
    else
        echo -e "${YELLOW}⚠️  Could not determine disk space${NC}"
        ((WARNINGS++))
    fi
}

# Check macOS version
check_macos_version() {
    echo -e "${CYAN}🖥️  Checking macOS version...${NC}"
    
    MACOS_VERSION=$(sw_vers -productVersion)
    MACOS_MAJOR=$(echo $MACOS_VERSION | cut -d. -f1)
    MACOS_MINOR=$(echo $MACOS_VERSION | cut -d. -f2)
    
    # macOS 12+ recommended for latest React Native
    if [[ $MACOS_MAJOR -gt 12 ]] || [[ $MACOS_MAJOR -eq 12 ]]; then
        echo -e "${GREEN}✅ macOS $MACOS_VERSION (compatible)${NC}"
    elif [[ $MACOS_MAJOR -eq 11 ]]; then
        echo -e "${YELLOW}⚠️  macOS $MACOS_VERSION (older version, may have limitations)${NC}"
        ((WARNINGS++))
    else
        echo -e "${RED}❌ macOS $MACOS_VERSION (may not be compatible)${NC}"
        echo -e "${YELLOW}👉 Consider upgrading to macOS 12+ for best experience${NC}"
        ((ERRORS++))
    fi
}

# Run all checks
echo "Running system prerequisites check..."
echo ""

check_nodejs
check_npm
check_xcode
check_cocoapods
check_disk_space
check_macos_version

echo ""
echo -e "${BLUE}📊 Prerequisites Check Summary${NC}"
echo -e "${BLUE}==============================${NC}"

if [[ $ERRORS -eq 0 && $WARNINGS -eq 0 ]]; then
    echo -e "${GREEN}🎉 Perfect! Your system is fully ready for React Native development${NC}"
    echo -e "${GREEN}✅ All requirements met - you can proceed with project creation${NC}"
    exit 0
elif [[ $ERRORS -eq 0 ]]; then
    echo -e "${YELLOW}⚡ Good! Your system is ready with minor recommendations${NC}"
    echo -e "${YELLOW}⚠️  $WARNINGS warning(s) - consider addressing for optimal experience${NC}"
    echo ""
    echo -n "Continue anyway? (Y/n): "
    read CONTINUE
    if [[ "$CONTINUE" == "n" || "$CONTINUE" == "N" ]]; then
        echo -e "${YELLOW}Setup paused - address warnings and run again${NC}"
        exit 1
    fi
    exit 0
else
    echo -e "${RED}❌ System not ready - $ERRORS critical issue(s) found${NC}"
    if [[ $WARNINGS -gt 0 ]]; then
        echo -e "${YELLOW}⚠️  Also found $WARNINGS warning(s)${NC}"
    fi
    echo ""
    echo -e "${BLUE}🔧 Quick Setup Guide:${NC}"
    echo -e "${BLUE}1. Install Node.js: https://nodejs.org${NC}"
    echo -e "${BLUE}2. Install Xcode from Mac App Store${NC}"
    echo -e "${BLUE}3. Run this checker again: ./check-prerequisites.sh${NC}"
    echo ""
    exit 1
fi
