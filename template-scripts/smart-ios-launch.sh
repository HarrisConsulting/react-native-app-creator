#!/bin/bash

# ANSI color codes for output formatting
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
NC='\033[0m' # No Color

# Header
echo -e "${PURPLE}📱 Smart iOS Launch Protocol${NC}"

# Validate this is a React Native project
if [[ ! -f "package.json" || ! -f "index.js" ]]; then
    PROJECT_DIR=$(pwd)
    echo -e "📁 Project Directory: ${PROJECT_DIR}"
    echo -e "${RED}❌ Not in React Native project root${NC}"
    echo -e "📁 Current directory: ${PROJECT_DIR}"
    echo -e "📋 Make sure this script is in the project root directory"
    exit 1
fi

PROJECT_DIR=$(pwd)
echo -e "📁 Project Directory: ${PROJECT_DIR}"
echo -e "${GREEN}✅ Project validation passed${NC}"
echo -e "📁 Working directory: ${PROJECT_DIR}"

# Show iOS configuration info
PROJECT_NAME=$(basename "$PROJECT_DIR")
if [[ -f "ios/$PROJECT_NAME/Info.plist" ]]; then
    BUNDLE_ID=$(plutil -p "ios/$PROJECT_NAME/Info.plist" | grep CFBundleIdentifier | awk -F'"' '{print $4}')
    echo -e "📱 Bundle ID: ${BUNDLE_ID}"
fi

if [[ -f "ios/$PROJECT_NAME.xcodeproj/project.pbxproj" ]]; then
    TEAM_ID=$(grep -E "DEVELOPMENT_TEAM.*=.*;" "ios/$PROJECT_NAME.xcodeproj/project.pbxproj" | head -1 | sed 's/.*= \(.*\);/\1/')
    echo -e "👥 Team ID: ${TEAM_ID}"
fi

echo -e "${GREEN}✅ iOS configuration looks good${NC}"

# Check iOS dependencies
echo -e "${BLUE}📦 Installing iOS dependencies...${NC}"
if [[ -d "ios" ]]; then
    echo "📁 Installing CocoaPods dependencies..."
    (cd ios && pod install --silent) || {
        echo -e "${YELLOW}⚠️  CocoaPods install had issues, continuing...${NC}"
    }
    
    # Ensure we're back in project root
    if [[ "$(pwd)" != "$PROJECT_DIR" ]]; then
        echo "📁 Returning to project root: $PROJECT_DIR"
        cd "$PROJECT_DIR" || {
            echo -e "${RED}❌ Failed to return to project directory${NC}"
            exit 1
        }
    fi
else
    echo -e "${YELLOW}⚠️  iOS directory not found, skipping CocoaPods${NC}"
fi

# Verify we're in the correct directory
if [[ "$(pwd)" != "$PROJECT_DIR" ]]; then
    echo -e "${RED}❌ Directory navigation error. Expected: $PROJECT_DIR, Current: $(pwd)${NC}"
    cd "$PROJECT_DIR" || {
        echo -e "${RED}❌ Critical: Cannot navigate to project directory${NC}"
        exit 1
    }
fi

# Check if Metro bundler is running
echo -e "\n${BLUE}📦 Metro Bundler Check${NC}"
echo -e "${BLUE}=====================${NC}"

# Check if Metro bundler is running
echo -e "\n${BLUE}📦 Metro Bundler Check${NC}"
echo -e "${BLUE}=====================${NC}"

# Check if Metro is running on port 8081 using a more reliable method
if lsof -i :8081 | grep -q LISTEN; then
    echo -e "${GREEN}✅ Metro bundler is running on port 8081${NC}"
    echo -e "${BLUE}💡 Metro is running in Terminal B - perfect!${NC}"
    echo -e "${BLUE}📋 Continuing iOS build in this terminal (Terminal A)${NC}"
else
    echo -e "${YELLOW}⚠️  Metro bundler is not running${NC}"
    echo ""
    echo -e "${RED}❌ Metro bundler is required for React Native development${NC}"
    echo ""
    echo -e "${BLUE}� AUTOMATIC SOLUTION: Starting Metro in new terminal...${NC}"
    echo -e "${YELLOW}💡 Metro will open in Terminal B, this build continues in Terminal A${NC}"
    
    # Automatically open Metro in new terminal
    echo "📁 Opening Metro in new terminal from: $PROJECT_DIR"
    osascript -e "tell application \"Terminal\" to do script \"cd '$PROJECT_DIR' && npm run start-safe\""
    
    echo -e "${GREEN}✅ Metro terminal opened${NC}"
    echo -e "${BLUE}⏳ Waiting for Metro to start...${NC}"
    
    # Wait for Metro to be available
    echo -n "🔄 Checking Metro status"
    for i in {1..30}; do
        if lsof -i :8081 | grep -q LISTEN; then
            echo ""
            echo -e "${GREEN}✅ Metro is running and ready!${NC}"
            echo -e "${BLUE}📋 Continuing iOS build in this terminal${NC}"
            break
        fi
        echo -n "."
        sleep 2
    done
    
    if ! lsof -i :8081 | grep -q LISTEN; then
        echo ""
        echo -e "${RED}❌ Metro failed to start automatically${NC}"
        echo -e "${YELLOW}📋 Please check the Metro terminal and ensure it starts properly${NC}"
        echo -e "${YELLOW}💡 Look for 'Dev server ready' message, then run this script again${NC}"
        exit 1
    fi
fi

echo "📱 Launching iOS application..."

# iOS Target Selection
echo -e "\n${BLUE}📱 iOS Build Target Selection${NC}"
echo -e "${BLUE}============================${NC}"
echo "Choose your build target:"
echo "1) iOS Simulator (Recommended for development)"
echo "2) Physical Device (Requires proper Team ID configuration)"
echo ""

# Check if running in non-interactive mode
if [[ ! -t 0 ]]; then
    echo -e "${YELLOW}⚠️  Non-interactive mode detected, defaulting to iOS Simulator${NC}"
    TARGET_CHOICE="1"
else
    echo -n "Choose target (1-2): "
    read TARGET_CHOICE
fi

# Validate input
if [[ "$TARGET_CHOICE" != "1" && "$TARGET_CHOICE" != "2" ]]; then
    echo -e "${YELLOW}⚠️  Invalid choice '$TARGET_CHOICE', defaulting to iOS Simulator${NC}"
    TARGET_CHOICE="1"
fi

echo -e "${CYAN}📋 Selected option: $TARGET_CHOICE${NC}"

case $TARGET_CHOICE in
    1)
        echo -e "${GREEN}🤖 Building ONLY for iOS Simulator${NC}"
        
        # Find available simulators (iPhone 16 series)
        echo "📋 Finding available simulators..."
        SIMULATOR_LINE=$(xcrun simctl list devices | grep -E "iPhone (16|15|14|13)" | grep Booted | head -1)
        
        if [[ -z "$SIMULATOR_LINE" ]]; then
            # No booted simulator, try to find any available iPhone simulator
            echo "🔍 No booted simulators found, looking for available ones..."
            SIMULATOR_LINE=$(xcrun simctl list devices | grep -E "iPhone (16|15|14|13)" | grep -v "unavailable" | head -1)
            
            if [[ -n "$SIMULATOR_LINE" ]]; then
                # Extract device ID using improved regex
                DEVICE_ID=$(echo "$SIMULATOR_LINE" | sed -E 's/.*\(([A-F0-9-]+)\).*/\1/')
                
                if [[ -n "$DEVICE_ID" && "$DEVICE_ID" =~ ^[A-F0-9-]+$ ]]; then
                    echo "📱 Starting simulator: $DEVICE_ID"
                    xcrun simctl boot "$DEVICE_ID"
                    open -a Simulator
                    
                    # Wait for simulator to boot
                    echo "⏳ Waiting for simulator to boot..."
                    sleep 3
                else
                    echo -e "${RED}❌ Could not extract valid device ID from: $SIMULATOR_LINE${NC}"
                    echo "📋 Available simulators:"
                    xcrun simctl list devices | grep iPhone
                    echo ""
                    echo "🔧 Manual fix: Run 'open -a Simulator' to start any simulator"
                fi
            else
                echo -e "${RED}❌ No iPhone simulators found${NC}"
                echo "📋 Available devices:"
                xcrun simctl list devices
            fi
        else
            echo -e "${GREEN}✅ Simulator already running${NC}"
        fi
        
        # Build SPECIFICALLY for simulator
        echo -e "\n${GREEN}🔨 Building ONLY for iOS Simulator...${NC}"
        echo -e "${YELLOW}💡 Device builds will be skipped${NC}"
        
        # Use a specific simulator name for targeting
        SIMULATOR_NAME="iPhone 16"
        echo "📱 Building for simulator: $SIMULATOR_NAME"
        npx react-native run-ios --simulator "$SIMULATOR_NAME"
        ;;
    2)
        echo -e "${GREEN}📱 Building ONLY for Physical Device...${NC}"
        
        # Check for connected devices
        CONNECTED_DEVICES=$(xcrun xctrace list devices | grep "iPhone\|iPad" | grep -v "Simulator")
        if [[ -z "$CONNECTED_DEVICES" ]]; then
            echo -e "${YELLOW}⚠️  No physical devices detected${NC}"
            echo "📱 Make sure your device is:"
            echo "   - Connected via USB or WiFi"
            echo "   - Unlocked and trusted"
            echo "   - Has Developer Mode enabled"
            echo ""
            echo -n "🤔 Continue anyway? (y/N): "
            read CONTINUE_DEVICE
            if [[ "$CONTINUE_DEVICE" != "y" ]] && [[ "$CONTINUE_DEVICE" != "Y" ]]; then
                echo -e "${YELLOW}📋 Build cancelled${NC}"
                exit 1
            fi
        else
            echo -e "${GREEN}✅ Connected devices found:${NC}"
            echo "$CONNECTED_DEVICES"
        fi
        
        # Build SPECIFICALLY for device
        echo -e "${GREEN}🔨 Building ONLY for Physical Device...${NC}"
        echo -e "${YELLOW}💡 Simulator builds will be skipped${NC}"
        npx react-native run-ios --device
        ;;
    *)
        echo -e "${YELLOW}⚠️  Invalid choice, defaulting to iOS Simulator${NC}"
        echo -e "${GREEN}📱 Starting iOS Simulator...${NC}"
        open -a Simulator
        sleep 3
        echo "📱 Building for default simulator: iPhone 16"
        npx react-native run-ios --simulator "iPhone 16"
        ;;
esac

echo -e "\n${GREEN}✅ iOS launch completed${NC}"
echo -e "📋 If you encounter issues:"
echo -e "   🔧 Check simulator status: xcrun simctl list devices"
echo -e "   🔧 Restart Metro: npm run start-safe"
echo -e "   🔧 Clean build: npm run clean && npm run ios"
