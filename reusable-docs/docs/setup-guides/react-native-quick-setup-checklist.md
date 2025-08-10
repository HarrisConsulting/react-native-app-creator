# React Native Project Quick Setup Checklist

**⏰ Total Time**: ~2.5 hours\
**🎯 Result**: Production-ready React Native app with CI/CD\
**📋 Based on**: ReactNativeTest proven implementation

---

## Phase 1: Foundation (30 min) ✅

```bash
# 1. Environment Check
node --version && npm --version && git --version

# 2. Create Project
npx react-native@latest init YourProject --template react-native-template-typescript
cd YourProject

# 3. Configure Development Environment (CRITICAL)
mkdir -p .vscode
cat > .vscode/settings.json << 'EOF'
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
EOF

# 4. Initial Validation
npm run lint && npm run typecheck

# 5. Git Setup
git add . && git commit -m "feat: Initial React Native project with dev environment"
gh repo create YourProject --public --source=. --push
```

**✅ Checkpoint**: Project compiles, dev environment configured, and is in GitHub

---

## Phase 2: Navigation (45 min) ✅

```bash
# 1. Install Dependencies
npm install @react-navigation/native @react-navigation/bottom-tabs
npm install react-native-screens react-native-safe-area-context react-native-gesture-handler
cd ios && pod install && cd ..

# 2. Create Structure
mkdir -p src/navigation src/screens
```

**Create Files:**

- [ ] `src/screens/HomeScreen.tsx` (use StyleSheet.create)
- [ ] `src/screens/SettingsScreen.tsx`
- [ ] `src/screens/AboutScreen.tsx`
- [ ] `src/navigation/AppNavigator.tsx` (components outside render)
- [ ] Update `App.tsx` with navigation

**✅ Checkpoint**: `npm run ios` shows working tabs

---

## Phase 3: Testing (30 min) ✅

**Create Files:**

- [ ] `jest.config.js` with transformIgnorePatterns
- [ ] `jest.setup.js` with `/* eslint-env jest */`

**Update Files:**

- [ ] `package.json` scripts section

```bash
# Validation Commands
npm test -- --watchAll=false
npm run lint
npm run typecheck
```

**✅ Checkpoint**: All tests pass, zero warnings

---

## Phase 4: CI/CD (45 min) ✅

**⚠️ CRITICAL: Check for duplicate workflows first**

```bash
# Remove any existing backup/duplicate workflow files
ls -la .github/workflows/
rm .github/workflows/*backup*.yml 2>/dev/null || true
rm .github/workflows/*clean*.yml 2>/dev/null || true
```

**Create File:**

- [ ] `.github/workflows/ci-cd.yml` (5-job pipeline)

**Key Features:**

- [ ] `npm ci --ignore-scripts` (prevents CocoaPods issues)
- [ ] Node 18.x LTS
- [ ] Parallel job execution
- [ ] Comprehensive summary
- [ ] **ONLY ONE workflow file** (no duplicates)

```bash
git add .
git commit -m "feat: Complete navigation and CI/CD pipeline"
git push origin main
```

**✅ Checkpoint**: 5/5 CI jobs pass in ~1-2 minutes (single workflow run)

---

## Phase 5: Documentation (30 min) ✅

**Create Files:**

- [ ] Update `README.md` with setup instructions
- [ ] `docs/troubleshooting-quick-reference.md`

**Final Validation:**

```bash
npm run lint          # Zero warnings
npm test -- --watchAll=false  # All pass
npm run typecheck     # Clean TypeScript
npm run ios           # Working app
gh run list --limit 1 # Successful CI
```

---

## 🚨 Critical Prevention (DO FIRST)

Before opening any React Native project in VS Code:

```bash
# REQUIRED: Create .vscode/settings.json to prevent Deno conflicts
mkdir -p .vscode
cat > .vscode/settings.json << 'EOF'
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
EOF
```

**Why**: Prevents "Deno Language Server: connection to server is erroring" and EPIPE errors that break TypeScript support.

---

### **Order Matters**

1. Basic project setup first
2. Navigation before CI/CD
3. Jest config before workflow
4. Test locally before pushing

### **Success Indicators**

- [ ] CI pipeline runtime > 30 seconds (not immediate failure)
- [ ] All ESLint checks pass with zero warnings
- [ ] Jest tests run without ES module errors
- [ ] App launches with working navigation
- [ ] GitHub Actions shows 5/5 green jobs

---

## 🎯 **Validation Commands**

Run these at each checkpoint:

```bash
# Code Quality
npm run lint
npm run typecheck
npm test -- --watchAll=false

# App Functionality  
npm run ios
npm run android

# CI/CD Status
gh run list --limit 1
gh run view # View latest run details
```

---

## 🚀 **Success Result**

Following this checklist produces:

- ✅ **Zero-warning CI/CD pipeline** (100% success rate)
- ✅ **Production-ready React Native app** with navigation
- ✅ **Enterprise-grade foundation** for iOS/Android builds
- ✅ **Comprehensive documentation** and troubleshooting

**🎉 Total Time**: ~2.5 hours to production-ready state!

---

## 📞 **Quick Troubleshooting**

| Issue                  | Immediate Fix                              |
| ---------------------- | ------------------------------------------ |
| CI fails at 0 seconds  | Check YAML syntax with yamllint            |
| Multiple workflow runs | Remove duplicate workflow files            |
| "pod: not found" error | Use `npm ci --ignore-scripts`              |
| Jest ES module errors  | Add transformIgnorePatterns                |
| ESLint jest errors     | Add `/* eslint-env jest */`                |
| React lint warnings    | Use StyleSheet.create, move components out |

**🔗 Full Guide**: See `react-native-zero-to-production-guide.md` for complete
details
