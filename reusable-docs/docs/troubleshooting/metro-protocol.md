# Metro Start Protocol Documentation

## Overview

This document establishes the foolproof protocol for starting Metro bundler from
the correct ReactNativeTest project directory to prevent directory resolution
issues.

## Problem Background

- Metro bundler was consistently starting from `/Users/rogerharris/Projects/.`
  instead of `/Users/rogerharris/Projects/ReactNativeTest`
- This caused "Unable to resolve module ./index" errors because Metro couldn't
  find the project's entry point
- Global npx metro commands don't always respect current working directory
  properly

## Solution: Foolproof Start Script

### Created Script: `/Users/rogerharris/Projects/ReactNativeTest/start-metro.sh`

```bash
#!/bin/bash

# Metro Start Protocol for ReactNativeTest
# This script ensures Metro ALWAYS starts from the correct project directory

PROJECT_DIR="/Users/rogerharris/Projects/ReactNativeTest"

echo "🚀 Starting Metro from correct project directory..."
echo "📁 Project Directory: $PROJECT_DIR"

# Change to project directory
cd "$PROJECT_DIR" || exit 1

# Verify we're in the right place
echo "📍 Current Directory: $(pwd)"
echo "✅ Verifying index.js exists: $(ls -la index.js 2>/dev/null || echo 'NOT FOUND')"

# Kill any existing Metro processes
echo "🔄 Stopping any existing Metro processes..."
pkill -f metro 2>/dev/null || true

# Start Metro with cache reset
echo "▶️ Starting Metro with cache reset..."
npm start -- --reset-cache
```

## Protocol Steps

### 1. Always Use the Script

```bash
/Users/rogerharris/Projects/ReactNativeTest/start-metro.sh
```

### 2. Alternative Manual Method (if script not available)

```bash
cd /Users/rogerharris/Projects/ReactNativeTest
pwd  # Verify you're in the correct directory
npm start -- --reset-cache
```

### 3. Verification Commands

```bash
# Test Metro bundle is serving correctly
curl -s "http://localhost:8081/index.bundle?platform=ios&dev=true&minify=false" | head -5

# Should return JavaScript bundle, not error messages
```

### 4. App Launch Protocol

```bash
cd /Users/rogerharris/Projects/ReactNativeTest
npx react-native run-ios --simulator="iPhone 16 Pro"
```

## Key Success Indicators

### Metro Running Correctly

- ✅ Shows "Starting dev server on http://localhost:8081"
- ✅ Display Metro ASCII art logo
- ✅ Shows "Dev server ready. Press Ctrl+C to exit"
- ✅ Bundle test returns JavaScript code (not errors)

### App Connection Success

- ✅ Build succeeds with "Successfully built the app"
- ✅ App launches with "Successfully launched the app"
- ✅ React Native welcome screen displays (not red error screen)

## Troubleshooting

### If Metro starts from wrong directory:

1. Stop Metro: `pkill -f metro`
2. Use the start script:
   `/Users/rogerharris/Projects/ReactNativeTest/start-metro.sh`
3. Verify bundle:
   `curl -s "http://localhost:8081/index.bundle?platform=ios&dev=true&minify=false" | head -5`

### If app shows red error screen:

1. Check Metro is running from correct directory
2. Clear Metro cache: Add `--reset-cache` to start command
3. Clear Xcode derived data if needed
4. Restart both Metro and iOS simulator

## Best Practices

1. **Always verify working directory** before starting Metro
2. **Use the project's npm scripts** rather than global commands
3. **Check bundle endpoint** to confirm Metro is serving correctly
4. **Document any deviations** from this protocol for future reference

## Status

- ✅ Script created and tested
- ✅ Metro running from correct directory
- ✅ Bundle serving JavaScript successfully
- ✅ iOS app building and launching successfully
- 🔄 Pending: Final verification of React Native welcome screen display
