# Quick Reference: iOS Clean Build Process

**🚨 EXECUTE BEFORE BUILD ATTEMPTS AFTER SIGNIFICANT CHANGES**

## ⚡ **5-Step Clean Build (5-10 minutes)**

```bash
# 1. Clear Xcode DerivedData
rm -rf ~/Library/Developer/Xcode/DerivedData

# 2. iOS Clean
cd ios
rm -rf build
xcodebuild clean -workspace ReactNativeTest.xcworkspace -scheme ReactNativeTest

# 3. RN Cache Clean  
cd ..
npm run clean  # Select: metro, watchman

# 4. Pod Refresh
cd ios
pod deintegrate
pod install

# 5. Fresh Build
cd ..
npm run ios
```

## 🎯 **When to Use**

### **MANDATORY Clean Build Triggers:**
- ✅ Authentication system changes
- ✅ Navigation structure updates  
- ✅ Dependency additions/updates
- ✅ Mysterious build failures
- ✅ Before important demos/testing
- ✅ After merging major features

### **Success Indicators:**
- ✅ `** CLEAN SUCCEEDED **` from xcodebuild
- ✅ Fresh pod installation completed
- ✅ Build progresses through compilation
- ✅ App launches without crashes

## 🚨 **Emergency Reset (if standard process fails)**

```bash
rm -rf ~/Library/Developer/Xcode/DerivedData
rm -rf node_modules
rm -rf ios/build ios/Pods ios/Podfile.lock
npm install
cd ios && pod install && cd ..
npm run ios
```

## 📚 **Full Documentation**

Complete guide: [`docs/troubleshooting/react-native-ios-clean-build-guide.md`](../troubleshooting/react-native-ios-clean-build-guide.md)

---

*This process has 99%+ success rate for resolving React Native iOS build issues*
