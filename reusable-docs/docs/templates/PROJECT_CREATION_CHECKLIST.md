# 🎯 Project Creation Checklist - ReactNativeTest Exemplar

## **Pre-Creation Validation** ✅

### **Environment Check**
- [ ] React Native CLI installed (`npx react-native --version`)
- [ ] Node.js version >= 18 (`node --version`)
- [ ] iOS development tools installed (Xcode, Simulator)
- [ ] CocoaPods installed (`pod --version`)

### **Project Directory**
- [ ] Target directory doesn't exist
- [ ] Parent directory has write permissions
- [ ] No spaces or special characters in project name

## **Critical Dependencies** 🔧

### **React Navigation Stack (REQUIRED)**
```json
{
  "@react-navigation/native": "^7.1.17",
  "@react-navigation/stack": "^7.4.5", 
  "@react-navigation/bottom-tabs": "^7.4.5",
  "react-native-gesture-handler": "^2.28.0",
  "react-native-screens": "^4.13.1",
  "react-native-safe-area-context": "^5.6.0"
}
```

### **Common Import Errors to Avoid**
```tsx
// ❌ WRONG - Causes RNCSafeAreaProvider errors
import { SafeAreaView } from 'react-native';

// ✅ CORRECT - Use the navigation dependency
import { SafeAreaView } from 'react-native-safe-area-context';

// ✅ ALTERNATIVE - Simple manual padding
import { View, Platform } from 'react-native';
// Then add: paddingTop: Platform.OS === 'ios' ? 50 : 20
```

## **Metro Safety Protocol** 🛡️

### **Pre-Flight Check**
- [ ] Kill ALL existing Metro instances
- [ ] Verify port 8081 is free
- [ ] Verify project directory structure

### **Safe Start Sequence**
1. **Cleanup**: `pkill -f metro && lsof -t -i:8081 | xargs kill -9`
2. **Verify**: `lsof -i :8081` (should return nothing)
3. **Start**: `./start-metro.sh`
4. **Test**: `curl -s 'http://localhost:8081/status'`
5. **Build**: `npx react-native run-ios --simulator "iPhone 15 Pro"`

## **File Structure Validation** 📁

### **Essential Files Must Exist**
- [ ] `package.json` with correct project name
- [ ] `index.js` (app entry point)
- [ ] `App.tsx` with proper imports
- [ ] `ios/` directory with `.xcworkspace`
- [ ] `src/` directory structure

### **Configuration Files**
- [ ] `metro.config.js` - Bundle configuration
- [ ] `babel.config.js` - Transpilation setup
- [ ] `tsconfig.json` - TypeScript configuration
- [ ] `.eslintrc.js` - Code quality rules

## **Testing Infrastructure** 🧪

### **Test File Validation**
- [ ] No empty test files (check for `describe` or `test` blocks)
- [ ] All test files have valid imports
- [ ] Jest configuration supports React Navigation
- [ ] Mock files properly configured

### **Common Test Issues**
- Empty debug test files cause suite failures
- Missing React Navigation test setup
- Async/await patterns need proper handling

## **Post-Creation Verification** ✅

### **Build Success Criteria**
- [ ] TypeScript compilation: `npm run typecheck` (zero errors)
- [ ] Linting: `npm run lint` (zero errors/warnings)
- [ ] Tests: `npm test` (all suites pass)
- [ ] Metro bundle: `npm run test-bundle` (valid bundle response)
- [ ] iOS build: App launches without red screen errors

### **Runtime Validation**
- [ ] App launches in iOS Simulator
- [ ] No Metro connection errors
- [ ] Navigation works between screens
- [ ] Authentication flow functional (if included)
- [ ] Hot reloading works

## **Emergency Recovery** 🚨

### **If Build Fails**
1. **Clean Environment**:
   ```bash
   pkill -f metro
   rm -rf node_modules ios/build
   npm install
   cd ios && pod install && cd ..
   ```

2. **Restart Metro**:
   ```bash
   ./start-metro.sh
   npm run test-bundle  # Must pass
   ```

3. **Rebuild iOS**:
   ```bash
   npx react-native run-ios --simulator "iPhone 15 Pro"
   ```

### **If Metro Connection Fails**
- Check only ONE Metro instance running: `ps aux | grep metro`
- Verify port 8081 is bound: `lsof -i :8081`
- Test Metro response: `curl localhost:8081/status`
- Restart with cache reset: `npx react-native start --reset-cache`

## **Success Indicators** 🎉

- ✅ Zero TypeScript errors
- ✅ Zero ESLint warnings  
- ✅ All tests passing
- ✅ Metro responds on port 8081
- ✅ iOS Simulator shows app without errors
- ✅ Hot reloading functional
- ✅ Navigation works between screens

---

**📝 Note**: This checklist is based on lessons learned from TestAppB creation issues and ReactNativeTest success patterns.
