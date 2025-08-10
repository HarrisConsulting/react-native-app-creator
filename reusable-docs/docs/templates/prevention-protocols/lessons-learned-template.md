# ReactNativeTest - Lessons Learned Template

**Copy this template for every new React Native project**

## Project Information

- **Project Name**: [YourProjectName]
- **Created**: [Date]
- **Location**: `/Users/rogerharris/Projects/[YourProjectName]`
- **React Native Version**: [Version]

## Metro Directory Error Prevention Applied

### ✅ Safety Measures Implemented at Creation

1. **Metro Safety Script Created**: `start-metro.sh`
   - Forces correct project directory resolution
   - Kills existing Metro processes
   - Starts Metro with cache reset

2. **Package.json Safety Scripts Added**:
   ```json
   {
       "scripts": {
           "start-safe": "./start-metro.sh",
           "test-bundle": "curl -s 'http://localhost:8081/index.bundle?platform=ios' | head -2",
           "verify-project": "pwd && ls -la index.js package.json ios/",
           "clean-start": "pkill -f metro || true && ./start-metro.sh",
           "ios-safe": "npm run verify-project && npx react-native run-ios"
       }
   }
   ```

3. **Critical Tests Established**:
   - Directory verification before every build
   - Bundle endpoint test after Metro start
   - Metro process location verification

### ✅ Prevention Checklist Applied

#### Phase 1: Project Creation

- [ ] Created project from correct parent directory
- [ ] Immediately created `start-metro.sh` script
- [ ] Added safety scripts to package.json
- [ ] Created protocol documentation

#### Phase 2: First Build

- [ ] Verified project directory before starting Metro
- [ ] Used safety script to start Metro (not global commands)
- [ ] Tested bundle endpoint before launching app
- [ ] Confirmed Metro running from correct directory

#### Phase 3: Verification

- [ ] Bundle test returned JavaScript (not errors)
- [ ] App launched and displayed React Native welcome screen
- [ ] No red error screens or Metro connection issues
- [ ] Documented successful verification

### ⚠️ Error Symptoms Prevented

These errors should NOT occur if protocol is followed:

- ❌ "Unable to resolve module ./index from /Users/rogerharris/Projects/."
- ❌ "No script URL provided. Make sure the packager is running"
- ❌ Red error screen on app launch
- ❌ White/blank screen after splash screen
- ❌ Metro starting from wrong directory

### 🔧 Emergency Protocols Available

If errors occur despite prevention:

1. **Immediate Response**:
   ```bash
   npm run clean-start
   npm run test-bundle  # Must pass
   npm run ios-safe
   ```

2. **Nuclear Option**:
   ```bash
   pkill -f metro
   cd /Users/rogerharris/Projects/[YourProjectName]  # Full path
   ./start-metro.sh
   # Verify bundle test passes before proceeding
   ```

### 📚 Documentation Created

- [ ] `start-metro.sh` - Executable Metro safety script
- [ ] `METRO_PROTOCOL.md` - Project-specific protocol
- [ ] `docs/anti-error-protocol.md` - Comprehensive prevention guide
- [ ] `docs/project-creation-checklist.md` - Step-by-step checklist
- [ ] `docs/quick-reference-metro-prevention.md` - Emergency reference

### 🎯 Key Lessons Applied

1. **Never Trust Working Directory**: Always explicitly verify and set project
   directory
2. **Test Bundle Before App Launch**: Bundle endpoint test is the critical
   verification
3. **Use Project Scripts, Not Global Commands**: Avoid `npx metro` in favor of
   `npm start`
4. **Create Safety Measures Immediately**: Don't wait until problems occur
5. **Document Prevention Protocols**: Make them easily accessible for team

### ✅ Success Metrics

- [ ] **Metro starts from correct directory**:
      `/Users/rogerharris/Projects/[YourProjectName]`
- [ ] **Bundle test passes**: Returns JavaScript code, not error messages
- [ ] **App displays correctly**: React Native welcome screen without errors
- [ ] **No circular debugging**: Issues prevented at source, not fixed after
      occurrence

### 🔄 Future Project Application

Copy these files to new projects:

- `start-metro.sh` (update PROJECT_DIR path)
- Safety scripts (add to package.json)
- Protocol documentation
- This lessons learned template

### 📈 Time Saved

- **ReactNativeTest debugging time**: ~2 hours of circular Metro directory
  troubleshooting
- **Prevention implementation time**: ~15 minutes of upfront safety setup
- **ROI**: Prevents hours of debugging for 15 minutes of prevention

---

**Template Usage**: Copy this template and fill in project-specific details. The
prevention protocols established in ReactNativeTest should be applied to every
new React Native project to eliminate Metro directory errors from the outset.
