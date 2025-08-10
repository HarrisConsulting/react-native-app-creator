# iOS Configuration Quick Reference

**Purpose**: Fast reference for iOS configuration automation tools  
**Audience**: React Native developers  
**Last Updated**: August 8, 2025

---

## 🚀 **Quick Start**

### **For New Projects**
```bash
# 1. Create project using exemplar script
./scripts/create-new-project-from-exemplar.sh YourProjectName

# 2. Configure iOS (interactive prompts)
cd YourProjectName
./configure-ios.sh

# 3. Test immediately  
npm run ios-simulator    # Recommended: Fast & reliable
```

### **For Existing Projects**
```bash
# 1. Copy automation tools
cp /path/to/ReactNativeTest/scripts/configure-ios.sh .
cp /path/to/ReactNativeTest/scripts/test-ios-build.sh .

# 2. Configure iOS
./configure-ios.sh

# 3. Validate setup
./test-ios-build.sh
```

---

## 🛠️ **Available Tools**

### **`configure-ios.sh`** - Interactive iOS Setup
**Purpose**: Configure Bundle ID and Team ID via CLI

```bash
./configure-ios.sh

# Prompts:
# Bundle ID: com.yourname.projectname
# Team ID: ABC1234DEF (optional for simulator)
```

**Features**:
- ✅ Interactive prompts with guidance
- ✅ Auto-detects project structure  
- ✅ Creates backups before changes
- ✅ Validates configuration success
- ✅ Recommends simulator builds

### **`test-ios-build.sh`** - Build Readiness Check
**Purpose**: Validate iOS configuration and build readiness

```bash
./test-ios-build.sh

# Checks:
# ✅ Project structure
# ✅ Bundle ID configuration
# ✅ Team ID (if configured)
# ✅ CocoaPods installation
# ✅ Metro bundler status
```

**Output**: Clear next steps based on configuration state

### **`cleanup-ios-setup.sh`** - Clean Up Setup Files
**Purpose**: Remove iOS setup files after successful configuration

```bash
./cleanup-ios-setup.sh

# Removes (with confirmation):
# 🔧 configure-ios.sh, test-ios-build.sh
# 💾 Xcode project backup files
# 🧪 Temporary test files
```

**Safety**: Triple confirmation required before deletion

**Output**: Clear next steps based on configuration state

---

## 📱 **Build Commands**

### **Simulator Builds (Recommended)**
```bash
# Fast, reliable, no Team ID required
npm run ios-simulator
# OR
npx react-native run-ios --simulator="iPhone 16 Plus"
npx react-native run-ios --simulator="iPhone 15"
```

### **Physical Device Builds**
```bash
# Requires Team ID configuration
npm run ios-safe
# OR  
npm run ios
```

### **Cleanup After Success**
```bash
# After iOS build works successfully
./cleanup-ios-setup.sh
# Removes setup files that are no longer needed
```

---

## 🎯 **Common Scenarios**

### **Scenario 1: Quick Testing**
```bash
# Goal: Test app immediately without complexity
./configure-ios.sh        # Enter Bundle ID, skip Team ID
npm run ios-simulator      # Launches in simulator
```

### **Scenario 2: Physical Device Testing**  
```bash
# Goal: Test on actual iPhone/iPad
./configure-ios.sh        # Enter Bundle ID AND Team ID
npm run ios-safe          # Builds for device
```

### **Scenario 3: Build Troubleshooting**
```bash
# Goal: Diagnose build issues
./test-ios-build.sh       # Shows current configuration state
# Follow recommended next steps
```

### **Scenario 4: Project Cleanup (After Success)**
```bash
# Goal: Clean up setup files after iOS works
./cleanup-ios-setup.sh    # Removes setup files no longer needed
# Requires triple confirmation for safety
```

---

## 🔍 **Finding Your Credentials**

### **Bundle ID Format**
```
Format: com.yourname.projectname
Examples:
- com.johndoe.myapp
- org.company.productname  
- com.startup.awesomeapp
```

### **Team ID Location**
```bash
# In Xcode:
1. Open Xcode → Settings → Accounts
2. Select your Apple ID → View Details  
3. Copy the 10-character Team ID
   Example: ABC1234DEF
```

---

## ⚠️ **Troubleshooting**

### **Build Failed with Code 70**
```bash
# Solution: Use simulator build instead
npm run ios-simulator
```

### **"Team not found" Error**
```bash
# Solutions:
1. Verify Team ID is correct (10 characters)
2. Use simulator build (no Team ID required)
3. Set Team manually in Xcode
```

### **"Metro not running" Warning**
```bash
# Solution: Start Metro first
./start-metro.sh
# Then build in new terminal
```

### **Configuration Not Applied**
```bash
# Solution: Run validation
./test-ios-build.sh
# Follow recommendations shown
```

---

## 🎉 **Success Indicators**

### **Configuration Success**
```bash
✅ Bundle Identifier: com.yourname.projectname
✅ Development Team: ABC1234DEF
✅ Ready for iOS build!
```

### **Build Success**
```bash
▸ Build Succeeded
success Successfully built the app
info Launching "com.yourname.projectname"  
success Successfully launched the app
```

---

## 💡 **Pro Tips**

1. **Start with simulator builds** - Faster feedback, no signing complexity
2. **Use descriptive Bundle IDs** - Easier to identify in App Store Connect
3. **Keep Team ID handy** - Needed for physical device testing and distribution
4. **Run validation first** - Saves time by catching issues early
5. **Keep backups** - Tools create them automatically, but keep originals safe

---

## 🔗 **Related Documentation**

- [`ios-configuration-automation-implementation-guide.md`](./ios-configuration-automation-implementation-guide.md) - Complete implementation details
- [`docs/troubleshooting/`](../troubleshooting/) - General troubleshooting guides
- [`docs/setup-guides/`](../setup-guides/) - Project setup documentation

---

*Quick reference for iOS Configuration Automation - ReactNativeTest Project*
