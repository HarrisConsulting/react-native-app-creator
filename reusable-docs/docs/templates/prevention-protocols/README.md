# Prevention Protocols Templates

**Purpose**: Error prevention systems that eliminate common React Native development issues  
**Reusability**: 100% - Copy exactly to prevent known problems  
**Source Project**: ReactNativeTest (learned from solving 7+ major issues)  

---

## 🛡️ **CRITICAL PREVENTION PROTOCOLS**

### **🚨 Metro Directory Error Prevention**
**Source**: `start-metro.sh` + Metro safety documentation  
**Purpose**: Prevents Metro bundler directory confusion  
**Issue Prevented**: "Metro running from wrong directory" causing bundle failures  

**Template Script**:
```bash
#!/bin/bash
# Metro Safety Protocol - ReactNativeTest Pattern

PROJECT_NAME="YourProjectName"  # UPDATE THIS
PROJECT_DIR="/Users/username/Projects/$PROJECT_NAME"  # UPDATE PATH

echo "🔍 Metro Safety Protocol Starting..."
echo "📍 Target Project: $PROJECT_NAME"
echo "📁 Expected Directory: $PROJECT_DIR"

# Verify correct directory
if [ ! -f "$PROJECT_DIR/package.json" ]; then
    echo "❌ ERROR: Not in correct project directory"
    echo "🔄 Navigate to: cd $PROJECT_DIR"
    exit 1
fi

# Kill existing Metro processes
echo "🧹 Cleaning existing Metro processes..."
pkill -f metro || true

# Navigate to correct directory
cd "$PROJECT_DIR" || exit 1

# Verify we're in the right place
echo "✅ Current directory: $(pwd)"
echo "✅ Project files present: $(ls -la | grep -E "(package.json|index.js)" | wc -l) files"

# Start Metro with cache reset
echo "🚀 Starting Metro bundler..."
npx react-native start --reset-cache
```

**Package.json Scripts**:
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

**Critical Success Steps**:
1. Always verify project directory before starting Metro
2. Kill existing Metro processes to prevent conflicts
3. Test bundle endpoint before launching app
4. Use project scripts, not global Metro commands

---

### **🧪 Jest Configuration Prevention**
**Source**: `jest.config.js` + `jest.setup.js`  
**Purpose**: Prevents React Navigation ES module errors  
**Issue Prevented**: "Unexpected token 'export'" in test files  

**Complete Jest Setup**:
```javascript
// jest.config.js - Universal Prevention Pattern
module.exports = {
  preset: 'react-native',
  transformIgnorePatterns: [
    'node_modules/(?!(react-native|@react-native|@react-navigation|react-native-gesture-handler|react-native-screens|react-native-safe-area-context)/)',
  ],
  moduleFileExtensions: ['ts', 'tsx', 'js', 'jsx', 'json', 'node'],
  setupFiles: ['<rootDir>/jest.setup.js'],
  testEnvironment: 'node',
  collectCoverageFrom: [
    'src/**/*.{js,jsx,ts,tsx}',
    '!src/**/*.test.{js,jsx,ts,tsx}',
    '!src/**/index.{js,jsx,ts,tsx}',
  ],
};
```

```javascript
// jest.setup.js - Comprehensive Mocking Prevention
/* eslint-env jest */
import 'react-native-gesture-handler/jestSetup';

// ✅ CRITICAL: React Navigation mocking (prevents ES module errors)
jest.mock('@react-navigation/native', () => ({
  NavigationContainer: ({children}) => children,
  useNavigation: () => ({
    navigate: jest.fn(),
    goBack: jest.fn(),
    dispatch: jest.fn(),
  }),
  useRoute: () => ({
    params: {},
  }),
  useFocusEffect: jest.fn(),
}));

jest.mock('@react-navigation/bottom-tabs', () => ({
  createBottomTabNavigator: () => ({
    Navigator: ({children}) => children,
    Screen: ({children}) => children,
  }),
}));

// ✅ CRITICAL: AsyncStorage mocking (prevents storage errors)
jest.mock('@react-native-async-storage/async-storage', () => ({
  getItem: jest.fn(() => Promise.resolve(null)),
  setItem: jest.fn(() => Promise.resolve()),
  removeItem: jest.fn(() => Promise.resolve()),
  clear: jest.fn(() => Promise.resolve()),
}));

// Additional mocks as needed...
```

**Prevention Success Criteria**:
- Tests run without ES module errors
- React Navigation components are properly mocked
- AsyncStorage operations don't fail
- No "jest environment" ESLint errors

---

### **🔧 CI/CD Pipeline Prevention**
**Source**: `.github/workflows/ci-cd.yml`  
**Purpose**: Prevents immediate pipeline failures  
**Issues Prevented**: CocoaPods errors, YAML syntax issues, job conflicts  

**Critical Prevention Patterns**:
```yaml
name: "React Native CI/CD Pipeline"  # ✅ Unique name prevents conflicts

jobs:
  lint-and-typecheck:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
        with:
          node-version: "18.x"  # ✅ LTS version prevents compatibility issues
          cache: "npm"
      
      # ✅ CRITICAL: --ignore-scripts prevents CocoaPods failures
      - name: Install dependencies
        run: npm ci --ignore-scripts
      
      - name: Run ESLint
        run: npm run lint
      
      - name: Run TypeScript check
        run: npm run typecheck

  test:
    runs-on: ubuntu-latest
    needs: lint-and-typecheck  # ✅ Proper dependencies prevent race conditions
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
        with:
          node-version: "18.x"
          cache: "npm"
      
      # ✅ CRITICAL: Same --ignore-scripts pattern
      - name: Install dependencies
        run: npm ci --ignore-scripts
      
      - name: Run tests
        run: npm test -- --watchAll=false
```

**Prevention Checklist**:
- [ ] Unique workflow name (no duplicates)
- [ ] Node.js 18.x LTS specified
- [ ] `--ignore-scripts` flag on all npm ci commands
- [ ] Proper job dependencies defined
- [ ] No malformed YAML syntax

---

### **💻 VS Code Configuration Prevention**
**Source**: `.vscode/settings.json`  
**Purpose**: Prevents Deno language server conflicts  
**Issue Prevented**: "Client Deno Language Server: connection to server is erroring"  

**Critical VS Code Settings**:
```json
{
  "deno.enable": false,
  "typescript.preferences.includePackageJsonAutoImports": "on",
  "typescript.suggest.autoImports": true,
  "typescript.updateImportsOnFileMove.enabled": "always",
  "editor.codeActionsOnSave": {
    "source.fixAll.eslint": "explicit"
  },
  "eslint.workingDirectories": ["./"],
  "editor.formatOnSave": true,
  "editor.defaultFormatter": "esbenp.prettier-vscode",
  "[typescript]": {
    "editor.defaultFormatter": "esbenp.prettier-vscode"
  },
  "[typescriptreact]": {
    "editor.defaultFormatter": "esbenp.prettier-vscode"
  }
}
```

**Prevention Effect**:
- Deno conflicts eliminated completely
- TypeScript IntelliSense works correctly
- ESLint auto-fixes on save
- Prettier formatting consistency

---

### **📱 React Native Code Quality Prevention**
**Source**: Component patterns throughout ReactNativeTest  
**Purpose**: Prevents ESLint warnings and React issues  
**Issues Prevented**: react/no-unstable-nested-components, react-native/no-inline-styles  

**Component Definition Prevention**:
```typescript
// ✅ CORRECT: Define components outside render
const TabIcon = ({ focused, name }: { focused: boolean; name: string }) => {
  return <Text style={focused ? styles.focused : styles.unfocused}>{name}</Text>;
};

const renderTabIcon = ({ focused, route }: { focused: boolean; route: any }) => (
  <TabIcon focused={focused} name={route.name} />
);

const AppNavigator = () => {
  return (
    <Tab.Navigator
      screenOptions={({ route }) => ({
        tabBarIcon: ({ focused }) => renderTabIcon({ focused, route }),
      })}
    >
      {/* Navigation content */}
    </Tab.Navigator>
  );
};

// ❌ WRONG: Components inside render (causes warnings)
const AppNavigator = () => {
  const TabIcon = () => { /* This causes react/no-unstable-nested-components */ };
  return (/* ... */);
};
```

**StyleSheet Prevention**:
```typescript
// ✅ CORRECT: StyleSheet.create prevents warnings
const styles = StyleSheet.create({
  container: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
  },
  title: {
    fontSize: 24,
    fontWeight: 'bold',
  },
});

// ❌ WRONG: Inline styles (causes react-native/no-inline-styles)
<View style={{ flex: 1, justifyContent: 'center' }}>
```

---

### **🧹 Clean Build Prevention Protocol**
**Source**: Clean build documentation and scripts  
**Purpose**: Prevents iOS build cache corruption  
**Issue Prevented**: Mysterious build failures after major changes  

**Clean Build Script Template**:
```bash
#!/bin/bash
# Clean Build Prevention Protocol

echo "🧹 Starting Clean Build Protocol..."

# 1. Clean Xcode DerivedData (CRITICAL)
echo "1️⃣ Cleaning Xcode DerivedData..."
rm -rf ~/Library/Developer/Xcode/DerivedData

# 2. Navigate to iOS directory and clean
echo "2️⃣ Cleaning iOS build artifacts..."
cd ios
rm -rf build
xcodebuild clean -workspace ReactNativeTest.xcworkspace -scheme ReactNativeTest

# 3. Clean React Native caches
echo "3️⃣ Cleaning React Native caches..."
cd ..
npm run clean  # Select: metro, watchman (minimum)

# 4. Complete CocoaPods refresh
echo "4️⃣ Refreshing CocoaPods..."
cd ios
pod deintegrate
pod install

# 5. Fresh build
echo "5️⃣ Starting fresh build..."
cd ..
npm run ios

echo "✅ Clean Build Protocol Complete"
```

**When to Execute**:
- After authentication system modifications
- After navigation structure updates
- After significant dependency updates
- Before important testing or demo sessions

---

## 📋 **PREVENTION IMPLEMENTATION CHECKLIST**

### **Essential Prevention Setup (Copy These First)**
- [ ] Copy Metro safety script (`start-metro.sh`)
- [ ] Copy Jest configuration with proper mocking
- [ ] Copy VS Code settings to prevent Deno conflicts
- [ ] Copy CI/CD pipeline with `--ignore-scripts`
- [ ] Copy clean build protocol script

### **Code Quality Prevention (Apply These Patterns)**
- [ ] Use StyleSheet.create() for all component styling
- [ ] Define components outside render functions
- [ ] Import React Navigation components properly
- [ ] Set up ESLint with zero-warning configuration

### **Development Workflow Prevention**
- [ ] Always use safety scripts instead of global commands
- [ ] Test bundle endpoint before launching apps
- [ ] Execute clean build protocol after major changes
- [ ] Validate CI/CD pipeline triggers correctly

---

## 🎯 **PREVENTION SUCCESS METRICS**

Projects using these prevention protocols should achieve:

- ✅ **Zero Metro directory errors** from project start
- ✅ **100% CI/CD pipeline success rate** with proper configuration
- ✅ **Zero React Navigation test failures** with comprehensive mocking
- ✅ **Zero ESLint warnings** with proven code patterns
- ✅ **Elimination of 7+ common React Native issues**

---

**🛡️ These prevention protocols have been proven to eliminate the most time-consuming React Native development issues, saving hours of debugging for just minutes of upfront setup.**
