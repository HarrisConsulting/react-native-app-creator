#!/bin/bash

# Export Reusable Documentation Script
# Copies essential ReactNativeTest documentation to any React Native project

set -e

# Color codes for enhanced output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

echo -e "${BLUE}📚 ReactNativeTest Documentation Exporter${NC}"
echo -e "${BLUE}===========================================${NC}"
echo -e "${GREEN}✅ Exports proven patterns and critical Copilot instructions${NC}"

# Get the directory where this script is located
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
REUSABLE_DOCS_DIR="$SCRIPT_DIR/reusable-docs"

# Check if we have a target directory argument
if [[ $# -eq 1 ]]; then
    TARGET_DIR="$1"
else
    # If no argument, assume current directory
    TARGET_DIR="$(pwd)"
fi

echo -e "\n${PURPLE}📋 Configuration${NC}"
echo -e "${PURPLE}===============${NC}"
echo "📁 Script location: $SCRIPT_DIR"
echo "📁 Reusable docs source: $REUSABLE_DOCS_DIR"
echo "📁 Target project directory: $TARGET_DIR"

# Validate target directory
if [[ ! -d "$TARGET_DIR" ]]; then
    echo -e "${RED}❌ Error: Target directory does not exist: $TARGET_DIR${NC}"
    exit 1
fi

# Check if target looks like a React Native project
if [[ ! -f "$TARGET_DIR/package.json" ]] || [[ ! -f "$TARGET_DIR/index.js" ]]; then
    echo -e "${YELLOW}⚠️  Warning: Target directory doesn't appear to be a React Native project${NC}"
    echo -n "🤔 Continue anyway? (y/N): "
    read CONTINUE_ANYWAY
    if [[ "$CONTINUE_ANYWAY" != "y" ]] && [[ "$CONTINUE_ANYWAY" != "Y" ]]; then
        echo -e "${YELLOW}📋 Export cancelled${NC}"
        exit 0
    fi
fi

# Check if reusable docs directory exists
if [[ ! -d "$REUSABLE_DOCS_DIR" ]]; then
    echo -e "${RED}❌ Error: Reusable docs directory not found: $REUSABLE_DOCS_DIR${NC}"
    echo -e "${YELLOW}💡 Make sure you're running this script from the react-native-app-creator directory${NC}"
    exit 1
fi

# Check what documentation exists
echo -e "\n${CYAN}🔍 Available Documentation${NC}"
echo -e "${CYAN}==========================${NC}"

if [[ -f "$REUSABLE_DOCS_DIR/.github/copilot-instructions.md" ]]; then
    COPILOT_SIZE=$(wc -l < "$REUSABLE_DOCS_DIR/.github/copilot-instructions.md")
    echo -e "${GREEN}✅ GitHub Copilot Instructions: $COPILOT_SIZE lines${NC}"
else
    echo -e "${RED}❌ GitHub Copilot Instructions: Not found${NC}"
fi

if [[ -d "$REUSABLE_DOCS_DIR/docs" ]]; then
    DOC_COUNT=$(find "$REUSABLE_DOCS_DIR/docs" -type f -name "*.md" | wc -l)
    echo -e "${GREEN}✅ Documentation files: $DOC_COUNT markdown files${NC}"
    echo "   📁 Available sections:"
    ls -1 "$REUSABLE_DOCS_DIR/docs" | grep -E '^[^.]' | sed 's/^/   - /'
else
    echo -e "${RED}❌ Documentation directory: Not found${NC}"
fi

# Check what will be overwritten
echo -e "\n${YELLOW}⚠️  Overwrite Check${NC}"
echo -e "${YELLOW}==================${NC}"

OVERWRITE_WARNING=false

if [[ -f "$TARGET_DIR/.github/copilot-instructions.md" ]]; then
    echo -e "${YELLOW}⚠️  Will overwrite: .github/copilot-instructions.md${NC}"
    OVERWRITE_WARNING=true
fi

if [[ -d "$TARGET_DIR/docs" ]]; then
    echo -e "${YELLOW}⚠️  Will merge with existing: docs/ directory${NC}"
    OVERWRITE_WARNING=true
fi

if [[ "$OVERWRITE_WARNING" = true ]]; then
    echo -n "🤔 Continue with export? (y/N): "
    read CONFIRM_OVERWRITE
    if [[ "$CONFIRM_OVERWRITE" != "y" ]] && [[ "$CONFIRM_OVERWRITE" != "Y" ]]; then
        echo -e "${YELLOW}📋 Export cancelled${NC}"
        exit 0
    fi
fi

# Change to target directory
echo -e "\n${PURPLE}📂 Phase 1: Directory Setup${NC}"
echo -e "${PURPLE}============================${NC}"

echo "📁 Changing to target directory: $TARGET_DIR"
if ! cd "$TARGET_DIR"; then
    echo -e "${RED}❌ Error: Cannot change to target directory: $TARGET_DIR${NC}"
    exit 1
fi
echo -e "${GREEN}✅ Working directory: $(pwd)${NC}"

# Create .github directory if it doesn't exist
if [[ ! -d ".github" ]]; then
    echo "📁 Creating .github directory..."
    mkdir -p .github
fi

# Phase 2: Export Critical Copilot Instructions
echo -e "\n${PURPLE}🚨 Phase 2: Critical Copilot Instructions${NC}"
echo -e "${PURPLE}=========================================${NC}"

if [[ -f "$REUSABLE_DOCS_DIR/.github/copilot-instructions.md" ]]; then
    echo "📝 Copying GitHub Copilot instructions..."
    cp "$REUSABLE_DOCS_DIR/.github/copilot-instructions.md" .github/
    
    # Verify the copy
    if [[ -f ".github/copilot-instructions.md" ]]; then
        COPIED_SIZE=$(wc -l < ".github/copilot-instructions.md")
        echo -e "${GREEN}✅ Copilot instructions copied: $COPIED_SIZE lines${NC}"
        echo -e "${GREEN}✅ Critical for enterprise-grade code quality!${NC}"
    else
        echo -e "${RED}❌ Failed to copy copilot instructions${NC}"
    fi
else
    echo -e "${RED}❌ Copilot instructions not found in source${NC}"
fi

# Phase 3: Export Documentation
echo -e "\n${PURPLE}📚 Phase 3: Documentation Export${NC}"
echo -e "${PURPLE}===============================${NC}"

if [[ -d "$REUSABLE_DOCS_DIR/docs" ]]; then
    echo "📚 Copying comprehensive documentation..."
    
    # Copy the entire docs directory
    cp -r "$REUSABLE_DOCS_DIR/docs"/* ./docs/ 2>/dev/null || {
        # If docs directory doesn't exist, create it and copy
        mkdir -p docs
        cp -r "$REUSABLE_DOCS_DIR/docs"/* ./docs/
    }
    
    # Verify the copy
    if [[ -d "docs" ]]; then
        COPIED_DOCS=$(find docs -type f -name "*.md" | wc -l)
        echo -e "${GREEN}✅ Documentation copied: $COPIED_DOCS markdown files${NC}"
        echo "   📁 Sections available:"
        ls -1 docs | grep -E '^[^.]' | sed 's/^/   - /' || echo "   - (structure preserved)"
    else
        echo -e "${RED}❌ Failed to copy documentation${NC}"
    fi
else
    echo -e "${RED}❌ Documentation directory not found in source${NC}"
fi

# Phase 4: Add Documentation NPM Scripts
echo -e "\n${PURPLE}⚙️  Phase 4: NPM Scripts Integration${NC}"
echo -e "${PURPLE}===================================${NC}"

if [[ -f "package.json" ]]; then
    echo "📋 Adding documentation NPM scripts..."
    
    # Add docs-related scripts
    npm pkg set scripts.docs="code docs/" 2>/dev/null || echo "docs script already exists"
    npm pkg set scripts.docs-help="echo 'Documentation available in docs/ directory'" 2>/dev/null || echo "docs-help script already exists"
    npm pkg set scripts.docs-copilot="code .github/copilot-instructions.md" 2>/dev/null || echo "docs-copilot script already exists"
    
    echo -e "${GREEN}✅ Documentation scripts added to package.json${NC}"
    echo "   - npm run docs           # Open docs in VS Code"
    echo "   - npm run docs-help      # Show documentation info"
    echo "   - npm run docs-copilot   # Open Copilot instructions"
else
    echo -e "${YELLOW}⚠️  No package.json found - NPM scripts not added${NC}"
fi

# Phase 5: Git Integration Recommendations
echo -e "\n${PURPLE}🔄 Phase 5: Git Integration${NC}"
echo -e "${PURPLE}===========================${NC}"

if [[ -d ".git" ]]; then
    echo "📝 Git repository detected"
    
    # Check if copilot instructions are staged/committed
    if git ls-files --error-unmatch .github/copilot-instructions.md >/dev/null 2>&1; then
        echo -e "${GREEN}✅ Copilot instructions are already tracked by Git${NC}"
    else
        echo -e "${YELLOW}⚠️  Copilot instructions not yet committed${NC}"
        echo -e "${CYAN}🚨 CRITICAL NEXT STEP:${NC}"
        echo "   git add .github/copilot-instructions.md"
        echo "   git commit -m \"Add critical Copilot instructions for code quality\""
    fi
    
    # Check documentation status
    if git ls-files --error-unmatch docs/ >/dev/null 2>&1; then
        echo -e "${GREEN}✅ Documentation is tracked by Git${NC}"
    else
        echo -e "${YELLOW}📚 Documentation not yet committed${NC}"
        echo "   git add docs/"
        echo "   git commit -m \"Add comprehensive ReactNativeTest documentation\""
    fi
else
    echo -e "${YELLOW}⚠️  No Git repository detected${NC}"
    echo "💡 Consider initializing Git and committing the documentation"
fi

# Success Summary
echo -e "\n${GREEN}🎉 SUCCESS! Documentation Export Complete!${NC}"
echo -e "${GREEN}============================================${NC}"

echo -e "\n${CYAN}📋 Export Summary:${NC}"
if [[ -f ".github/copilot-instructions.md" ]]; then
    FINAL_COPILOT_SIZE=$(wc -l < ".github/copilot-instructions.md")
    echo -e "${GREEN}✅ Copilot Instructions: $FINAL_COPILOT_SIZE lines exported${NC}"
else
    echo -e "${RED}❌ Copilot Instructions: Export failed${NC}"
fi

if [[ -d "docs" ]]; then
    FINAL_DOCS=$(find docs -type f -name "*.md" | wc -l)
    echo -e "${GREEN}✅ Documentation: $FINAL_DOCS files exported${NC}"
else
    echo -e "${RED}❌ Documentation: Export failed${NC}"
fi

echo -e "\n${BLUE}🚀 What's Now Available:${NC}"
echo "📁 .github/copilot-instructions.md  # 🚨 CRITICAL - Enterprise coding standards"
echo "📁 docs/patterns/                   # Proven development patterns"
echo "📁 docs/troubleshooting/            # Issue resolution guides"
echo "📁 docs/setup-guides/               # Configuration instructions"
echo "📁 docs/templates/                  # Ready-to-copy templates"
echo "📁 docs/reference/                  # Technical references"

if [[ -f "package.json" ]]; then
    echo -e "\n${BLUE}📋 New NPM Commands:${NC}"
    echo "npm run docs           # Open documentation in VS Code"
    echo "npm run docs-help      # Show documentation information"
    echo "npm run docs-copilot   # Open critical Copilot instructions"
fi

echo -e "\n${RED}🚨 CRITICAL NEXT STEP:${NC}"
echo -e "${YELLOW}Commit the Copilot instructions immediately for code quality:${NC}"
echo "git add .github/copilot-instructions.md"
echo "git commit -m \"Add critical Copilot instructions\""

echo -e "\n${GREEN}✅ Your React Native project now has enterprise-grade documentation!${NC}"
echo -e "${CYAN}📖 Happy coding with proven ReactNativeTest patterns! 🚀${NC}"
