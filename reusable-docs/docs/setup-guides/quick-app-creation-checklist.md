# React Native App Creation - Quick Checklist
## For Rapid Project Setup

**Use this checklist for every new React Native project**

---

## ⚡ Quick Setup (30 minutes)

### 📋 Phase 1: Project Creation (5 minutes)
- [ ] `cd /Users/[username]/Projects`
- [ ] `npx @react-native-community/cli@latest init AppName --skip-install`
- [ ] `cd AppName`
- [ ] Create Metro safety script: `./create-metro-script.sh` (see full guide)
- [ ] `chmod +x start-metro.sh`

### 📋 Phase 2: Dependencies (10 minutes)
- [ ] `npm install`
- [ ] `npm install @react-navigation/native @react-navigation/bottom-tabs`
- [ ] `npm install react-native-screens react-native-safe-area-context`
- [ ] `cd ios && pod install && cd ..`

### 📋 Phase 3: Navigation Setup (10 minutes)
- [ ] `mkdir -p src/navigation src/screens`
- [ ] Create `AppNavigator.tsx` (copy from full guide)
- [ ] Create 3 screens: `HomeScreen.tsx`, `SettingsScreen.tsx`, `AboutScreen.tsx`
- [ ] Update `App.tsx` to use AppNavigator

### 📋 Phase 4: Testing (5 minutes)
- [ ] `./start-metro.sh` (in background)
- [ ] `npm run test-bundle` (MUST return JavaScript)
- [ ] `npx react-native run-ios`
- [ ] Verify navigation works

---

## 🚨 Critical Success Tests

### Before Building:
```bash
# 1. Directory check
pwd  # Must be in project root

# 2. Structure check  
ls src/navigation/AppNavigator.tsx  # Must exist

# 3. Metro bundle test (MOST IMPORTANT)
npm run test-bundle  # Must return: var __BUNDLE_START_TIME__=...
```

### After Building:
- [ ] App launches without red error screen
- [ ] Can navigate between all 3 tabs
- [ ] Each screen displays content correctly
- [ ] Tapping buttons shows alerts

---

## 🛠️ Emergency Fixes

### Metro Not Working:
```bash
pkill -f metro
cd /full/path/to/project
./start-metro.sh
npm run test-bundle  # Must pass before building
```

### Build Failures:
```bash
cd ios
rm -rf build/
pod install
cd ..
npx react-native run-ios
```

---

## 📁 Required File Structure

```
YourApp/
├── App.tsx (updated for navigation)
├── start-metro.sh (Metro safety script)
├── src/
│   ├── navigation/
│   │   └── AppNavigator.tsx
│   └── screens/
│       ├── HomeScreen.tsx
│       ├── SettingsScreen.tsx
│       └── AboutScreen.tsx
└── package.json (with navigation deps)
```

---

## ⚙️ Key Package.json Scripts

```json
{
  "scripts": {
    "start-safe": "./start-metro.sh",
    "test-bundle": "curl -s 'http://localhost:8081/index.bundle?platform=ios' | head -2"
  }
}
```

---

## 🎯 Success Indicators

✅ **Green Lights:**
- Bundle test returns JavaScript code
- App builds without errors
- Navigation tabs work
- Screens display properly

❌ **Red Flags:**
- Bundle test returns HTML error
- Red error screen on app launch
- Metro shows wrong directory
- Build failures

---

## 📞 Quick Reference Commands

```bash
# Create project
npx @react-native-community/cli@latest init AppName --skip-install

# Install everything
npm install && npm install @react-navigation/native @react-navigation/bottom-tabs react-native-screens react-native-safe-area-context

# iOS setup
cd ios && pod install && cd ..

# Test Metro
./start-metro.sh &
npm run test-bundle

# Build
npx react-native run-ios
```

---

**Use with**: [Complete App Creation Guide](complete-app-creation-guide.md)  
**Updated**: August 4, 2025
