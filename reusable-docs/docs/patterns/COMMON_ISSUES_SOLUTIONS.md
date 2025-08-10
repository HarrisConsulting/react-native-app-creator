# 📚 Common Issues and Solutions - ReactNativeTest Exemplar

## **🎯 Overview**
This document catalogues common issues encountered when creating projects from the ReactNativeTest exemplar, based on real experiences with TestAppB and other derived projects.

## **🚨 Critical Issues and Quick Fixes**

### **1. SafeAreaView Import Errors**
**Error**: `RNCSafeAreaProvider unimplemented component`
```tsx
// ❌ WRONG - Causes runtime errors
import { SafeAreaView } from 'react-native';

// ✅ CORRECT - Requires dependency
import { SafeAreaView } from 'react-native-safe-area-context';

// ✅ ALTERNATIVE - No dependencies required
import { View, Platform } from 'react-native';
const ManualSafeArea = ({ children }) => (
  <View style={{ 
    flex: 1, 
    paddingTop: Platform.OS === 'ios' ? 50 : 20 
  }}>
    {children}
  </View>
);
```

**Root Cause**: Wrong import source or missing dependency
**Prevention**: Use dependency validation in setup scripts

### **2. React Navigation Dependency Cascade**
**Error**: Multiple navigation-related errors (RNGestureHandlerModule, RNSScreenContainer, etc.)
**Solution**: Install ALL navigation dependencies together:
```bash
npm install @react-navigation/native @react-navigation/stack @react-navigation/bottom-tabs react-native-gesture-handler react-native-screens react-native-safe-area-context
cd ios && pod install && cd ..
```

**Root Cause**: Partial dependency installation
**Prevention**: Use dependency checklist in setup scripts

### **3. Empty Test Files Causing Suite Failures**
**Error**: `Your test suite must contain at least one test`
**Files**: `AuthContext.debug.test.tsx` and similar debug files
**Solution**: 
```bash
# Remove empty test files
find __tests__ -name "*.test.*" -size 0 -delete

# Or add minimal test content
echo 'describe("Debug", () => { test("placeholder", () => { expect(true).toBe(true); }); });' > __tests__/placeholder.test.ts
```

**Root Cause**: Template files copied without content
**Prevention**: Validate test files have actual test content

### **4. Metro Directory Mismatch**
**Error**: `No script URL provided` or red error screen
**Symptoms**: Metro runs but iOS app can't connect
**Solution**:
```bash
# Ensure Metro starts from project root
cd /absolute/path/to/project
pwd  # Verify correct directory
./enhanced-metro-safety.sh
```

**Root Cause**: Metro started from wrong directory
**Prevention**: Enhanced safety script with directory validation

### **5. Multiple Metro Instances**
**Error**: Port conflicts, connection failures
**Solution**:
```bash
# Kill ALL Metro instances
ps aux | grep -E "metro|react-native start" | grep -v grep | awk '{print $2}' | xargs kill -9
lsof -t -i:8081 | xargs kill -9

# Start safely
./enhanced-metro-safety.sh
```

**Root Cause**: Multiple Metro processes competing for port 8081
**Prevention**: Enhanced safety script with comprehensive process cleanup

## **🔧 Configuration Issues**

### **6. TypeScript Compilation Errors**
**Error**: Various TS errors in copied files
**Common Issues**:
- Import paths don't match new project structure
- Type definitions missing for copied components
- Namespace conflicts between projects

**Solution**:
```bash
# Check compilation
npm run typecheck

# Common fixes
npm install @types/react @types/react-native
```

### **7. Bundle Syntax Errors**
**Error**: JSX syntax errors, missing closing tags
**Example**: `Expected corresponding JSX closing tag for <View>`
**Solution**: Validate all JSX files have proper tag closure
**Prevention**: Use linting and TypeScript strict mode

### **8. Environment Configuration Mismatch**
**Error**: Supabase connection failures, auth errors
**Root Cause**: Environment variables from ReactNativeTest copied
**Solution**: 
```bash
# Create new .env file
cp .env.example .env
# Update with project-specific values
```

## **📋 Quality Assurance Checklist**

### **Pre-Build Validation**
- [ ] No empty test files: `find __tests__ -name "*.test.*" -size 0`
- [ ] TypeScript compiles: `npm run typecheck` 
- [ ] Linting passes: `npm run lint`
- [ ] All React Navigation deps installed
- [ ] SafeAreaView imports use correct source

### **Metro Validation**
- [ ] Only one Metro instance: `ps aux | grep metro | wc -l`
- [ ] Port 8081 available: `lsof -i :8081`
- [ ] Metro responds: `curl localhost:8081/status`
- [ ] Bundle generates: Test bundle endpoint

### **Runtime Validation**
- [ ] iOS app launches without red screen
- [ ] Navigation between screens works
- [ ] Hot reload functions
- [ ] Authentication flow works (if copied)

## **🛡️ Prevention Strategies**

### **1. Enhanced Setup Scripts**
Use the improved `rnt_setup_new_project` function that includes:
- Dependency validation
- Empty test file detection
- Path correction automation
- Configuration validation

### **2. Comprehensive Safety Scripts**
Use `enhanced-metro-safety.sh` instead of basic `start-metro.sh`:
- Thorough process cleanup
- Directory validation
- Port verification
- Cache clearing

### **3. Template Validation**
Before copying files from ReactNativeTest:
- Ensure test files have content
- Validate configuration completeness
- Check for hardcoded paths or names

### **4. Documentation Standards**
Include with each new project:
- Project-specific troubleshooting guide
- Dependency requirements list
- Metro safety protocol
- Quick recovery procedures

## **📊 Success Metrics for New Projects**

### **Build Quality**
- ✅ Zero TypeScript errors
- ✅ Zero ESLint warnings
- ✅ All tests passing (no empty test suites)
- ✅ Clean bundle generation

### **Runtime Quality**
- ✅ Instant iOS app launch
- ✅ No Metro connection errors
- ✅ Smooth navigation
- ✅ Hot reload working

### **Development Experience**
- ✅ Single command Metro startup
- ✅ Reliable build process
- ✅ Clear error messages
- ✅ Fast iteration cycle

## **🚀 Best Practices for New Projects**

1. **Always use enhanced setup scripts** from ReactNativeTest
2. **Validate dependencies immediately** after project creation
3. **Test Metro safety script** before any iOS builds
4. **Run full validation suite** before first commit
5. **Document project-specific deviations** from ReactNativeTest patterns

---

**💡 Remember**: These solutions are based on real issues encountered in TestAppB and other projects. The ReactNativeTest exemplar continues to evolve based on these lessons learned.
