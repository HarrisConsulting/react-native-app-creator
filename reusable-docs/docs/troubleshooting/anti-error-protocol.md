# React Native Project Creation - Anti-Error Protocol

**Purpose**: Prevent Metro bundler directory resolution errors from the very
first build\
**Created**: August 4, 2025\
**Based on**: ReactNativeTest project learnings

## 🚨 Critical Error Prevention Protocol

### Root Cause Analysis

The Metro bundler directory error
(`Unable to resolve module ./index from /Users/rogerharris/Projects/.`) occurs
because:

1. **Global Metro Commands**: Using `npx metro start` from any directory can
   resolve to wrong project context
2. **Working Directory Confusion**: Terminal working directory doesn't always
   match Metro's resolution context
3. **CLI Command Inconsistency**: Different React Native CLI commands have
   different directory behaviors
4. **Cache Pollution**: Metro cache can retain wrong directory paths between
   sessions

### 🛡️ Prevention Measures - Apply from FIRST BUILD

## Phase 1: Project Creation (Immediate)

### 1.1 Create Project with Proper Structure

```bash
# ALWAYS create from parent directory
cd /Users/rogerharris/Projects
npx @react-native-community/cli@latest init YourProjectName --skip-install
cd YourProjectName
```

### 1.2 Immediately Create Metro Protocol Script

**Create this file BEFORE first build**: `start-metro.sh`

```bash
#!/bin/bash
# Metro Start Protocol - Created at project initialization
PROJECT_DIR="/Users/rogerharris/Projects/YourProjectName"

echo "🚀 Starting Metro from correct project directory..."
echo "📁 Project Directory: $PROJECT_DIR"

# Force correct directory
cd "$PROJECT_DIR" || exit 1

# Verify project structure
echo "📍 Current Directory: $(pwd)"
echo "✅ Verifying index.js exists: $(ls -la index.js 2>/dev/null || echo 'NOT FOUND')"

# Clean slate approach
echo "🔄 Stopping any existing Metro processes..."
pkill -f metro 2>/dev/null || true

# Start Metro with project context
echo "▶️ Starting Metro with cache reset..."
npm start -- --reset-cache
```

### 1.3 Make Script Executable Immediately

```bash
chmod +x start-metro.sh
```

## Phase 2: First Dependency Installation

### 2.1 Install Dependencies from Correct Directory

```bash
# Verify you're in project directory
pwd  # Should show /Users/rogerharris/Projects/YourProjectName

# Install dependencies
npm install
cd ios && pod install && cd ..
```

### 2.2 Create Directory Verification Function

Add to your shell profile (`.zshrc` or `.bash_profile`):

```bash
# React Native Project Directory Verifier
verify_rn_project() {
    if [[ ! -f "package.json" ]] || [[ ! -f "index.js" ]] || [[ ! -d "ios" ]]; then
        echo "❌ ERROR: Not in React Native project root directory"
        echo "📍 Current: $(pwd)"
        echo "📋 Expected files: package.json, index.js, ios/"
        return 1
    fi
    echo "✅ Confirmed React Native project directory: $(pwd)"
    return 0
}
```

## Phase 3: First Build Protocol

### 3.1 Pre-Build Directory Verification

**ALWAYS run before first build**:

```bash
# 1. Verify project directory
verify_rn_project

# 2. Check Metro is not running elsewhere
ps aux | grep metro | grep -v grep

# 3. If Metro is running, kill it
pkill -f metro

# 4. Start Metro from project directory
./start-metro.sh
```

### 3.2 First Build Commands (New Terminal)

```bash
# Open new terminal, navigate to project
cd /Users/rogerharris/Projects/YourProjectName

# Verify directory again
verify_rn_project

# Build and run
npx react-native run-ios --simulator="iPhone 16 Pro"
```

## Phase 4: Error Detection at First Sign

### 4.1 Immediate Red Flags to Watch For

**During Metro Start**:

- ❌ Metro starts but shows wrong directory in logs
- ❌ Bundle test fails:
  `curl -s "http://localhost:8081/index.bundle?platform=ios" | head -2`
- ❌ Metro shows "Unable to resolve module" errors

**During App Launch**:

- ❌ Red error screen: "No script URL provided"
- ❌ White/blank screen after splash
- ❌ App launches but immediately shows Metro connection errors

### 4.2 Immediate Response Protocol

**If ANY red flag appears**:

```bash
# 1. STOP everything immediately
pkill -f metro
pkill -f "react-native"

# 2. Verify your location
pwd
ls -la index.js package.json  # These MUST exist

# 3. Clean restart protocol
cd /Users/rogerharris/Projects/YourProjectName  # Use FULL path
./start-metro.sh

# 4. Test bundle immediately
curl -s "http://localhost:8081/index.bundle?platform=ios" | head -2
# Should return JavaScript, NOT error messages

# 5. Only then launch app
npx react-native run-ios --simulator="iPhone 16 Pro"
```

## Phase 5: Project Template with Built-in Safeguards

### 5.1 Enhanced package.json Scripts

Add these scripts to `package.json` immediately after project creation:

```json
{
    "scripts": {
        "start": "react-native start",
        "start-safe": "./start-metro.sh",
        "verify-project": "pwd && ls -la index.js package.json ios/",
        "test-bundle": "curl -s 'http://localhost:8081/index.bundle?platform=ios' | head -2",
        "clean-start": "pkill -f metro || true && ./start-metro.sh",
        "ios-safe": "npm run verify-project && npx react-native run-ios"
    }
}
```

### 5.2 Create Project README with Protocol

**Create immediately**: `METRO_PROTOCOL.md`

```markdown
# Metro Start Protocol for [ProjectName]

## ⚠️ CRITICAL: Always follow this sequence

1. **Verify Directory**: `npm run verify-project`
2. **Start Metro Safely**: `npm run start-safe`
3. **Test Bundle**: `npm run test-bundle`
4. **Launch App**: `npm run ios-safe`

## 🚨 If You See Errors

- Red error screen → Metro directory issue
- White screen → Bundle not loading
- "No script URL" → Metro not running from correct directory

**Solution**: `npm run clean-start` then `npm run ios-safe`
```

## Phase 6: Long-term Prevention

### 6.1 Shell Aliases for Safety

Add to `.zshrc`:

```bash
# React Native Safe Commands
alias rn-start='./start-metro.sh'
alias rn-verify='verify_rn_project'
alias rn-clean='pkill -f metro || true && ./start-metro.sh'
alias rn-ios='npm run verify-project && npx react-native run-ios'
```

### 6.2 VS Code Tasks Configuration

Create `.vscode/tasks.json`:

```json
{
    "version": "2.0.0",
    "tasks": [
        {
            "label": "Start Metro Safely",
            "type": "shell",
            "command": "./start-metro.sh",
            "group": "build",
            "presentation": {
                "echo": true,
                "reveal": "always",
                "focus": false,
                "panel": "new"
            },
            "problemMatcher": []
        },
        {
            "label": "Verify Project Directory",
            "type": "shell",
            "command": "pwd && ls -la index.js package.json ios/",
            "group": "test"
        }
    ]
}
```

## Summary: Prevention Checklist for New Projects

### ✅ Immediate Actions (First 5 minutes)

- [ ] Create project in correct parent directory
- [ ] Create `start-metro.sh` script immediately
- [ ] Make script executable
- [ ] Add safety scripts to `package.json`
- [ ] Create `METRO_PROTOCOL.md`

### ✅ Before First Build

- [ ] Run directory verification
- [ ] Kill any existing Metro processes
- [ ] Start Metro using safety script
- [ ] Test bundle endpoint
- [ ] Only then launch app

### ✅ Long-term Setup

- [ ] Add shell aliases for safe commands
- [ ] Create VS Code tasks
- [ ] Document project-specific protocols
- [ ] Train team on Metro directory awareness

## Key Principle

**Never trust working directory assumptions**. Always explicitly verify and set
the correct project directory before starting Metro or running builds.

This protocol ensures Metro directory errors are caught and prevented from the
very first build, eliminating the circular debugging that occurred in
ReactNativeTest.
