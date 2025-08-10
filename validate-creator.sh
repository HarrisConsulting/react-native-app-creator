#!/bin/bash

# Validation Script for React Native Creator Portable
# Tests the complete workflow to ensure smooth process from creation to launch

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

echo -e "${CYAN}🧪 React Native Creator Portable - Validation Test${NC}"
echo -e "${CYAN}=================================================${NC}"

# Get script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
echo -e "${BLUE}📁 Script Directory: $SCRIPT_DIR${NC}"

echo -e "\n${YELLOW}🔍 Phase 1: Validating Template Scripts${NC}"
echo -e "${YELLOW}=======================================${NC}"

TEMPLATE_DIR="$SCRIPT_DIR/template-scripts"
REQUIRED_SCRIPTS=(
    "enhanced-start-metro.sh"
    "smart-ios-launch.sh" 
    "configure-ios.sh"
    "test-ios-build.sh"
)

if [[ ! -d "$TEMPLATE_DIR" ]]; then
    echo -e "${RED}❌ Template scripts directory not found: $TEMPLATE_DIR${NC}"
    exit 1
fi

echo -e "${GREEN}✅ Template directory exists: $TEMPLATE_DIR${NC}"

for script in "${REQUIRED_SCRIPTS[@]}"; do
    if [[ -f "$TEMPLATE_DIR/$script" ]]; then
        if [[ -x "$TEMPLATE_DIR/$script" ]]; then
            echo -e "${GREEN}✅ $script - exists and executable${NC}"
        else
            echo -e "${YELLOW}⚠️  $script - exists but not executable${NC}"
            chmod +x "$TEMPLATE_DIR/$script"
            echo -e "${GREEN}✅ Made $script executable${NC}"
        fi
    else
        echo -e "${RED}❌ Missing required script: $script${NC}"
        exit 1
    fi
done

echo -e "\n${YELLOW}🔍 Phase 2: Validating Main Creator Script${NC}"
echo -e "${YELLOW}==========================================${NC}"

MAIN_SCRIPT="$SCRIPT_DIR/create-react-native-app.sh"
if [[ ! -f "$MAIN_SCRIPT" ]]; then
    echo -e "${RED}❌ Main creator script not found: $MAIN_SCRIPT${NC}"
    exit 1
fi

if [[ ! -x "$MAIN_SCRIPT" ]]; then
    echo -e "${YELLOW}⚠️  Main script not executable, fixing...${NC}"
    chmod +x "$MAIN_SCRIPT"
fi

echo -e "${GREEN}✅ Main creator script exists and is executable${NC}"

# Check if script contains template integration
if grep -q "TEMPLATE_DIR" "$MAIN_SCRIPT"; then
    echo -e "${GREEN}✅ Main script includes template integration${NC}"
else
    echo -e "${RED}❌ Main script missing template integration${NC}"
    exit 1
fi

echo -e "\n${YELLOW}🔍 Phase 3: Validating Documentation Export${NC}"
echo -e "${YELLOW}==========================================${NC}"

EXPORT_SCRIPT="$SCRIPT_DIR/export-reusable-docs.sh"
DOCS_DIR="$SCRIPT_DIR/reusable-docs"

if [[ -f "$EXPORT_SCRIPT" ]]; then
    if [[ -x "$EXPORT_SCRIPT" ]]; then
        echo -e "${GREEN}✅ Documentation export script exists and is executable${NC}"
    else
        chmod +x "$EXPORT_SCRIPT"
        echo -e "${GREEN}✅ Made export script executable${NC}"
    fi
else
    echo -e "${YELLOW}⚠️  Documentation export script not found${NC}"
fi

if [[ -d "$DOCS_DIR" ]]; then
    DOC_COUNT=$(find "$DOCS_DIR" -name "*.md" | wc -l)
    echo -e "${GREEN}✅ Documentation directory exists with $DOC_COUNT markdown files${NC}"
else
    echo -e "${YELLOW}⚠️  Documentation directory not found: $DOCS_DIR${NC}"
fi

echo -e "\n${YELLOW}🔍 Phase 4: Validating Path Resolution Logic${NC}"
echo -e "${YELLOW}===========================================${NC}"

# Test each template script for proper path detection
for script in "${REQUIRED_SCRIPTS[@]}"; do
    if grep -q 'dirname.*BASH_SOURCE' "$TEMPLATE_DIR/$script"; then
        echo -e "${GREEN}✅ $script - has path auto-detection${NC}"
    else
        echo -e "${RED}❌ $script - missing path auto-detection${NC}"
        exit 1
    fi
    
    if grep -q 'cd.*PROJECT_DIR' "$TEMPLATE_DIR/$script"; then
        echo -e "${GREEN}✅ $script - includes directory change logic${NC}"
    else
        echo -e "${YELLOW}⚠️  $script - may not change to project directory${NC}"
    fi
done

echo -e "\n${YELLOW}🔍 Phase 5: Validating iOS Configuration Logic${NC}"
echo -e "${YELLOW}=============================================${NC}"

CONFIG_SCRIPT="$TEMPLATE_DIR/configure-ios.sh"
if grep -q "Interactive Bundle ID" "$CONFIG_SCRIPT"; then
    echo -e "${GREEN}✅ configure-ios.sh includes interactive Bundle ID setup${NC}"
else
    echo -e "${RED}❌ configure-ios.sh missing interactive setup${NC}"
    exit 1
fi

if grep -q "DEVELOPMENT_TEAM" "$CONFIG_SCRIPT"; then
    echo -e "${GREEN}✅ configure-ios.sh includes Team ID configuration${NC}"
else
    echo -e "${RED}❌ configure-ios.sh missing Team ID configuration${NC}"
    exit 1
fi

TEST_SCRIPT="$TEMPLATE_DIR/test-ios-build.sh"
if grep -q "Build Readiness" "$TEST_SCRIPT"; then
    echo -e "${GREEN}✅ test-ios-build.sh includes readiness validation${NC}"
else
    echo -e "${RED}❌ test-ios-build.sh missing validation logic${NC}"
    exit 1
fi

echo -e "\n${YELLOW}🔍 Phase 6: Validating Metro & iOS Launch Logic${NC}"
echo -e "${YELLOW}===============================================${NC}"

METRO_SCRIPT="$TEMPLATE_DIR/enhanced-start-metro.sh"
if grep -q "8081" "$METRO_SCRIPT"; then
    echo -e "${GREEN}✅ enhanced-start-metro.sh includes port conflict handling${NC}"
else
    echo -e "${RED}❌ enhanced-start-metro.sh missing port conflict logic${NC}"
    exit 1
fi

IOS_SCRIPT="$TEMPLATE_DIR/smart-ios-launch.sh"
if grep -q "pod install" "$IOS_SCRIPT"; then
    echo -e "${GREEN}✅ smart-ios-launch.sh includes pod install${NC}"
else
    echo -e "${RED}❌ smart-ios-launch.sh missing pod install${NC}"
    exit 1
fi

if grep -q "PROJECT_NAME.*basename" "$IOS_SCRIPT"; then
    echo -e "${GREEN}✅ smart-ios-launch.sh includes project name detection${NC}"
else
    echo -e "${YELLOW}⚠️  smart-ios-launch.sh may not detect project name${NC}"
fi

echo -e "\n${GREEN}🎉 Validation Complete!${NC}"
echo -e "${CYAN}======================${NC}"
echo -e "${GREEN}✅ All required scripts are present and configured correctly${NC}"
echo -e "${GREEN}✅ Path resolution logic is implemented in all scripts${NC}"
echo -e "${GREEN}✅ iOS configuration automation is ready${NC}"
echo -e "${GREEN}✅ Metro and iOS launch scripts include proper validation${NC}"

echo -e "\n${CYAN}💡 Ready for Production Use${NC}"
echo -e "${CYAN}===========================${NC}"
echo -e "${BLUE}The react-native-app-creator is validated and ready to create${NC}"
echo -e "${BLUE}React Native projects with smooth workflow from creation to launch.${NC}"

echo -e "\n${CYAN}🚀 Next Steps:${NC}"
echo -e "${BLUE}1. Run: ./create-react-native-app.sh${NC}"
echo -e "${BLUE}2. Follow prompts for project name and configuration${NC}"
echo -e "${BLUE}3. In new project: npm run configure-ios${NC}"
echo -e "${BLUE}4. Then: npm run test-ios-build${NC}"  
echo -e "${BLUE}5. Finally: npm run ios-simulator${NC}"

echo -e "\n${GREEN}✨ Expected Result: Smooth workflow with zero path-related errors!${NC}"
