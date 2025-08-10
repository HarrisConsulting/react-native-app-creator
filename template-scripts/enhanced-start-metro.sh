#!/bin/bash

# Enhanced Metro Safety Protocol - Template Version
# Automatically determines project directory and handles port conflicts
# Designed to be copied to new React Native projects

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Auto-detect project directory
PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo -e "${GREEN}🚀 Enhanced Metro Startup Protocol${NC}"
echo -e "${BLUE}📁 Project Directory: $PROJECT_DIR${NC}"

# Validate we're in a React Native project
if [[ ! -f "$PROJECT_DIR/package.json" ]] || [[ ! -f "$PROJECT_DIR/index.js" ]]; then
    echo -e "${RED}❌ Not in React Native project root${NC}"
    echo "📁 Current directory: $PROJECT_DIR"
    echo "📋 Make sure this script is in the project root directory"
    exit 1
fi

# Change to project directory
cd "$PROJECT_DIR" || exit 1
echo -e "${GREEN}✅ Working from: $(pwd)${NC}"

# Check if Metro is already running properly
if lsof -i :8081 | grep -q LISTEN; then
    echo -e "${GREEN}✅ Metro bundler is already running and responsive${NC}"
    echo -e "${BLUE}📋 Metro is ready for React Native development${NC}"
    echo -e "${YELLOW}💡 Use r/d/j commands in this terminal only${NC}"
    exit 0
fi

# Check if port is occupied by non-Metro process
if lsof -Pi :8081 -sTCP:LISTEN -t >/dev/null 2>&1; then
    echo -e "${YELLOW}⚠️  Port 8081 is in use by non-Metro process${NC}"
    echo -n "🔄 Kill existing process and start Metro? (Y/n): "
    read RESTART_METRO
    if [[ "$RESTART_METRO" != "n" ]] && [[ "$RESTART_METRO" != "N" ]]; then
        echo "🛑 Stopping existing process on port 8081..."
        lsof -ti:8081 | xargs kill -9 2>/dev/null || true
        sleep 3
        echo -e "${GREEN}✅ Port 8081 cleared${NC}"
    else
        echo -e "${YELLOW}📋 Keeping existing process - Metro startup cancelled${NC}"
        exit 1
    fi
fi

echo -e "${BLUE}🚨 CRITICAL: Metro Terminal Usage Warning${NC}"
echo -e "${BLUE}==========================================${NC}"
echo -e "${YELLOW}⚠️  Once Metro starts, ONLY use these commands in this terminal:${NC}"
echo -e "${GREEN}   r  - reload app(s)${NC}"
echo -e "${GREEN}   d  - open Dev Menu${NC}"
echo -e "${GREEN}   j  - open DevTools${NC}"
echo -e "${RED}❌ DO NOT run other commands (cd, npm, etc.) - they will terminate Metro!${NC}"
echo -e "${BLUE}💡 For iOS builds, use a DIFFERENT terminal window${NC}"
echo ""
echo "🚀 Starting Metro bundler with cache reset..."
npx react-native start --reset-cache
