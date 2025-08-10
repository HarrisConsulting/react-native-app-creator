#!/bin/bash

# test-ios-build.sh - Template Version
# Test iOS build readiness after configuration
# Auto-detects project paths and validates configuration

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Auto-detect project directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$SCRIPT_DIR"
PROJECT_NAME=$(basename "$PROJECT_DIR")

echo -e "${CYAN}🧪 iOS Build Readiness Test${NC}"
echo -e "${BLUE}📁 Project Directory: $PROJECT_DIR${NC}"
echo -e "${BLUE}📱 Project Name: $PROJECT_NAME${NC}"
echo ""

# Change to project directory
cd "$PROJECT_DIR" || exit 1

# Check for required files
echo -e "${YELLOW}🔍 Checking Project Structure...${NC}"

if [ ! -f "package.json" ]; then
    echo -e "${RED}❌ package.json not found${NC}"
    exit 1
fi

if [ ! -d "ios" ]; then
    echo -e "${RED}❌ ios directory not found${NC}"
    exit 1
fi

PROJECT_FILE="ios/$PROJECT_NAME.xcodeproj/project.pbxproj"
if [ ! -f "$PROJECT_FILE" ]; then
    echo -e "${RED}❌ Xcode project file not found: $PROJECT_FILE${NC}"
    exit 1
fi

echo -e "${GREEN}✅ Project structure valid${NC}"

# Check iOS configuration
echo -e "${YELLOW}📱 Checking iOS Configuration...${NC}"

# Check Bundle Identifier
BUNDLE_ID=$(grep -o 'PRODUCT_BUNDLE_IDENTIFIER = [^;]*' "$PROJECT_FILE" | head -1 | sed 's/PRODUCT_BUNDLE_IDENTIFIER = //' | tr -d '"')
if [ -z "$BUNDLE_ID" ]; then
    echo -e "${RED}❌ Bundle Identifier not found${NC}"
    exit 1
fi

# Check if Bundle ID is the default complex one
if [[ "$BUNDLE_ID" == *"PRODUCT_NAME:rfc1034identifier"* ]]; then
    echo -e "${YELLOW}⚠️  Bundle Identifier: $BUNDLE_ID${NC}"
    echo -e "${YELLOW}💡 Consider running ./configure-ios.sh to set a simple Bundle ID${NC}"
else
    echo -e "${GREEN}✅ Bundle Identifier: $BUNDLE_ID${NC}"
fi

# Check Team ID
if grep -q "DEVELOPMENT_TEAM" "$PROJECT_FILE"; then
    TEAM_ID=$(grep -o 'DEVELOPMENT_TEAM = [^;]*' "$PROJECT_FILE" | head -1 | sed 's/DEVELOPMENT_TEAM = //' | sed 's/;$//' | tr -d '"')
    if [ -n "$TEAM_ID" ] && [ "$TEAM_ID" != '""' ]; then
        echo -e "${GREEN}✅ Development Team: $TEAM_ID${NC}"
    else
        echo -e "${YELLOW}⚠️  Development Team not set${NC}"
    fi
else
    echo -e "${YELLOW}⚠️  Development Team not configured${NC}"
fi

# Check for CocoaPods
echo -e "${YELLOW}🏗️ Checking CocoaPods...${NC}"
if [ ! -f "ios/Podfile" ]; then
    echo -e "${RED}❌ Podfile not found${NC}"
    exit 1
fi

if [ ! -d "ios/Pods" ]; then
    echo -e "${YELLOW}⚠️  Pods not installed. Try running pod install${NC}"
else
    echo -e "${GREEN}✅ CocoaPods installed${NC}"
fi

# Check for workspace
WORKSPACE_FILE="ios/$PROJECT_NAME.xcworkspace"
if [ -d "$WORKSPACE_FILE" ]; then
    echo -e "${GREEN}✅ Xcode workspace: $WORKSPACE_FILE${NC}"
else
    echo -e "${YELLOW}⚠️  Xcode workspace not found${NC}"
fi

echo ""
echo -e "${CYAN}📋 Build Readiness Summary${NC}"
echo -e "${CYAN}============================${NC}"

if [[ "$BUNDLE_ID" == *"PRODUCT_NAME:rfc1034identifier"* ]]; then
    echo -e "${YELLOW}📱 Bundle ID needs configuration${NC}"
    echo -e "${BLUE}   Run: ./configure-ios.sh${NC}"
else
    echo -e "${GREEN}✅ Bundle ID configured${NC}"
fi

if grep -q "DEVELOPMENT_TEAM" "$PROJECT_FILE" && [[ -n "$TEAM_ID" && "$TEAM_ID" != '""' ]]; then
    echo -e "${GREEN}✅ Team ID configured${NC}"
    echo -e "${GREEN}✅ Ready for device builds${NC}"
else
    echo -e "${YELLOW}⚠️  Team ID not set${NC}"
    echo -e "${BLUE}   Simulator builds: Available${NC}"
    echo -e "${BLUE}   Device builds: Requires Team ID${NC}"
fi

echo ""
echo -e "${CYAN}💡 Next Steps - Choose an option:${NC}"
if [[ "$BUNDLE_ID" == *"PRODUCT_NAME:rfc1034identifier"* ]]; then
    echo -e "${BLUE}   1. Configure iOS settings (Bundle ID and Team ID)${NC}"
    echo -e "${BLUE}   2. Launch iOS app${NC}"
    echo -e "${BLUE}   3. Re-run this test${NC}"
else
    echo -e "${BLUE}   1. Launch iOS app${NC}"
    echo -e "${BLUE}   2. Re-run this test${NC}"
    echo -e "${BLUE}   3. Exit${NC}"
fi

echo ""
read -p "Choose option (1-3): " choice

case $choice in
    1)
        if [[ "$BUNDLE_ID" == *"PRODUCT_NAME:rfc1034identifier"* ]]; then
            echo -e "${CYAN}🔧 Running iOS configuration...${NC}"
            ./configure-ios.sh
        else
            echo -e "${CYAN}🚀 Launching iOS app...${NC}"
            ./ios-smart-launch.sh
        fi
        ;;
    2)
        if [[ "$BUNDLE_ID" == *"PRODUCT_NAME:rfc1034identifier"* ]]; then
            echo -e "${CYAN}🚀 Launching iOS app...${NC}"
            ./ios-smart-launch.sh
        else
            echo -e "${CYAN}🧪 Re-running build test...${NC}"
            exec "$0"
        fi
        ;;
    3)
        if [[ "$BUNDLE_ID" == *"PRODUCT_NAME:rfc1034identifier"* ]]; then
            echo -e "${CYAN}🧪 Re-running build test...${NC}"
            exec "$0"
        else
            echo -e "${GREEN}✅ Exiting. Happy coding!${NC}"
            exit 0
        fi
        ;;
    *)
        echo -e "${RED}❌ Invalid choice. Please run the script again.${NC}"
        exit 1
        ;;
esac
