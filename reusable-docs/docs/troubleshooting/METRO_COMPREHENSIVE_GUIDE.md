# 🚨 Metro Bundler Troubleshooting Guide - ReactNativeTest Exemplar

## **Overview**
This comprehensive troubleshooting guide is based on lessons learned from TestAppB project issues and ReactNativeTest success patterns. It provides systematic resolution for Metro bundler conflicts and iOS connection issues.

## **📋 Quick Diagnosis Checklist**

### **Symptoms → Root Cause → Solution**

| **Error Symptom** | **Root Cause** | **Quick Fix** |
|-------------------|----------------|---------------|
| `No script URL provided` | Metro not running/reachable | `./scripts/enhanced-metro-safety.sh` |
| `RNGestureHandlerModule not found` | Missing React Navigation deps | `npm i react-native-gesture-handler && cd ios && pod install` |
| `RNCSafeAreaProvider unimplemented` | Wrong SafeAreaView import | Change import to `react-native-safe-area-context` |
| Red error screen in simulator | Metro directory mismatch | Kill Metro, restart from project root |
| `port 8081 already in use` | Multiple Metro instances | Use enhanced safety script |
| White screen, no errors | Bundle not loading | Test with `curl localhost:8081/status` |

## **🛡️ Metro Safety Protocol (Zero-Conflict Guarantee)**

### **Rule #1: ONE Metro Instance Only**
- Multiple Metro instances cause port conflicts
- Always use enhanced safety script for guaranteed single instance
- Never run `npm start` or `npx react-native start` directly

### **Enhanced Safety Script Usage**
```bash
# From ReactNativeTest exemplar
cp /path/to/ReactNativeTest/scripts/enhanced-metro-safety.sh .
chmod +x enhanced-metro-safety.sh

# Edit script to update PROJECT_DIR and PROJECT_NAME
# Then run:
./enhanced-metro-safety.sh
```

### **Manual Safety Protocol (If Script Unavailable)**
```bash
# 1. Kill ALL Metro instances
ps aux | grep -E "metro|react-native start" | grep -v grep | awk '{print $2}' | xargs kill -9
lsof -t -i:8081 | xargs kill -9

# 2. Verify port is free
lsof -i :8081  # Should return nothing

# 3. Start Metro from project directory
cd /path/to/your/project
npx react-native start --reset-cache --host localhost --port 8081
```

## **🔍 Diagnostic Commands**

### **Metro Status Check**
```bash
# Check if Metro is running
lsof -i :8081
ps aux | grep metro | grep -v grep

# Test Metro response
curl -s 'http://localhost:8081/status'
# Expected: {"packager-status":"running"}

# Test bundle generation
curl -s 'http://localhost:8081/index.bundle?platform=ios' | head -2
# Expected: var __BUNDLE_START_TIME__=...
```

### **Process Analysis**
```bash
# Detailed Metro process information
ps aux | grep -E "metro|react-native|node" | grep -v grep

# Network connections from iOS Simulator
lsof -i :8081 | grep -E "(node|TestApp|YourApp)"
# Should show: node (Metro) + iOS simulator connections
```

## **📱 iOS Simulator Connection Issues**

### **"No script URL provided" Error**
**Root Cause**: iOS app cannot connect to Metro bundler

**Resolution Steps**:
1. **Verify Metro is running**: `lsof -i :8081`
2. **Test Metro response**: `curl localhost:8081/status`
3. **Check iOS app can reach Metro**:
   ```bash
   # From iOS Simulator menu: Device → Erase All Content and Settings
   # Then rebuild app
   npx react-native run-ios --simulator "iPhone 15 Pro"
   ```

### **Metro Directory Mismatch**
**Symptoms**: Metro runs but iOS app shows red error screen

**Resolution**:
```bash
# 1. Ensure Metro starts from correct directory
cd /absolute/path/to/your/project
pwd  # Verify you're in project root
ls index.js package.json  # Verify essential files exist

# 2. Kill and restart Metro from correct location
./enhanced-metro-safety.sh
```

## **⚛️ React Navigation Dependency Issues**

### **Critical Dependencies (Must Install Together)**
```bash
# Install all React Navigation dependencies at once
npm install @react-navigation/native @react-navigation/stack @react-navigation/bottom-tabs
npm install react-native-gesture-handler react-native-screens react-native-safe-area-context

# iOS native dependencies
cd ios && pod install && cd ..
```

### **SafeAreaView Import Fix**
```tsx
// ❌ WRONG - Causes RNCSafeAreaProvider errors
import { SafeAreaView } from 'react-native';

// ✅ CORRECT - Requires react-native-safe-area-context
import { SafeAreaView } from 'react-native-safe-area-context';

// ✅ ALTERNATIVE - Manual safe area handling
import { View, Platform } from 'react-native';
const styles = StyleSheet.create({
  safeArea: {
    flex: 1,
    paddingTop: Platform.OS === 'ios' ? 50 : 20,
  }
});
```

### **Common Navigation Errors**
| **Error** | **Missing Dependency** | **Fix Command** |
|-----------|------------------------|-----------------|
| `RNGestureHandlerModule` | react-native-gesture-handler | `npm i react-native-gesture-handler && cd ios && pod install` |
| `RNSScreenContainer` | react-native-screens | `npm i react-native-screens && cd ios && pod install` |
| `RNCSafeAreaProvider` | react-native-safe-area-context | `npm i react-native-safe-area-context && cd ios && pod install` |

## **🧪 Testing and Validation**

### **Build Success Validation**
```bash
# 1. TypeScript compilation
npm run typecheck  # Must show no errors

# 2. Linting
npm run lint       # Must show no errors/warnings

# 3. Test suite
npm test           # All suites must pass (check for empty test files)

# 4. Metro bundle generation
npm run test-bundle || curl -s 'http://localhost:8081/index.bundle?platform=ios' | head -2
```

### **Runtime Validation**
1. **Metro Connection**: iOS app connects without "No script URL" error
2. **Navigation**: Can navigate between screens without crashes
3. **Hot Reload**: Code changes reflect immediately in simulator
4. **Authentication**: Auth flow works (if implemented)

## **🚨 Emergency Recovery Procedures**

### **Complete Environment Reset**
```bash
# 1. Stop everything
pkill -f metro
pkill -f "iOS Simulator"

# 2. Clean build artifacts
rm -rf node_modules ios/build android/app/build
npm cache clean --force

# 3. Reinstall dependencies
npm install
cd ios && pod install && cd ..

# 4. Restart Metro safely
./enhanced-metro-safety.sh

# 5. Rebuild iOS (in new terminal)
npx react-native run-ios --simulator "iPhone 15 Pro"
```

### **Last Resort: Project Recreation**
If issues persist, recreate project using ReactNativeTest exemplar:
```bash
# Use proven creation script
/path/to/ReactNativeTest/scripts/create-new-project-from-exemplar.sh
```

## **📊 Success Metrics**

### **Metro Health Indicators**
- ✅ Single Metro process: `ps aux | grep metro | wc -l` returns 1-2 lines
- ✅ Port bound correctly: `lsof -i :8081` shows node process
- ✅ Metro responds: `curl localhost:8081/status` returns running status
- ✅ Bundle generates: Bundle test returns valid JavaScript

### **iOS Connection Health**
- ✅ No red error screens in simulator
- ✅ Hot reload works on file changes
- ✅ Navigation between screens functions
- ✅ Console shows Metro connection logs

### **Build Quality Indicators**
- ✅ Zero TypeScript errors
- ✅ Zero ESLint warnings
- ✅ All tests passing
- ✅ Clean build with no deprecated warnings

---

**💡 Pro Tip**: Always use the enhanced Metro safety script for new projects created from ReactNativeTest exemplar. It implements all lessons learned from TestAppB troubleshooting and guarantees conflict-free Metro startup.
