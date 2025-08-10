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
if [[ -f "ios/ReactNativeTest/Info.plist" ]]; then
    BUNDLE_ID=$(plutil -p ios/ReactNativeTest/Info.plist | grep CFBundleIdentifier | awk -F'"' '{print $4}')
    echo -e "📱 Bundle ID: ${BUNDLE_ID}"
fi

if [[ -f "ios/ReactNativeTest.xcodeproj/project.pbxproj" ]]; then
    TEAM_ID=$(grep -E "DEVELOPMENT_TEAM.*=.*;" ios/ReactNativeTest.xcodeproj/project.pbxproj | head -1 | sed 's/.*= \(.*\);/\1/')
    echo -e "👥 Team ID: ${TEAM_ID}"
fi

echo -e "${GREEN}✅ iOS configuration looks good${NC}"

# Check iOS dependencies
echo -e "${BLUE}📦 Installing iOS dependencies...${NC}"
if [[ -d "ios" ]]; then
    cd ios && pod install --silent && cd ..
fi

cd "$PROJECT_DIR" || exit 1

# Check if Metro bundler is running
echo -e "\n${BLUE}📦 Metro Bundler Check${NC}"
echo -e "${BLUE}=====================${NC}"

if curl -s http://localhost:8081/status &>/dev/null; then
    echo -e "${GREEN}✅ Metro bundler is running on port 8081${NC}"
else
    echo -e "${YELLOW}⚠️  Metro bundler is not running${NC}"
    echo ""
    echo "Metro bundler is required for React Native development."
    echo ""
    echo "Options:"
    echo "1) Start Metro bundler now (recommended)"
    echo "2) Continue without Metro (will likely fail)"
    echo ""
    echo -n "Choose option (1-2): "
    read METRO_CHOICE
    
    case $METRO_CHOICE in
        1)
            echo -e "${GREEN}🚀 Starting Metro bundler...${NC}"
            if [[ -f "./start-metro.sh" ]]; then
                echo "📋 Using enhanced Metro script..."
                ./start-metro.sh &
                METRO_PID=$!
                echo "📦 Metro PID: $METRO_PID"
                
                # Wait for Metro to start
                echo "⏳ Waiting for Metro to start..."
                for i in {1..10}; do
                    if curl -s http://localhost:8081/status &>/dev/null; then
                        echo -e "${GREEN}✅ Metro bundler started successfully${NC}"
                        break
                    fi
                    sleep 2
                done
                
                if ! curl -s http://localhost:8081/status &>/dev/null; then
                    echo -e "${RED}❌ Metro failed to start${NC}"
                    echo "🔧 Try running 'npm run start-safe' in a separate terminal"
                fi
            else
                echo "📋 Using standard Metro startup..."
                npx react-native start &
                echo "⏳ Waiting for Metro to start..."
                sleep 5
            fi
            ;;
        2)
            echo -e "${YELLOW}⚠️  Continuing without Metro - build may fail${NC}"
            ;;
        *)
            echo -e "${YELLOW}⚠️  Invalid choice, starting Metro...${NC}"
            npx react-native start &
            sleep 5
            ;;
    esac
fi

echo "📱 Launching iOS application..."

# iOS Target Selection
echo -e "\n${BLUE}📱 iOS Build Target Selection${NC}"
echo -e "${BLUE}============================${NC}"
echo "Choose your build target:"
echo "1) iOS Simulator (Recommended for development)"
echo "2) Physical Device (Requires proper Team ID configuration)"
echo ""
echo -n "Choose target (1-2): "
read TARGET_CHOICE

case $TARGET_CHOICE in
    1)
        echo -e "${GREEN}🤖 Using iOS Simulator${NC}"
        
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
        
        # Build for simulator
        echo -e "\n${GREEN}🔨 Building for iOS Simulator...${NC}"
        npx react-native run-ios
        ;;
    2)
        echo -e "${GREEN}📱 Building for Physical Device...${NC}"
        
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
        
        # Build for device
        echo -e "${GREEN}🔨 Building for Physical Device...${NC}"
        npx react-native run-ios --device
        ;;
    *)
        echo -e "${YELLOW}⚠️  Invalid choice, defaulting to Simulator${NC}"
        echo -e "${GREEN}📱 Starting iOS Simulator...${NC}"
        open -a Simulator
        sleep 3
        npx react-native run-ios --simulator
        ;;
esac

echo -e "\n${GREEN}✅ iOS launch completed${NC}"
echo -e "📋 If you encounter issues:"
echo -e "   🔧 Check simulator status: xcrun simctl list devices"
echo -e "   🔧 Restart Metro: npm run start-safe"
echo -e "   🔧 Clean build: npm run clean && npm run ios"
