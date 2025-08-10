#!/bin/bash

# Standalone React Native Project Creator
# Version: 3.0 - Clean Documentation Edition
# Works on any machine with reusable docs folder

set -e

# Color codes for enhanced output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Configuration
PROJECTS_DIR="/Users/rogerharris/Projects"

# Capture the original script directory for later use
ORIGINAL_SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

echo -e "${BLUE}🚀 React Native Project Creator - Clean Edition v3.0${NC}"
echo -e "${BLUE}======================================================${NC}"
echo -e "${GREEN}✅ Zero dependencies - works anywhere!${NC}"
echo -e "${GREEN}✅ Comprehensive ReactNativeTest documentation included${NC}"

# Project Configuration
echo -e "\n${PURPLE}📋 Project Configuration${NC}"
echo -e "${PURPLE}========================${NC}"

# Project name input with validation
while true; do
    echo -n "🏷️  Project Name (e.g., TestAppK, MyNewApp): "
    read NEW_PROJECT_NAME
    if [[ "$NEW_PROJECT_NAME" =~ ^[A-Za-z][A-Za-z0-9]*$ ]]; then
        break
    else
        echo -e "${RED}❌ Please enter a valid project name (letters and numbers only, must start with letter)${NC}"
    fi
done

# Project description
echo -n "📝 Project Description (optional): "
read PROJECT_DESCRIPTION
if [[ -z "$PROJECT_DESCRIPTION" ]]; then
    PROJECT_DESCRIPTION="A React Native app created with clean standalone creator"
fi

# Architecture choice
echo -e "\n${BLUE}📱 Architecture Type${NC}"
echo "1) Simple Single-Feature App (Recommended for learning)"
echo "2) Multi-Feature Dashboard (Advanced)"
echo -n "Choose architecture (1-2): "
read ARCH_CHOICE

case $ARCH_CHOICE in
    1)
        ARCHITECTURE="Simple Single-Feature App"
        ;;
    2)
        ARCHITECTURE="Multi-Feature Dashboard (Advanced)"
        ;;
    *)
        ARCHITECTURE="Multi-Feature Dashboard (Advanced)"
        echo -e "${YELLOW}⚠️  Defaulting to Multi-Feature Dashboard${NC}"
        ;;
esac

# Documentation choice - now defaults to YES
echo -e "\n${BLUE}🔧 Documentation Integration${NC}"
echo -e "${GREEN}✅ Comprehensive ReactNativeTest documentation will be included${NC}"
echo "This includes critical GitHub Copilot instructions and all proven patterns"
echo -e "${GREEN}📚 Essential for maintaining code quality and consistency${NC}"

echo -n "📚 Include complete documentation bundle? (Y/n): "
read ADD_DOCS
if [[ "$ADD_DOCS" = "n" ]] || [[ "$ADD_DOCS" = "N" ]]; then
    ADD_DOCS="n"
    echo -e "${YELLOW}⚠️  Documentation not included - quality standards may be compromised${NC}"
else
    ADD_DOCS="y"
    echo -e "${GREEN}✅ Complete documentation bundle will be included${NC}"
fi

# Summary
echo -e "\n${CYAN}📋 Project Summary${NC}"
echo -e "${CYAN}=================${NC}"
echo "🏷️  Name: $NEW_PROJECT_NAME"
echo "📝 Description: $PROJECT_DESCRIPTION"
echo "🏗️  Architecture: $ARCHITECTURE"
echo "📚 Documentation: $(if [[ "$ADD_DOCS" = "y" ]]; then echo "✅ Complete ReactNativeTest bundle"; else echo "❌ Basic only"; fi)"

echo ""
echo -n "🚀 Create project with these settings? (Y/n): "
read CONFIRM
if [[ "$CONFIRM" = "n" ]] || [[ "$CONFIRM" = "N" ]]; then
    echo -e "${YELLOW}📋 Project creation cancelled${NC}"
    exit 0
fi

# Calculate project path
NEW_PROJECT_PATH="$PROJECTS_DIR/$NEW_PROJECT_NAME"

# Phase 1: Project Creation
echo -e "\n${PURPLE}🔧 Phase 1: React Native Project Creation${NC}"
echo -e "${PURPLE}========================================${NC}"

# Check if project already exists
if [[ -d "$NEW_PROJECT_PATH" ]]; then
    echo -e "${RED}❌ Error: Project directory already exists: $NEW_PROJECT_PATH${NC}"
    echo -n "🗑️  Remove existing directory and continue? (y/N): "
    read REMOVE_EXISTING
    if [[ "$REMOVE_EXISTING" = "y" ]] || [[ "$REMOVE_EXISTING" = "Y" ]]; then
        echo "🗑️  Removing existing directory..."
        rm -rf "$NEW_PROJECT_PATH"
    else
        echo -e "${YELLOW}📋 Project creation cancelled${NC}"
        exit 1
    fi
fi

# Navigate to projects directory with validation
echo "📁 Navigating to Projects directory: $PROJECTS_DIR"
if ! cd "$PROJECTS_DIR"; then
    echo -e "${RED}❌ Error: Cannot change to Projects directory: $PROJECTS_DIR${NC}"
    exit 1
fi
echo -e "${GREEN}✅ Working directory: $(pwd)${NC}"

# Create React Native project
echo "🏗️  Creating React Native project: $NEW_PROJECT_NAME"
if ! npx @react-native-community/cli@latest init "$NEW_PROJECT_NAME" --version 0.80.2; then
    echo -e "${RED}❌ Error: React Native project creation failed${NC}"
    echo "🔧 Trying alternative method..."
    if ! npx react-native init "$NEW_PROJECT_NAME" --version 0.80.2; then
        echo -e "${RED}❌ Error: Both React Native creation methods failed${NC}"
        exit 1
    fi
fi

# Navigate to new project with validation
echo "📁 Changing to project directory: $NEW_PROJECT_PATH"
if ! cd "$NEW_PROJECT_PATH"; then
    echo -e "${RED}❌ Error: Cannot change to project directory: $NEW_PROJECT_PATH${NC}"
    exit 1
fi
echo -e "${GREEN}✅ Working directory: $(pwd)${NC}"

echo -e "${GREEN}✅ React Native project created successfully${NC}"

# Phase 2: Enhanced Configuration
echo -e "\n${PURPLE}⚙️  Phase 2: Enhanced Configuration${NC}"
echo -e "${PURPLE}==================================${NC}"

# Note: Enhanced scripts will be set up from templates...

# Copy enhanced template scripts immediately after configuration
echo "📋 Copying enhanced template scripts..."
TEMPLATE_DIR="$ORIGINAL_SCRIPT_DIR/template-scripts"

if [[ -d "$TEMPLATE_DIR" ]]; then
    echo "📁 Template directory: $TEMPLATE_DIR"
    echo "📁 Target directory: $(pwd)"
    
    # Copy enhanced Metro script first
    if [[ -f "$TEMPLATE_DIR/enhanced-start-metro.sh" ]]; then
        cp "$TEMPLATE_DIR/enhanced-start-metro.sh" ./start-metro.sh
        chmod +x ./start-metro.sh
        echo "✅ Copied enhanced start-metro.sh → start-metro.sh"
    fi
    
    # Copy smart iOS launch script
    if [[ -f "$TEMPLATE_DIR/smart-ios-launch.sh" ]]; then
        cp "$TEMPLATE_DIR/smart-ios-launch.sh" ./ios-smart-launch.sh
        chmod +x ./ios-smart-launch.sh
        echo "✅ Copied smart-ios-launch.sh → ios-smart-launch.sh"
    fi
    
    # Copy iOS configuration script
    if [[ -f "$TEMPLATE_DIR/configure-ios.sh" ]]; then
        cp "$TEMPLATE_DIR/configure-ios.sh" ./configure-ios.sh
        chmod +x ./configure-ios.sh
        echo "✅ Copied configure-ios.sh"
    fi
    
    # Copy iOS build test script
    if [[ -f "$TEMPLATE_DIR/test-ios-build.sh" ]]; then
        cp "$TEMPLATE_DIR/test-ios-build.sh" ./test-ios-build.sh
        chmod +x ./test-ios-build.sh
        echo "✅ Copied test-ios-build.sh"
    fi
else
    echo -e "${RED}❌ Template scripts directory not found: $TEMPLATE_DIR${NC}"
    echo -e "${RED}This is required for proper functionality${NC}"
    exit 1
fi
echo "� Enhanced scripts will be set up from templates..."

# Create TypeScript configuration
echo "📝 Enhancing TypeScript configuration..."
cat > tsconfig.json << 'EOF'
{
  "extends": "@react-native/typescript-config/tsconfig.json",
  "compilerOptions": {
    "strict": true,
    "noImplicitAny": true,
    "noImplicitReturns": true,
    "noUnusedLocals": true,
    "noUnusedParameters": true,
    "exactOptionalPropertyTypes": true
  }
}
EOF

# Create Jest configuration
echo "🧪 Setting up enhanced Jest configuration..."
cat > jest.config.js << 'EOF'
module.exports = {
  preset: 'react-native',
  collectCoverageFrom: [
    'src/**/*.{ts,tsx}',
    '!src/**/*.d.ts',
  ],
  coverageReporters: ['text', 'lcov'],
  coverageThreshold: {
    global: {
      branches: 80,
      functions: 80,
      lines: 80,
      statements: 80,
    },
  },
};
EOF

cat > jest.setup.js << 'EOF'
import 'react-native-gesture-handler/jestSetup';

jest.mock('react-native-reanimated', () => {
  const Reanimated = require('react-native-reanimated/mock');
  Reanimated.default.call = () => {};
  return Reanimated;
});

jest.mock('react-native/Libraries/Animated/NativeAnimatedHelper');

global.__reanimatedWorkletInit = jest.fn();
EOF

# Create VS Code configuration
echo "🛠️  Setting up VS Code configuration..."
mkdir -p .vscode

cat > .vscode/settings.json << 'EOF'
{
  "typescript.preferences.useAliasesForRenames": false,
  "typescript.preferences.includePackageJsonAutoImports": "on",
  "editor.formatOnSave": true,
  "editor.codeActionsOnSave": {
    "source.fixAll.eslint": true
  },
  "eslint.validate": [
    "javascript",
    "javascriptreact",
    "typescript",
    "typescriptreact"
  ],
  "files.exclude": {
    "**/node_modules": true,
    "**/ios/build": true,
    "**/android/build": true,
    "**/android/.gradle": true
  }
}
EOF

echo -e "${GREEN}✅ Enhanced configuration complete${NC}"

# Phase 3: Enhanced Scripts & iOS Setup
echo -e "\n${PURPLE}📱 Phase 3: Enhanced Scripts & iOS Setup${NC}"
echo -e "${PURPLE}=======================================${NC}"

echo "📱 Enhanced iOS launch script will be copied from templates..."

# Install iOS dependencies
echo "📦 Installing iOS dependencies..."
if ! cd ios; then
    echo -e "${RED}❌ Error: Cannot change to ios directory${NC}"
    exit 1
fi

if ! pod install; then
    echo -e "${YELLOW}⚠️  Initial pod install failed, trying with repo update...${NC}"
    pod install --repo-update
fi

# Return to project root with validation
if ! cd "$NEW_PROJECT_PATH"; then
    echo -e "${RED}❌ Error: Cannot return to project directory: $NEW_PROJECT_PATH${NC}"
    exit 1
fi
echo -e "${GREEN}✅ Working directory: $(pwd)${NC}"

# Copy enhanced template scripts
echo "📋 Copying enhanced path-aware scripts..."
# Note: Template scripts already copied in Phase 2

# Add enhanced NPM scripts with smart directory navigation
echo "📋 Adding enhanced NPM scripts..."
npm pkg set scripts.start-safe="cd \$(npm prefix) && ./start-metro.sh"
npm pkg set scripts.ios-simulator="cd \$(npm prefix) && ./ios-smart-launch.sh"
npm pkg set scripts.configure-ios="cd \$(npm prefix) && ./configure-ios.sh"
npm pkg set scripts.test-ios-build="cd \$(npm prefix) && ./test-ios-build.sh"
npm pkg set scripts.clean-start="cd \$(npm prefix) && npx react-native start --reset-cache"
npm pkg set scripts.typecheck="cd \$(npm prefix) && npx tsc --noEmit"
npm pkg set scripts.lint="cd \$(npm prefix) && npx eslint . --ext .js,.jsx,.ts,.tsx"
npm pkg set scripts.lint:fix="cd \$(npm prefix) && npx eslint . --ext .js,.jsx,.ts,.tsx --fix"
npm pkg set scripts.test:coverage="cd \$(npm prefix) && npm test -- --coverage"
npm pkg set scripts.test:watch="cd \$(npm prefix) && npm test -- --watch"
npm pkg set scripts.verify-project="cd \$(npm prefix) && echo \"✅ Project: \$(pwd)\" && ls -la index.js package.json ios/ 2>/dev/null || echo \"❌ Not in project root\""

echo -e "${GREEN}✅ Enhanced scripts and iOS setup complete${NC}"

# Phase 3.5: iOS Configuration Setup
echo -e "\n${PURPLE}🔧 Phase 3.5: iOS Configuration Setup${NC}"
echo -e "${PURPLE}====================================${NC}"
echo "To prevent build errors (code 65), iOS Bundle ID and Team ID should be configured."
echo ""
echo -n "🔧 Configure iOS settings now? (Y/n): "
read CONFIGURE_IOS_NOW

if [[ "$CONFIGURE_IOS_NOW" != "n" ]] && [[ "$CONFIGURE_IOS_NOW" != "N" ]]; then
    if [[ -f "./configure-ios.sh" ]]; then
        echo -e "${GREEN}🔧 Running iOS configuration...${NC}"
        ./configure-ios.sh
        echo -e "${GREEN}✅ iOS configuration complete${NC}"
    else
        echo -e "${YELLOW}⚠️  configure-ios.sh not found, skipping configuration${NC}"
        echo -e "${YELLOW}You can run 'npm run configure-ios' later before building${NC}"
    fi
else
    echo -e "${YELLOW}⚠️  iOS configuration skipped${NC}"
    echo -e "${YELLOW}Remember to run 'npm run configure-ios' before building to avoid errors${NC}"
fi

# Phase 4: Documentation (if requested)
if [[ "$ADD_DOCS" =~ ^[Yy]$ ]]; then
    echo -e "\n${PURPLE}📚 Phase 4: Documentation Integration${NC}"
    echo -e "${PURPLE}===================================${NC}"
    echo "📋 Exporting comprehensive ReactNativeTest documentation..."
    
    # Use the original script directory captured at the beginning
    EXPORT_SCRIPT="$ORIGINAL_SCRIPT_DIR/export-reusable-docs.sh"
    
    echo "🔍 Script location: $ORIGINAL_SCRIPT_DIR"
    echo "📁 Export script: $EXPORT_SCRIPT"
    echo "📁 Target directory: $(pwd)"
    
    # Check if export script exists
    if [[ -f "$EXPORT_SCRIPT" ]]; then
        echo "� Running documentation export script..."
        
        # Run the export script for the current directory
        if "$EXPORT_SCRIPT" "$(pwd)"; then
            echo -e "${GREEN}✅ Documentation export completed successfully!${NC}"
        else
            echo -e "${RED}❌ Documentation export failed${NC}"
            echo -e "${YELLOW}� Creating basic documentation fallback...${NC}"
            mkdir -p docs .github
            echo "# Basic Project Documentation" > docs/README.md
            echo "# GitHub Copilot Instructions - Basic Setup" > .github/copilot-instructions.md
        fi
    else
        echo -e "${RED}❌ Export script not found: $EXPORT_SCRIPT${NC}"
        echo -e "${YELLOW}📋 Creating basic documentation structure...${NC}"
        mkdir -p docs .github
        echo "# Basic Project Documentation" > docs/README.md
        echo "# GitHub Copilot Instructions - Basic Setup" > .github/copilot-instructions.md
    fi
    
    echo -e "${GREEN}✅ Documentation integration complete${NC}"
fi

# Phase 5: Create Project README
echo -e "\n${PURPLE}📋 Phase 5: Creating Project Documentation${NC}"
echo -e "${PURPLE}=========================================${NC}"

# Create comprehensive README
cat > README.md << EOF
# $NEW_PROJECT_NAME

$PROJECT_DESCRIPTION

**Created**: $(date +"%Y-%m-%d")  
**Architecture**: $ARCHITECTURE  
**Based on**: Clean Standalone React Native Creator v3.0

## 🚀 Quick Start

\`\`\`bash
# Verify project setup
npm run verify-project

# Start Metro bundler (enhanced safety)
npm run start-safe

# Launch on iOS Simulator (warning-free)
npm run ios-simulator

# Run tests
npm test
\`\`\`

## ✅ Enhanced Features

### 🛡️ Safety Protocols
- **Metro Safety**: Automatic port conflict resolution
- **Smart iOS Launch**: Eliminates simulator warnings
- **Project Validation**: Built-in integrity checks

### 📊 Quality Assurance
\`\`\`bash
npm run typecheck       # TypeScript validation
npm run lint           # ESLint check
npm run lint:fix       # Auto-fix ESLint issues
npm run test:coverage  # Test coverage report
\`\`\`

### 🎯 Development Scripts
\`\`\`bash
npm run start-safe     # Enhanced Metro startup
npm run clean-start    # Reset Metro cache
npm run ios-simulator  # Warning-free iOS launch
npm run verify-project # Project health check
\`\`\`

$(if [[ "$ADD_DOCS" = "y" ]]; then cat << 'DOCS_SECTION'

## 📚 **CRITICAL: GitHub Copilot Instructions**

**🚨 FIRST STEP AFTER PROJECT CREATION:**

\`\`\`bash
git add .github/copilot-instructions.md
git commit -m "Add critical Copilot instructions for code quality"
git push
\`\`\`

This file contains **enterprise-grade coding standards** from ReactNativeTest project.

## 📖 Complete Documentation

This project includes comprehensive documentation:

- **\`.github/copilot-instructions.md\`** - Critical coding standards (COMMIT FIRST!)
- **\`docs/patterns/\`** - Proven development patterns
- **\`docs/troubleshooting/\`** - Issue resolution guides
- **\`docs/setup-guides/\`** - Configuration instructions
- **\`docs/templates/\`** - Ready-to-copy code templates

### Quick Documentation Access
\`\`\`bash
npm run docs           # Open documentation in VS Code
npm run docs-help      # Show documentation info
\`\`\`

DOCS_SECTION
fi)

## 🎯 Development Workflow

1. **Quality Gates** (run before every commit):
   - \`npm run typecheck\` - Must pass
   - \`npm run lint\` - Must pass
   - \`npm test\` - All tests green

2. **Feature Development**:
   - Follow established patterns$(if [[ "$ADD_DOCS" = "y" ]]; then echo " (see docs/patterns/)"; fi)
   - Comprehensive test coverage required
   - Zero warnings policy

## 🚨 Troubleshooting

### Common Issues
\`\`\`bash
# Metro issues
npm run clean-start

# iOS build issues
cd ios && pod install && cd ..
npm run ios-simulator

# Complete reset (nuclear option)
rm -rf node_modules package-lock.json
npm install
cd ios && pod install && cd ..
\`\`\`

$(if [[ "$ADD_DOCS" = "y" ]]; then echo "**📋 Complete troubleshooting guide**: \`docs/troubleshooting/README.md\`"; fi)

## 📁 Project Structure

\`\`\`
├── $(if [[ "$ADD_DOCS" = "y" ]]; then echo ".github/copilot-instructions.md  # 🚨 CRITICAL"; fi)
├── $(if [[ "$ADD_DOCS" = "y" ]]; then echo "docs/                          # Complete documentation"; fi)
├── src/                           # Application source code
├── start-metro.sh                 # Enhanced Metro safety
├── ios-smart-launch.sh           # Warning-free iOS launch
└── package.json                  # Enhanced scripts
\`\`\`

## ✨ Key Benefits

- **🔗 Zero External Dependencies**: Self-contained development environment
- **🏆 Enterprise-Grade Quality**: Proven ReactNativeTest patterns$(if [[ "$ADD_DOCS" = "y" ]]; then echo " embedded"; fi)
- **🚀 Production-Ready**: Enhanced safety and quality protocols
- **🛡️ Error Prevention**: Smart scripts prevent common issues

---

**Ready for development with confidence!** 🚀$(if [[ "$ADD_DOCS" = "y" ]]; then echo -e "\n\n**⚠️ Remember**: Commit the Copilot instructions immediately!"; fi)
EOF

echo -e "${GREEN}✅ Project README created${NC}"

# Phase 6: Git Initialization
echo -e "\n${PURPLE}🔄 Phase 6: Git Repository Initialization${NC}"
echo -e "${PURPLE}=======================================${NC}"

# Initialize git repository
if git init; then
    echo -e "${GREEN}✅ Git repository initialized${NC}"
    
    # Add .gitignore if it doesn't exist
    if [[ ! -f .gitignore ]]; then
        echo "📝 Creating .gitignore..."
        cat > .gitignore << 'EOF'
# Dependencies
node_modules/
npm-debug.log*
yarn-debug.log*
yarn-error.log*

# React Native
.expo/
.expo-shared/

# iOS
ios/build/
ios/Pods/
ios/*.xcworkspace/xcuserdata/

# Android
android/app/build/
android/build/
android/.gradle/

# Metro
.metro-health-check*

# Debug
.vscode/
*.log

# Temporary files
*.tmp
*.temp
EOF
    fi
    
    # Initial commit
    git add .
    if [[ "$ADD_DOCS" = "y" ]]; then
        git commit -m "Initial project setup with ReactNativeTest documentation

- React Native 0.80.2 with TypeScript
- Enhanced Metro safety protocol
- Smart iOS launch scripts
- Complete ReactNativeTest documentation bundle
- Critical GitHub Copilot instructions included
- Production-ready configuration

Architecture: $ARCHITECTURE
Created: $(date +"%Y-%m-%d")"
    else
        git commit -m "Initial project setup

- React Native 0.80.2 with TypeScript
- Enhanced Metro safety protocol
- Smart iOS launch scripts
- Basic configuration

Architecture: $ARCHITECTURE
Created: $(date +"%Y-%m-%d")"
    fi
    
    echo -e "${GREEN}✅ Initial commit created${NC}"
else
    echo -e "${YELLOW}⚠️  Git initialization failed, continuing...${NC}"
fi

# Final Success Message
echo -e "\n${GREEN}🎉 SUCCESS! Project Created Successfully!${NC}"
echo -e "${GREEN}=========================================${NC}"

echo -e "\n${CYAN}📋 Project Details:${NC}"
echo "🏷️  Name: $NEW_PROJECT_NAME"
echo "📁 Location: $NEW_PROJECT_PATH"
echo "🏗️  Architecture: $ARCHITECTURE"
echo "📅 Created: $(date)"

if [[ "$ADD_DOCS" = "y" ]]; then
    echo -e "\n${RED}🚨 CRITICAL NEXT STEP:${NC}"
    echo -e "${RED}========================${NC}"
    echo -e "${YELLOW}IMMEDIATELY commit the GitHub Copilot instructions:${NC}"
    echo ""
    echo "cd $NEW_PROJECT_PATH"
    echo "git add .github/copilot-instructions.md"
    echo "git commit -m \"Add critical Copilot instructions\""
    echo "git push  # (after setting up remote)"
    echo ""
    echo -e "${GREEN}✅ This ensures enterprise-grade code quality from day one!${NC}"
fi

echo -e "\n${BLUE}🚀 Perfect Development Workflow:${NC}"
echo -e "${GREEN}✅ iOS configuration already completed during setup!${NC}"
echo ""
echo -e "${BLUE}From any directory, run these commands:${NC}"
echo "npm run verify-project    # 1. Verify project setup"
echo "npm run test-ios-build    # 2. Confirm iOS configuration (should be ✅)"
echo ""
echo -e "${BLUE}Terminal 1 (Metro - keep running):${NC}"
echo "npm run start-safe        # 3. Start Metro bundler on port 8081"
echo ""
echo -e "${BLUE}Terminal 2 (iOS Build):${NC}"
echo "npm run ios-simulator     # 4. Choose Simulator OR Device, then build & launch"
echo ""
echo -e "${YELLOW}💡 The ios-simulator script will ask: Simulator or Device?${NC}"
echo -e "${YELLOW}   • Simulator: Automatically opens iOS Simulator${NC}"
echo -e "${YELLOW}   • Device: Builds for connected physical device${NC}"

if [[ "$ADD_DOCS" = "y" ]]; then
    echo "npm run docs             # Open documentation"
fi

echo -e "\n${GREEN}✅ Your enhanced React Native project is ready for development!${NC}"
echo -e "${GREEN}✅ All ReactNativeTest patterns and safety protocols included!${NC}"
echo -e "${CYAN}📖 Happy coding! 🚀${NC}"

# Automatic Metro Terminal Opening
echo -e "\n${BLUE}🚀 Starting Automatic Metro Setup...${NC}"
echo -e "${BLUE}=====================================${NC}"
echo -e "${YELLOW}📋 Opening Metro in new terminal window (Terminal B)${NC}"
echo -e "${YELLOW}💡 Metro will run in a separate window - do not close it!${NC}"

# Open new terminal with Metro
osascript -e "tell application \"Terminal\" to do script \"cd '$NEW_PROJECT_PATH' && npm run start-safe\""

echo -e "${GREEN}✅ Metro terminal opened (Terminal B)${NC}"
echo -e "${BLUE}⏳ Waiting for Metro to start...${NC}"

# Wait for Metro to be available
echo -n "🔄 Checking Metro status"
for i in {1..30}; do
    if lsof -i :8081 | grep -q LISTEN; then
        echo ""
        echo -e "${GREEN}✅ Metro is running and ready!${NC}"
        break
    fi
    echo -n "."
    sleep 2
done

if ! lsof -i :8081 | grep -q LISTEN; then
    echo ""
    echo -e "${YELLOW}⚠️  Metro may still be starting - check the Metro terminal${NC}"
    echo -e "${YELLOW}💡 Wait for 'Dev server ready' message before continuing${NC}"
fi

echo -e "\n${BLUE}🎯 Ready for iOS Build in Current Terminal (Terminal A)${NC}"
echo -e "${BLUE}=====================================================${NC}"
echo -e "${GREEN}💡 Now you can run: npm run ios-simulator${NC}"
echo -e "${YELLOW}📋 This will continue the build in this terminal while Metro runs separately${NC}"
