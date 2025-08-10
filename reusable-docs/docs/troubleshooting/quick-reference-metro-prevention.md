# Quick Reference: React Native Metro Error Prevention

**For immediate use when creating new projects**

## 🔥 Critical First Actions (Do IMMEDIATELY after `npx init`)

### 1. Create Metro Safety Script (30 seconds)

```bash
cat > start-metro.sh << 'EOF'
#!/bin/bash
PROJECT_DIR="$(pwd)"
echo "🚀 Metro starting from: $PROJECT_DIR"
cd "$PROJECT_DIR" || exit 1
echo "✅ Index.js exists: $(ls index.js 2>/dev/null || echo 'MISSING')"
pkill -f metro 2>/dev/null || true
npm start -- --reset-cache
EOF
chmod +x start-metro.sh
```

### 2. Add Safety Commands (15 seconds)

```bash
npm pkg set scripts.start-safe="./start-metro.sh"
npm pkg set scripts.test-bundle="curl -s 'http://localhost:8081/index.bundle?platform=ios' | head -2"
```

## 🚨 Critical Tests (Before Every Build)

### Test 1: Directory Verification

```bash
pwd && ls index.js  # Must succeed
```

### Test 2: Metro Bundle Test (MOST IMPORTANT)

```bash
# After starting Metro:
npm run test-bundle
```

**✅ Success**: Returns JavaScript code\
**❌ Failure**: Returns error message → STOP, restart Metro

### Test 3: Metro Process Check

```bash
ps aux | grep metro  # Should show YOUR project path
```

## ⚡ Emergency Fix Protocol

If you see Metro errors or red error screen:

```bash
pkill -f metro
cd /full/path/to/your/project  # Use COMPLETE path
./start-metro.sh
npm run test-bundle  # MUST pass
# Only then launch app
```

## 🎯 Golden Rules

1. **ALWAYS** verify `npm run test-bundle` returns JavaScript before launching
   app
2. **NEVER** use global `metro` commands - always use project scripts
3. **IMMEDIATELY** create safety script after project creation
4. **STOP EVERYTHING** if bundle test fails - fix Metro first

## ✅ Success Indicators

- Bundle test returns: `var __BUNDLE_START_TIME__=...`
- Metro logs show your project directory path
- App displays React Native welcome screen (not red error)

---

**This prevents the Metro directory resolution errors that cause "Unable to
resolve module ./index" and "No script URL provided" failures.**
