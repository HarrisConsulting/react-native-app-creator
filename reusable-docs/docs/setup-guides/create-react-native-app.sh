#!/bin/bash

# React Native Project Creator with Navigation
# Auto-generates a complete React Native app with basic navigation
# Based on ReactNativeTest successful implementation

set -e  # Exit on any error

echo "🚀 React Native App Creator with Navigation"
echo "============================================"

# Get project details
read -p "Enter your app name (no spaces): " APP_NAME
read -p "Enter your bundle ID (e.g., com.company.appname): " BUNDLE_ID
read -p "Enter parent directory [/Users/$USER/Projects]: " PARENT_DIR
PARENT_DIR=${PARENT_DIR:-"/Users/$USER/Projects"}

echo ""
echo "Creating app with:"
echo "  Name: $APP_NAME"
echo "  Bundle ID: $BUNDLE_ID"
echo "  Location: $PARENT_DIR/$APP_NAME"
echo ""
read -p "Continue? (y/N): " CONFIRM

if [[ ! $CONFIRM =~ ^[Yy]$ ]]; then
    echo "Cancelled."
    exit 0
fi

# Setup
PROJECT_PATH="$PARENT_DIR/$APP_NAME"
echo "📁 Working in: $PROJECT_PATH"

# Phase 1: Create project
echo ""
echo "🔨 Phase 1: Creating React Native project..."
cd "$PARENT_DIR"
npx @react-native-community/cli@latest init "$APP_NAME" --skip-install
cd "$APP_NAME"

# Phase 2: Create Metro safety script
echo ""
echo "🛡️ Phase 2: Creating Metro safety script..."
cat > start-metro.sh << EOF
#!/bin/bash

# Metro Start Protocol for $APP_NAME
# This script ensures Metro ALWAYS starts from the correct project directory

PROJECT_DIR="$PROJECT_PATH"

echo "🚀 Starting Metro from correct project directory..."
echo "📁 Project Directory: \$PROJECT_DIR"

# Change to project directory
cd "\$PROJECT_DIR" || exit 1

# Verify we're in the right place
echo "📍 Current Directory: \$(pwd)"
echo "✅ Verifying index.js exists: \$(ls -la index.js 2>/dev/null || echo 'NOT FOUND')"

# Kill any existing Metro processes
echo "🔄 Stopping any existing Metro processes..."
pkill -f metro 2>/dev/null || true

# Start Metro with cache reset
echo "▶️ Starting Metro with cache reset..."
npm start -- --reset-cache
EOF

chmod +x start-metro.sh

# Add safety scripts to package.json
npm pkg set scripts.start-safe="./start-metro.sh"
npm pkg set scripts.test-bundle="curl -s 'http://localhost:8081/index.bundle?platform=ios' | head -2"

# Phase 3: Configure development environment
echo ""
echo "⚙️ Phase 3: Configuring development environment..."
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

# Phase 4: Install dependencies
echo ""
echo "📦 Phase 4: Installing dependencies..."
npm install
npm install @react-navigation/native @react-navigation/bottom-tabs react-native-screens react-native-safe-area-context react-native-gesture-handler

# iOS pod install
echo ""
echo "🍎 Installing iOS pods..."
cd ios
pod install
cd ..

# Phase 5: Create navigation structure
echo ""
echo "🧭 Phase 5: Creating navigation structure..."
mkdir -p src/navigation
mkdir -p src/screens

# Create AppNavigator
cat > src/navigation/AppNavigator.tsx << 'EOF'
import React from 'react';
import { NavigationContainer } from '@react-navigation/native';
import { createBottomTabNavigator } from '@react-navigation/bottom-tabs';
import { Text } from 'react-native';

// Import screens
import HomeScreen from '../screens/HomeScreen';
import SettingsScreen from '../screens/SettingsScreen';
import AboutScreen from '../screens/AboutScreen';

// Tab navigator type
export type TabParamList = {
  Home: undefined;
  Settings: undefined;
  About: undefined;
};

const Tab = createBottomTabNavigator<TabParamList>();

const TabIcon = ({ focused, name }: { focused: boolean; name: string }) => {
  const getIcon = (iconName: string) => {
    switch (iconName) {
      case 'Home':
        return '🏠';
      case 'Settings':
        return '⚙️';
      case 'About':
        return 'ℹ️';
      default:
        return '📱';
    }
  };

  return (
    <Text style={{ fontSize: 20, opacity: focused ? 1 : 0.5 }}>
      {getIcon(name)}
    </Text>
  );
};

const AppNavigator = () => {
  return (
    <NavigationContainer>
      <Tab.Navigator
        screenOptions={({ route }) => ({
          tabBarIcon: ({ focused }) => (
            <TabIcon focused={focused} name={route.name} />
          ),
          tabBarActiveTintColor: '#007AFF',
          tabBarInactiveTintColor: '#999',
          tabBarStyle: {
            backgroundColor: 'white',
            borderTopWidth: 1,
            borderTopColor: '#E5E5E5',
            paddingTop: 5,
            paddingBottom: 5,
            height: 60,
          },
          tabBarLabelStyle: {
            fontSize: 12,
            fontWeight: '600',
          },
          headerStyle: {
            backgroundColor: '#007AFF',
          },
          headerTintColor: 'white',
          headerTitleStyle: {
            fontWeight: 'bold',
            fontSize: 18,
          },
        })}>
        <Tab.Screen
          name="Home"
          component={HomeScreen}
          options={{
            title: 'APP_NAME_PLACEHOLDER',
            headerStyle: {
              backgroundColor: '#007AFF',
            },
          }}
        />
        <Tab.Screen
          name="Settings"
          component={SettingsScreen}
          options={{
            title: 'Settings',
            headerStyle: {
              backgroundColor: '#34C759',
            },
          }}
        />
        <Tab.Screen
          name="About"
          component={AboutScreen}
          options={{
            title: 'About',
            headerStyle: {
              backgroundColor: '#FF3B30',
            },
          }}
        />
      </Tab.Navigator>
    </NavigationContainer>
  );
};

export default AppNavigator;
EOF

# Replace APP_NAME_PLACEHOLDER with actual app name
sed -i '' "s/APP_NAME_PLACEHOLDER/$APP_NAME/g" src/navigation/AppNavigator.tsx

# Create HomeScreen
cat > src/screens/HomeScreen.tsx << 'EOF'
import React from 'react';
import {
  View,
  Text,
  StyleSheet,
  ScrollView,
  TouchableOpacity,
  Alert,
} from 'react-native';

const HomeScreen = () => {
  const handleFeaturePress = (feature: string) => {
    Alert.alert('Feature Demo', `You tapped: ${feature}`);
  };

  return (
    <ScrollView style={styles.container}>
      <View style={styles.header}>
        <Text style={styles.title}>APP_NAME_PLACEHOLDER</Text>
        <Text style={styles.subtitle}>React Native App with Navigation</Text>
      </View>

      <View style={styles.section}>
        <Text style={styles.sectionTitle}>✅ App Features</Text>
        <View style={styles.featureGrid}>
          <TouchableOpacity
            style={styles.featureCard}
            onPress={() => handleFeaturePress('React Navigation')}>
            <Text style={styles.featureIcon}>🧭</Text>
            <Text style={styles.featureTitle}>Navigation</Text>
            <Text style={styles.featureDesc}>Multi-screen navigation</Text>
          </TouchableOpacity>

          <TouchableOpacity
            style={styles.featureCard}
            onPress={() => handleFeaturePress('TypeScript')}>
            <Text style={styles.featureIcon}>📘</Text>
            <Text style={styles.featureTitle}>TypeScript</Text>
            <Text style={styles.featureDesc}>Type-safe development</Text>
          </TouchableOpacity>

          <TouchableOpacity
            style={styles.featureCard}
            onPress={() => handleFeaturePress('iOS Build')}>
            <Text style={styles.featureIcon}>📱</Text>
            <Text style={styles.featureTitle}>iOS Ready</Text>
            <Text style={styles.featureDesc}>Configured for iOS</Text>
          </TouchableOpacity>

          <TouchableOpacity
            style={styles.featureCard}
            onPress={() => handleFeaturePress('Metro Safety')}>
            <Text style={styles.featureIcon}>🛡️</Text>
            <Text style={styles.featureTitle}>Metro Safety</Text>
            <Text style={styles.featureDesc}>Error prevention system</Text>
          </TouchableOpacity>
        </View>
      </View>

      <View style={styles.section}>
        <Text style={styles.sectionTitle}>🚀 Quick Actions</Text>
        <TouchableOpacity
          style={styles.actionButton}
          onPress={() => handleFeaturePress('Test Features')}>
          <Text style={styles.actionButtonText}>Test Features</Text>
        </TouchableOpacity>
      </View>

      <View style={styles.footer}>
        <Text style={styles.footerText}>
          Created: CREATION_DATE_PLACEHOLDER{'\n'}
          React Native with Navigation
        </Text>
      </View>
    </ScrollView>
  );
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: '#f8f9fa',
  },
  header: {
    backgroundColor: '#007AFF',
    padding: 30,
    alignItems: 'center',
  },
  title: {
    fontSize: 28,
    fontWeight: 'bold',
    color: 'white',
    marginBottom: 8,
  },
  subtitle: {
    fontSize: 16,
    color: '#E3F2FD',
    textAlign: 'center',
  },
  section: {
    padding: 20,
  },
  sectionTitle: {
    fontSize: 20,
    fontWeight: '600',
    color: '#333',
    marginBottom: 15,
  },
  featureGrid: {
    flexDirection: 'row',
    flexWrap: 'wrap',
    justifyContent: 'space-between',
  },
  featureCard: {
    backgroundColor: 'white',
    borderRadius: 12,
    padding: 16,
    width: '48%',
    marginBottom: 12,
    alignItems: 'center',
    shadowColor: '#000',
    shadowOffset: {
      width: 0,
      height: 2,
    },
    shadowOpacity: 0.1,
    shadowRadius: 3.84,
    elevation: 5,
  },
  featureIcon: {
    fontSize: 32,
    marginBottom: 8,
  },
  featureTitle: {
    fontSize: 16,
    fontWeight: '600',
    color: '#333',
    marginBottom: 4,
  },
  featureDesc: {
    fontSize: 12,
    color: '#666',
    textAlign: 'center',
  },
  actionButton: {
    backgroundColor: '#007AFF',
    borderRadius: 8,
    padding: 16,
    marginBottom: 12,
    alignItems: 'center',
  },
  actionButtonText: {
    color: 'white',
    fontSize: 16,
    fontWeight: '600',
  },
  footer: {
    padding: 20,
    alignItems: 'center',
    backgroundColor: '#f0f0f0',
    marginTop: 20,
  },
  footerText: {
    fontSize: 12,
    color: '#666',
    textAlign: 'center',
  },
});

export default HomeScreen;
EOF

# Replace placeholders in HomeScreen
sed -i '' "s/APP_NAME_PLACEHOLDER/$APP_NAME/g" src/screens/HomeScreen.tsx
sed -i '' "s/CREATION_DATE_PLACEHOLDER/$(date '+%B %d, %Y')/g" src/screens/HomeScreen.tsx

# Create SettingsScreen (basic template)
cat > src/screens/SettingsScreen.tsx << 'EOF'
import React from 'react';
import {
  View,
  Text,
  StyleSheet,
  ScrollView,
  TouchableOpacity,
  Alert,
} from 'react-native';

const SettingsScreen = () => {
  const handleSettingPress = (setting: string) => {
    Alert.alert('Settings', `Configure: ${setting}`);
  };

  return (
    <ScrollView style={styles.container}>
      <View style={styles.header}>
        <Text style={styles.title}>Settings</Text>
        <Text style={styles.subtitle}>Configure your app preferences</Text>
      </View>

      <View style={styles.section}>
        <Text style={styles.sectionTitle}>⚙️ App Settings</Text>
        
        <TouchableOpacity
          style={styles.settingItem}
          onPress={() => handleSettingPress('Notifications')}>
          <View style={styles.settingContent}>
            <Text style={styles.settingTitle}>Notifications</Text>
            <Text style={styles.settingDesc}>Manage app notifications</Text>
          </View>
          <Text style={styles.settingValue}>ON</Text>
        </TouchableOpacity>

        <TouchableOpacity
          style={styles.settingItem}
          onPress={() => handleSettingPress('Theme')}>
          <View style={styles.settingContent}>
            <Text style={styles.settingTitle}>Theme</Text>
            <Text style={styles.settingDesc}>Choose app appearance</Text>
          </View>
          <Text style={styles.settingValue}>LIGHT</Text>
        </TouchableOpacity>
      </View>
    </ScrollView>
  );
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: '#f8f9fa',
  },
  header: {
    backgroundColor: '#34C759',
    padding: 30,
    alignItems: 'center',
  },
  title: {
    fontSize: 28,
    fontWeight: 'bold',
    color: 'white',
    marginBottom: 8,
  },
  subtitle: {
    fontSize: 16,
    color: '#E8F5E8',
    textAlign: 'center',
  },
  section: {
    padding: 20,
  },
  sectionTitle: {
    fontSize: 20,
    fontWeight: '600',
    color: '#333',
    marginBottom: 15,
  },
  settingItem: {
    backgroundColor: 'white',
    borderRadius: 12,
    padding: 16,
    marginBottom: 12,
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'space-between',
    shadowColor: '#000',
    shadowOffset: {
      width: 0,
      height: 1,
    },
    shadowOpacity: 0.1,
    shadowRadius: 2,
    elevation: 2,
  },
  settingContent: {
    flex: 1,
  },
  settingTitle: {
    fontSize: 16,
    fontWeight: '600',
    color: '#333',
    marginBottom: 4,
  },
  settingDesc: {
    fontSize: 14,
    color: '#666',
  },
  settingValue: {
    fontSize: 14,
    fontWeight: '600',
    color: '#34C759',
  },
});

export default SettingsScreen;
EOF

# Create AboutScreen (basic template)
cat > src/screens/AboutScreen.tsx << 'EOF'
import React from 'react';
import {
  View,
  Text,
  StyleSheet,
  ScrollView,
  TouchableOpacity,
  Alert,
} from 'react-native';

const AboutScreen = () => {
  const handleInfoPress = (info: string) => {
    Alert.alert('Information', `Details about: ${info}`);
  };

  return (
    <ScrollView style={styles.container}>
      <View style={styles.header}>
        <Text style={styles.title}>About</Text>
        <Text style={styles.subtitle}>App Information</Text>
      </View>

      <View style={styles.section}>
        <Text style={styles.sectionTitle}>📱 App Details</Text>
        
        <View style={styles.infoCard}>
          <Text style={styles.infoLabel}>App Name</Text>
          <Text style={styles.infoValue}>APP_NAME_PLACEHOLDER</Text>
        </View>

        <View style={styles.infoCard}>
          <Text style={styles.infoLabel}>Version</Text>
          <Text style={styles.infoValue}>1.0.0</Text>
        </View>

        <View style={styles.infoCard}>
          <Text style={styles.infoLabel}>React Native</Text>
          <Text style={styles.infoValue}>0.80.2</Text>
        </View>

        <View style={styles.infoCard}>
          <Text style={styles.infoLabel}>Created</Text>
          <Text style={styles.infoValue}>CREATION_DATE_PLACEHOLDER</Text>
        </View>
      </View>

      <View style={styles.section}>
        <TouchableOpacity
          style={styles.actionButton}
          onPress={() => handleInfoPress('Documentation')}>
          <Text style={styles.actionButtonText}>View Documentation</Text>
        </TouchableOpacity>
      </View>
    </ScrollView>
  );
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: '#f8f9fa',
  },
  header: {
    backgroundColor: '#FF3B30',
    padding: 30,
    alignItems: 'center',
  },
  title: {
    fontSize: 28,
    fontWeight: 'bold',
    color: 'white',
    marginBottom: 8,
  },
  subtitle: {
    fontSize: 16,
    color: '#FFE5E5',
    textAlign: 'center',
  },
  section: {
    padding: 20,
  },
  sectionTitle: {
    fontSize: 20,
    fontWeight: '600',
    color: '#333',
    marginBottom: 15,
  },
  infoCard: {
    backgroundColor: 'white',
    borderRadius: 12,
    padding: 16,
    marginBottom: 12,
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    shadowColor: '#000',
    shadowOffset: {
      width: 0,
      height: 1,
    },
    shadowOpacity: 0.1,
    shadowRadius: 2,
    elevation: 2,
  },
  infoLabel: {
    fontSize: 16,
    fontWeight: '600',
    color: '#333',
  },
  infoValue: {
    fontSize: 16,
    color: '#666',
  },
  actionButton: {
    backgroundColor: '#FF3B30',
    borderRadius: 8,
    padding: 16,
    alignItems: 'center',
  },
  actionButtonText: {
    color: 'white',
    fontSize: 16,
    fontWeight: '600',
  },
});

export default AboutScreen;
EOF

# Replace placeholders in AboutScreen
sed -i '' "s/APP_NAME_PLACEHOLDER/$APP_NAME/g" src/screens/AboutScreen.tsx
sed -i '' "s/CREATION_DATE_PLACEHOLDER/$(date '+%B %d, %Y')/g" src/screens/AboutScreen.tsx

# Phase 6: Update App.tsx
echo ""
echo "📱 Phase 6: Updating App.tsx..."
cat > App.tsx << EOF
/**
 * $APP_NAME App
 * Created: $(date '+%B %d, %Y')
 * Features: Navigation, TypeScript, Metro error prevention
 *
 * @format
 */

import React from 'react';
import { StatusBar, useColorScheme } from 'react-native';
import AppNavigator from './src/navigation/AppNavigator';

function App() {
  const isDarkMode = useColorScheme() === 'dark';

  return (
    <>
      <StatusBar barStyle={isDarkMode ? 'light-content' : 'dark-content'} />
      <AppNavigator />
    </>
  );
}

export default App;
EOF

# Phase 6b: Update index.js for proper navigation setup
echo ""
echo "🔧 Phase 6b: Updating index.js for navigation..."
cat > index.js << 'EOF'
/**
 * @format
 */

import 'react-native-gesture-handler'; // Must be at the top
import { AppRegistry } from 'react-native';
import App from './App';
import { name as appName } from './app.json';

// Enable screens native optimization
import { enableScreens } from 'react-native-screens';
enableScreens();

AppRegistry.registerComponent(appName, () => App);
EOF

# Phase 7: Create documentation
echo ""
echo "📚 Phase 7: Creating documentation..."
mkdir -p docs

cat > docs/README.md << EOF
# $APP_NAME - Project Documentation

**Created**: $(date '+%B %d, %Y')  
**React Native**: 0.80.2  
**Bundle ID**: $BUNDLE_ID  

## Quick Start

\`\`\`bash
# Start Metro safely
./start-metro.sh

# Test bundle (in another terminal)
npm run test-bundle

# Build iOS
npx react-native run-ios
\`\`\`

## Project Structure

- **Navigation**: \`src/navigation/AppNavigator.tsx\`
- **Screens**: \`src/screens/[Home|Settings|About]Screen.tsx\`
- **Metro Safety**: \`start-metro.sh\`

## Bundle ID Configuration

Remember to update the bundle ID in Xcode:
1. Open \`ios/$APP_NAME.xcworkspace\`
2. Select project target
3. Change Bundle Identifier to: \`$BUNDLE_ID\`
4. Select development team

## Features

- ✅ Bottom tab navigation
- ✅ TypeScript support
- ✅ Metro error prevention
- ✅ iOS ready configuration

EOF

# Final success message
echo ""
echo "🎉 SUCCESS! React Native app created:"
echo ""
echo "📁 Location: $PROJECT_PATH"
echo "📱 App Name: $APP_NAME"
echo "🆔 Bundle ID: $BUNDLE_ID"
echo ""
echo "🚀 Next Steps:"
echo "1. cd $PROJECT_PATH"
echo "2. ./start-metro.sh"
echo "3. npm run test-bundle (should return JavaScript)"
echo "4. npx react-native run-ios"
echo ""
echo "📋 Don't forget to configure bundle ID in Xcode!"
echo "   Open: ios/$APP_NAME.xcworkspace"
echo ""
echo "✅ Your React Native app with navigation is ready!"
