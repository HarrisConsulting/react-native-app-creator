#!/bin/bash

# User-Friendly Error Message System for React Native Scripts
# Translates technical errors into actionable guidance for novice users

# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

translate_error() {
    local error_code="$1"
    local context="$2"
    local suggested_command="$3"
    
    echo ""
    echo -e "${RED}🚨 Error Detected${NC}"
    echo "=================="
    
    case "$error_code" in
        "ENOENT")
            echo -e "${RED}❌ Problem: File or directory not found${NC}"
            echo -e "${BLUE}💡 What this means: The script is looking for a file that doesn't exist${NC}"
            echo -e "${YELLOW}🔧 Most likely cause: You're not in the correct project directory${NC}"
            echo ""
            echo -e "${GREEN}✅ Solution:${NC}"
            echo "1. Check your current location:"
            echo "   pwd"
            echo "2. Navigate to your project:"
            echo "   cd /Users/$(whoami)/Projects/YourProjectName"
            echo "3. Verify you're in the right place:"
            echo "   ls -la package.json index.js"
            if [[ -n "$suggested_command" ]]; then
                echo "4. Then try again:"
                echo "   $suggested_command"
            fi
            ;;
        "EACCES")
            echo -e "${RED}❌ Problem: Permission denied${NC}"
            echo -e "${BLUE}💡 What this means: The script doesn't have permission to run or access files${NC}"
            echo -e "${YELLOW}🔧 Most likely cause: Script is not executable${NC}"
            echo ""
            echo -e "${GREEN}✅ Solution:${NC}"
            echo "1. Make the script executable:"
            echo "   chmod +x script-name.sh"
            echo "2. If it's a file permission issue:"
            echo "   ls -la filename"
            echo "3. Try running with sudo (careful!):"
            echo "   sudo your-command"
            ;;
        "code_65"|"65")
            echo -e "${RED}❌ Problem: iOS build failed (Build Error 65)${NC}"
            echo -e "${BLUE}💡 What this means: iOS build process failed, usually due to configuration${NC}"
            echo -e "${YELLOW}🔧 Most likely cause: Bundle ID or Team ID not properly configured${NC}"
            echo ""
            echo -e "${GREEN}✅ Solution:${NC}"
            echo "1. Configure iOS settings:"
            echo "   npm run configure-ios"
            echo "2. Or manually in Xcode:"
            echo "   open ios/YourProject.xcworkspace"
            echo "   → Select project → Signing & Capabilities"
            echo "   → Set Team and Bundle Identifier"
            echo "3. Clean and rebuild:"
            echo "   cd ios && xcodebuild clean && cd .."
            echo "   npm run ios"
            ;;
        "metro_not_running")
            echo -e "${RED}❌ Problem: Metro bundler is not running${NC}"
            echo -e "${BLUE}💡 What this means: The development server that serves your JavaScript isn't started${NC}"
            echo -e "${YELLOW}🔧 Most likely cause: Metro was never started or crashed${NC}"
            echo ""
            echo -e "${GREEN}✅ Solution:${NC}"
            echo "1. Start Metro bundler:"
            echo "   npm run start-safe"
            echo "2. Wait for it to show 'Metro waiting on port 8081'"
            echo "3. In a NEW terminal, run your build command"
            echo "4. Keep Metro terminal open while developing"
            ;;
        "port_8081_busy")
            echo -e "${RED}❌ Problem: Port 8081 is already in use${NC}"
            echo -e "${BLUE}💡 What this means: Another process is using Metro's port${NC}"
            echo -e "${YELLOW}🔧 Most likely cause: Old Metro process still running${NC}"
            echo ""
            echo -e "${GREEN}✅ Solution:${NC}"
            echo "1. Kill existing Metro processes:"
            echo "   pkill -f metro"
            echo "2. Or find and kill the specific process:"
            echo "   lsof -ti:8081 | xargs kill -9"
            echo "3. Start Metro fresh:"
            echo "   npm run start-safe"
            ;;
        "bundle_not_javascript")
            echo -e "${RED}❌ Problem: Metro is serving HTML instead of JavaScript${NC}"
            echo -e "${BLUE}💡 What this means: Metro bundler started in wrong directory${NC}"
            echo -e "${YELLOW}🔧 Most likely cause: Metro was started outside the project directory${NC}"
            echo ""
            echo -e "${GREEN}✅ Solution:${NC}"
            echo "1. Stop Metro (Ctrl+C in Metro terminal)"
            echo "2. Navigate to correct project directory:"
            echo "   cd /Users/$(whoami)/Projects/YourProjectName"
            echo "3. Verify you're in the right place:"
            echo "   ls package.json index.js"
            echo "4. Start Metro from project root:"
            echo "   npm run start-safe"
            ;;
        "cocoapods_error")
            echo -e "${RED}❌ Problem: CocoaPods installation failed${NC}"
            echo -e "${BLUE}💡 What this means: iOS native dependencies couldn't be installed${NC}"
            echo -e "${YELLOW}🔧 Most likely cause: CocoaPods needs updating or clean install${NC}"
            echo ""
            echo -e "${GREEN}✅ Solution:${NC}"
            echo "1. Update CocoaPods:"
            echo "   sudo gem install cocoapods"
            echo "2. Clean and reinstall:"
            echo "   cd ios"
            echo "   pod deintegrate"
            echo "   pod install"
            echo "   cd .."
            echo "3. If still failing, try:"
            echo "   cd ios && pod install --repo-update"
            ;;
        "simulator_not_found")
            echo -e "${RED}❌ Problem: iOS Simulator not found or not available${NC}"
            echo -e "${BLUE}💡 What this means: Xcode simulator isn't running or accessible${NC}"
            echo -e "${YELLOW}🔧 Most likely cause: Simulator needs to be opened manually${NC}"
            echo ""
            echo -e "${GREEN}✅ Solution:${NC}"
            echo "1. Open iOS Simulator manually:"
            echo "   open -a Simulator"
            echo "2. Or through Xcode:"
            echo "   Xcode → Open Developer Tool → Simulator"
            echo "3. Then try your build command again"
            echo "4. Alternative - build for device:"
            echo "   npm run ios -- --device"
            ;;
        "node_modules_error")
            echo -e "${RED}❌ Problem: Node modules installation or dependency error${NC}"
            echo -e "${BLUE}💡 What this means: JavaScript dependencies are missing or corrupted${NC}"
            echo -e "${YELLOW}🔧 Most likely cause: Incomplete npm install or version conflicts${NC}"
            echo ""
            echo -e "${GREEN}✅ Solution:${NC}"
            echo "1. Clean and reinstall dependencies:"
            echo "   rm -rf node_modules package-lock.json"
            echo "   npm install"
            echo "2. Clear npm cache if needed:"
            echo "   npm cache clean --force"
            echo "3. Check Node.js version:"
            echo "   node --version  # Should be 18.x or higher"
            ;;
        "command_not_found")
            echo -e "${RED}❌ Problem: Command not found${NC}"
            echo -e "${BLUE}💡 What this means: The system can't find the command you're trying to run${NC}"
            echo -e "${YELLOW}🔧 Most likely cause: Tool not installed or not in PATH${NC}"
            echo ""
            echo -e "${GREEN}✅ Solution:${NC}"
            echo "1. Check if the tool is installed:"
            echo "   which command-name"
            echo "2. Install missing tools:"
            echo "   • For Node.js: https://nodejs.org"
            echo "   • For CocoaPods: sudo gem install cocoapods"
            echo "   • For Xcode: Mac App Store"
            echo "3. Restart terminal after installation"
            ;;
        *)
            echo -e "${RED}❌ Problem: $error_code${NC}"
            echo -e "${BLUE}💡 What this means: An unexpected error occurred${NC}"
            echo -e "${YELLOW}🔧 This might be a new or uncommon issue${NC}"
            echo ""
            echo -e "${GREEN}✅ General troubleshooting steps:${NC}"
            echo "1. Check you're in the correct project directory:"
            echo "   pwd && ls package.json"
            echo "2. Try restarting Metro:"
            echo "   pkill -f metro && npm run start-safe"
            echo "3. Clean and reinstall:"
            echo "   rm -rf node_modules && npm install"
            echo "4. Check the full error message above for more details"
            ;;
    esac
    
    echo ""
    echo -e "${CYAN}📚 Need more help?${NC}"
    echo "• Check troubleshooting guide: docs/troubleshooting/README.md"
    echo "• Review common issues: docs/troubleshooting/anti-error-protocol.md"
    echo "• Verify system setup: ./check-prerequisites.sh"
    echo ""
}

# Quick error detector function
detect_error_from_output() {
    local output="$1"
    
    if echo "$output" | grep -q "ENOENT"; then
        echo "ENOENT"
    elif echo "$output" | grep -q "EACCES"; then
        echo "EACCES"
    elif echo "$output" | grep -q "code 65\|exit code 65"; then
        echo "code_65"
    elif echo "$output" | grep -q "Metro.*not.*running\|No bundle URL present"; then
        echo "metro_not_running"
    elif echo "$output" | grep -q "port.*8081.*already in use\|EADDRINUSE.*8081"; then
        echo "port_8081_busy"
    elif echo "$output" | grep -q "pod install failed\|CocoaPods.*error"; then
        echo "cocoapods_error"
    elif echo "$output" | grep -q "Simulator.*not found\|device not found"; then
        echo "simulator_not_found"
    elif echo "$output" | grep -q "node_modules.*not found\|Cannot resolve module"; then
        echo "node_modules_error"
    elif echo "$output" | grep -q "command not found"; then
        echo "command_not_found"
    elif echo "$output" | grep -q "<html>\|<!DOCTYPE html>"; then
        echo "bundle_not_javascript"
    else
        echo "unknown"
    fi
}

# Wrapper function for commands with automatic error handling
run_with_error_handling() {
    local command="$1"
    local description="$2"
    
    echo -e "${BLUE}🔄 Running: $description${NC}"
    echo "Command: $command"
    echo ""
    
    # Capture both stdout and stderr
    local output
    local exit_code
    
    if output=$(eval "$command" 2>&1); then
        exit_code=0
        echo -e "${GREEN}✅ Success: $description${NC}"
        return 0
    else
        exit_code=$?
        echo -e "${RED}❌ Failed: $description${NC}"
        
        # Detect error type and provide guidance
        local error_type=$(detect_error_from_output "$output")
        translate_error "$error_type" "$description" "$command"
        
        return $exit_code
    fi
}

# Function to show context when errors occur
show_error_context() {
    echo ""
    echo -e "${CYAN}🔍 Current System Context${NC}"
    echo "========================"
    echo "📁 Working Directory: $(pwd)"
    echo "👤 User: $(whoami)"
    echo "🖥️  System: $(uname -s) $(uname -r)"
    echo "📦 Node.js: $(node --version 2>/dev/null || echo "Not found")"
    echo "📦 npm: $(npm --version 2>/dev/null || echo "Not found")"
    echo ""
    
    # Check if we're in a React Native project
    if [[ -f "package.json" && -f "index.js" ]]; then
        echo -e "${GREEN}✅ React Native project detected${NC}"
        PROJECT_NAME=$(node -p "require('./package.json').name" 2>/dev/null || echo "Unknown")
        echo "📱 Project: $PROJECT_NAME"
    else
        echo -e "${YELLOW}⚠️  Not in React Native project directory${NC}"
        echo -e "${YELLOW}💡 You might need to navigate to your project folder${NC}"
    fi
    echo ""
}

# Export functions for use in other scripts
export -f translate_error
export -f detect_error_from_output
export -f run_with_error_handling
export -f show_error_context

# If script is run directly, show help
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    echo -e "${BLUE}🔧 User-Friendly Error Handler${NC}"
    echo "================================"
    echo ""
    echo "This script provides user-friendly error messages for common React Native issues."
    echo ""
    echo "Usage:"
    echo "  source error-handler.sh          # Load functions"
    echo "  translate_error ERROR_CODE       # Get help for specific error"
    echo "  show_error_context              # Show current system context"
    echo ""
    echo "Example error codes:"
    echo "  ENOENT, EACCES, code_65, metro_not_running, port_8081_busy"
    echo ""
    
    # Show current context as example
    show_error_context
fi
