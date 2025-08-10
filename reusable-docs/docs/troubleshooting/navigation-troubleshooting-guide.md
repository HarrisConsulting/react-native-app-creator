# React Native Navigation Troubleshooting Guide

## 🚨 CRITICAL: VS Code Deno Language Server Conflicts

**Issue**: "Client Deno Language Server: connection to server is erroring", EPIPE errors  
**Priority**: HIGHEST - Fix this FIRST before any development  
**Status**: ✅ **PREVENTION DOCUMENTED**

### Problem Description
Deno language server conflicts with React Native TypeScript configuration, causing:
- TypeScript IntelliSense failures  
- "connection to server is erroring" messages  
- EPIPE (Broken Pipe) errors  
- Development environment instability  

### Solution (MANDATORY)
Create `.vscode/settings.json` BEFORE opening project:

```json
{
  "deno.enable": false,
  "typescript.preferences.includePackageJsonAutoImports": "on",
  "typescript.suggest.autoImports": true,
  "typescript.updateImportsOnFileMove.enabled": "always",
  "editor.codeActionsOnSave": {
    "source.fixAll.eslint": "explicit"
  },
  "eslint.workingDirectories": ["./"]
}
```

**Verification**: No Deno error messages in VS Code output panel.

---

## Navigation Component Implementation Issues

**Issue**: Unimplemented component errors for RNSScreenNavigation and
RNCSafeAreaProvider\
**Date**: August 5, 2025\
**Status**: ✅ **RESOLVED**

## 🚨 Problem Description

When running a React Native app with navigation, you may see error messages
like:

- "Unimplemented component: <RNSScreenNavigation>"
- "Unimplemented component: <RNCSafeAreaProvider>"

These errors appear because the native iOS components for react-native-screens
and react-native-safe-area-context aren't properly linked.

## ✅ Solution Steps

### 1. Install Missing Dependencies

```bash
npm install react-native-gesture-handler
```

_Note: react-native-gesture-handler is required for proper navigation but often
missed_

### 2. Update index.js for Native Setup

Replace your `index.js` file with:

```javascript
/**
 * @format
 */

import "react-native-gesture-handler"; // Must be at the top
import { AppRegistry } from "react-native";
import App from "./App";
import { name as appName } from "./app.json";

// Enable screens native optimization
import { enableScreens } from "react-native-screens";
enableScreens();

AppRegistry.registerComponent(appName, () => App);
```

### 3. Reinstall iOS Pods

```bash
cd ios
pod install
cd ..
```

### 4. Rebuild the App

```bash
npx react-native run-ios
```

## 🔧 What This Fix Does

1. **react-native-gesture-handler**: Provides native gesture handling required
   by navigation
2. **enableScreens()**: Enables native screen optimization for better
   performance
3. **Pod install**: Links the native iOS components properly
4. **Import order**: gesture-handler must be imported first

## 🚨 Critical Requirements

- **Import Order**: `react-native-gesture-handler` MUST be the first import in
  index.js
- **Pod Installation**: Always run `pod install` after adding navigation
  dependencies
- **Complete Dependencies**: Must install all three packages:
  - `react-native-screens`
  - `react-native-safe-area-context`
  - `react-native-gesture-handler`

## ✅ Verification

After applying the fix, your app should:

- ✅ Build without errors
- ✅ Launch without red error screens
- ✅ Display navigation properly
- ✅ Show no "Unimplemented component" warnings

## 🛠️ Updated Project Creation Script

The automated script has been updated to include this fix:

```bash
# Install all required navigation dependencies
npm install @react-navigation/native @react-navigation/bottom-tabs react-native-screens react-native-safe-area-context react-native-gesture-handler

# Proper index.js setup is automatically generated
# Pod install includes all native components
```

## 📝 Prevention for Future Projects

To avoid this issue in new projects:

1. **Always install gesture-handler** with other navigation packages
2. **Set up index.js properly** from the start
3. **Run pod install** after any navigation dependencies
4. **Use the updated automated script** which includes this fix

## 🔍 Technical Details

The error occurs because:

- React Navigation uses native screen components for performance
- These components need to be registered with the native iOS bridge
- Without proper setup, React Native falls back to warning messages
- The `enableScreens()` call and gesture-handler import provide the necessary
  native bindings

---

**Fix Applied**: August 5, 2025\
**Tested On**: ReactNativeTest project\
**Result**: ✅ All navigation errors resolved
