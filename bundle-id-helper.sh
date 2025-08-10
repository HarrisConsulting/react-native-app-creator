#!/bin/bash

# Interactive Bundle ID Builder for React Native Apps
# Helps novice users create proper Bundle IDs with validation

set -e

# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

PROJECT_NAME="${1:-MyApp}"

echo -e "${BLUE}📱 Bundle ID Builder - Interactive Guide${NC}"
echo -e "${BLUE}======================================${NC}"
echo ""
echo -e "${CYAN}What is a Bundle ID?${NC}"
echo "A Bundle ID uniquely identifies your app in the App Store and iOS ecosystem."
echo "It uses 'reverse domain notation' - like a web address backwards."
echo ""
echo -e "${GREEN}✅ Good examples:${NC}"
echo "   • com.apple.calculator"
echo "   • com.spotify.client" 
echo "   • com.yourname.todoapp"
echo ""
echo -e "${RED}❌ Invalid examples:${NC}"
echo "   • MyApp (too simple)"
echo "   • com..myapp (double dots)"
echo "   • com.my-app.test (hyphens not allowed)"
echo ""

validate_bundle_id() {
    local bundle_id="$1"
    
    # Check if empty
    if [[ -z "$bundle_id" ]]; then
        echo -e "${RED}❌ Bundle ID cannot be empty${NC}"
        return 1
    fi
    
    # Check basic format (must have at least 2 dots)
    if [[ $(echo "$bundle_id" | tr -cd '.' | wc -c) -lt 2 ]]; then
        echo -e "${RED}❌ Bundle ID must have at least 3 parts (e.g., com.company.app)${NC}"
        echo -e "${YELLOW}💡 Format: com.yourname.${PROJECT_NAME,,}${NC}"
        return 1
    fi
    
    # Check for valid characters (letters, numbers, dots, hyphens in limited cases)
    if [[ ! "$bundle_id" =~ ^[a-zA-Z0-9.-]+$ ]]; then
        echo -e "${RED}❌ Bundle ID contains invalid characters${NC}"
        echo -e "${YELLOW}💡 Allowed: letters, numbers, dots, and hyphens${NC}"
        return 1
    fi
    
    # Check for double dots
    if [[ "$bundle_id" == *".."* ]]; then
        echo -e "${RED}❌ Bundle ID cannot contain double dots (..)${NC}"
        return 1
    fi
    
    # Check for starting/ending with dot
    if [[ "$bundle_id" == .* ]] || [[ "$bundle_id" == *. ]]; then
        echo -e "${RED}❌ Bundle ID cannot start or end with a dot${NC}"
        return 1
    fi
    
    # Check for reserved words
    local reserved_words=("apple" "com.com" "test.test")
    for word in "${reserved_words[@]}"; do
        if [[ "$bundle_id" == *"$word"* ]]; then
            echo -e "${RED}❌ Bundle ID contains reserved word: $word${NC}"
            return 1
        fi
    done
    
    # Check length
    if [[ ${#bundle_id} -gt 255 ]]; then
        echo -e "${RED}❌ Bundle ID too long (maximum 255 characters)${NC}"
        return 1
    fi
    
    echo -e "${GREEN}✅ Bundle ID format is valid${NC}"
    return 0
}

build_bundle_id_interactively() {
    echo -e "${CYAN}🔧 Let's build your Bundle ID step by step${NC}"
    echo ""
    
    # Step 1: Choose base strategy
    echo "Step 1: Choose your identifier strategy"
    echo ""
    echo "1) 🌐 I have a website/domain (e.g., mycompany.com → com.mycompany)"
    echo "2) 👤 Use my name (e.g., John Smith → com.johnsmith)"  
    echo "3) 🏢 Use a company/organization name (e.g., → com.mycompany)"
    echo "4) 📝 I'll enter a custom format"
    echo ""
    
    local attempts=0
    while [[ $attempts -lt 3 ]]; do
        read -p "Choose option (1-4): " STRATEGY_CHOICE
        
        case $STRATEGY_CHOICE in
            1)
                echo ""
                echo -e "${BLUE}🌐 Domain-based Bundle ID${NC}"
                echo "Enter your domain name (without www or http://)"
                echo "Examples: mycompany.com, johnsmith.dev, mycoolapp.io"
                read -p "Domain: " DOMAIN
                
                if [[ -n "$DOMAIN" ]]; then
                    # Convert domain to reverse notation
                    BUNDLE_PREFIX=$(echo "$DOMAIN" | sed 's/\./\n/g' | tac | tr '\n' '.' | sed 's/\.$//')
                    break
                else
                    echo -e "${RED}❌ Domain cannot be empty${NC}"
                fi
                ;;
            2)
                echo ""
                echo -e "${BLUE}👤 Name-based Bundle ID${NC}"
                echo "Enter your name (spaces will be converted to lowercase, no spaces)"
                echo "Examples: John Smith → johnsmith, Mary Johnson → maryjohnson"
                read -p "Your name: " USER_NAME
                
                if [[ -n "$USER_NAME" ]]; then
                    # Clean up name (lowercase, remove spaces and special chars)
                    CLEAN_NAME=$(echo "$USER_NAME" | tr '[:upper:]' '[:lower:]' | sed 's/[^a-z0-9]//g')
                    BUNDLE_PREFIX="com.$CLEAN_NAME"
                    break
                else
                    echo -e "${RED}❌ Name cannot be empty${NC}"
                fi
                ;;
            3)
                echo ""
                echo -e "${BLUE}🏢 Organization-based Bundle ID${NC}"
                echo "Enter your company/organization name (will be cleaned up)"
                echo "Examples: My Company → mycompany, Cool Apps Inc → coolapps"
                read -p "Organization: " ORG_NAME
                
                if [[ -n "$ORG_NAME" ]]; then
                    # Clean up organization name
                    CLEAN_ORG=$(echo "$ORG_NAME" | tr '[:upper:]' '[:lower:]' | sed 's/[^a-z0-9]//g')
                    BUNDLE_PREFIX="com.$CLEAN_ORG"
                    break
                else
                    echo -e "${RED}❌ Organization name cannot be empty${NC}"
                fi
                ;;
            4)
                echo ""
                echo -e "${BLUE}📝 Custom Bundle ID${NC}"
                echo "Enter your custom Bundle ID prefix (e.g., com.yourname)"
                echo "Must follow reverse domain notation"
                read -p "Custom prefix: " CUSTOM_PREFIX
                
                if [[ -n "$CUSTOM_PREFIX" ]]; then
                    BUNDLE_PREFIX="$CUSTOM_PREFIX"
                    break
                else
                    echo -e "${RED}❌ Custom prefix cannot be empty${NC}"
                fi
                ;;
            *)
                echo -e "${RED}❌ Please choose a valid option (1-4)${NC}"
                ((attempts++))
                ;;
        esac
    done
    
    if [[ $attempts -eq 3 ]]; then
        echo -e "${RED}❌ Too many invalid attempts. Using default format.${NC}"
        BUNDLE_PREFIX="com.yourname"
    fi
    
    # Step 2: Add app identifier
    echo ""
    echo "Step 2: App identifier"
    echo ""
    APP_ID=$(echo "$PROJECT_NAME" | tr '[:upper:]' '[:lower:]' | sed 's/[^a-z0-9]//g')
    SUGGESTED_BUNDLE="$BUNDLE_PREFIX.$APP_ID"
    
    echo -e "${CYAN}💡 Suggested Bundle ID: ${GREEN}$SUGGESTED_BUNDLE${NC}"
    echo ""
    
    read -p "Use this Bundle ID? (Y/n): " USE_SUGGESTED
    
    if [[ "$USE_SUGGESTED" == "n" || "$USE_SUGGESTED" == "N" ]]; then
        echo ""
        echo "Enter your custom app identifier (will be appended to: $BUNDLE_PREFIX.)"
        echo "Use only lowercase letters and numbers"
        read -p "App identifier: " CUSTOM_APP_ID
        
        if [[ -n "$CUSTOM_APP_ID" ]]; then
            CLEAN_APP_ID=$(echo "$CUSTOM_APP_ID" | tr '[:upper:]' '[:lower:]' | sed 's/[^a-z0-9]//g')
            BUNDLE_ID="$BUNDLE_PREFIX.$CLEAN_APP_ID"
        else
            BUNDLE_ID="$SUGGESTED_BUNDLE"
        fi
    else
        BUNDLE_ID="$SUGGESTED_BUNDLE"
    fi
    
    # Step 3: Validation
    echo ""
    echo -e "${CYAN}🔍 Validating Bundle ID: $BUNDLE_ID${NC}"
    
    if validate_bundle_id "$BUNDLE_ID"; then
        echo ""
        echo -e "${GREEN}🎉 Success! Your Bundle ID is ready:${NC}"
        echo -e "${GREEN}📱 Bundle ID: $BUNDLE_ID${NC}"
        echo ""
        echo -e "${BLUE}💡 Remember to:${NC}"
        echo "   • Use this exact Bundle ID in Xcode"
        echo "   • Keep it consistent across all builds"
        echo "   • Use the same format for future apps"
        echo ""
        
        # Export for parent script
        export VALIDATED_BUNDLE_ID="$BUNDLE_ID"
        return 0
    else
        echo ""
        echo -e "${YELLOW}🔄 Let's try again with a different approach...${NC}"
        echo ""
        build_bundle_id_interactively
    fi
}

# Main execution
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    # Script is being run directly
    echo "Project Name: $PROJECT_NAME"
    echo ""
    build_bundle_id_interactively
    
    if [[ -n "$VALIDATED_BUNDLE_ID" ]]; then
        echo "$VALIDATED_BUNDLE_ID"
    fi
else
    # Script is being sourced
    echo "Bundle ID helper loaded. Call build_bundle_id_interactively() to use."
fi
