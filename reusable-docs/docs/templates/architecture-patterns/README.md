# Architecture Patterns Templates

**Purpose**: Proven architectural approaches for React Native projects  
**Reusability**: 90% - Adapt structure, customize content  
**Source Project**: ReactNativeTest  

---

## 🏛️ **ARCHITECTURAL TEMPLATES**

### **🧭 Navigation Structure Template**
**Source**: `src/navigation/AppNavigator.tsx`  
**Purpose**: Zero-warning navigation with authentication integration  
**Reusability**: High - Adapt screen names and routes  

**Proven Features**:
- ✅ Zero ESLint warnings with StyleSheet.create() patterns
- ✅ Conditional navigation based on authentication state
- ✅ Type-safe navigation with TypeScript
- ✅ Bottom tab navigation with proper icon handling
- ✅ Stack navigation for modal flows

**Template Structure**:
```typescript
// Authentication-aware navigation
const AppNavigator = () => {
  const { user } = useAuth();
  
  return (
    <NavigationContainer>
      {user ? <AuthenticatedStack /> : <UnauthenticatedStack />}
    </NavigationContainer>
  );
};

// Tab navigation with proper styling
const TabNavigator = () => (
  <Tab.Navigator
    screenOptions={({ route }) => ({
      tabBarIcon: ({ focused }) => renderTabIcon({ focused, route }),
      tabBarStyle: styles.tabBar,
    })}
  >
    {/* Screens */}
  </Tab.Navigator>
);
```

**Customization for New Projects**:
- Replace screen components with your app's screens
- Update tab names and icons
- Adjust authentication logic for your auth provider
- Modify styling to match your design system

---

### **🔐 Authentication System Template**
**Source**: `src/auth/` directory  
**Purpose**: Complete authentication infrastructure  
**Reusability**: High for Supabase, Adaptable for other providers  

**Complete System Architecture**:
```typescript
// Context Provider Pattern
interface AuthContextType {
  user: User | null;
  userProfile: UserProfile | null;
  login: (email: string) => Promise<AuthResult>;
  logout: () => Promise<void>;
  updateUserProfile: (updates: Partial<UserProfile>) => Promise<AuthResult>;
}

// Service Layer Pattern
class AuthService {
  async authenticateWithOTP(email: string): Promise<AuthResult> {
    // Implementation for your auth provider
  }
  
  async verifyOTP(email: string, token: string): Promise<AuthResult> {
    // Implementation for your auth provider
  }
}

// Secure Storage Pattern
class AuthStorage {
  async storeSession(session: AuthSession): Promise<void> {
    // Secure token storage
  }
  
  async getStoredSession(): Promise<AuthSession | null> {
    // Retrieve stored session
  }
}
```

**Template Files**:
- `AuthContext.tsx` - React Context with TypeScript
- `authService.ts` - Core authentication logic
- `storage.ts` - Secure storage management
- `hooks.ts` - Custom authentication hooks
- `types.ts` - TypeScript interface definitions
- `utils.ts` - Authentication utilities

**Adaptation for Different Providers**:
- **Firebase**: Replace Supabase calls with Firebase Auth
- **AWS Cognito**: Adapt service methods for Cognito SDK
- **Custom Backend**: Implement REST API calls
- **OAuth**: Add OAuth provider integrations

---

### **🛠️ Service Layer Template**
**Source**: `src/services/` directory  
**Purpose**: Clean separation of concerns for backend integration  
**Reusability**: Universal - Adaptable to any backend  

**Service Architecture Pattern**:
```typescript
// Environment Configuration
export class Environment {
  static get apiUrl(): string {
    return process.env.API_URL || 'http://localhost:3000';
  }
  
  static get supabaseUrl(): string {
    return process.env.SUPABASE_URL || '';
  }
}

// Debug Utilities
export class DebugUtils {
  static logApiCall(method: string, url: string, data?: any): void {
    if (__DEV__) {
      console.log(`[API] ${method} ${url}`, data);
    }
  }
}

// Network Utilities
export class NetworkUtils {
  static async handleApiResponse<T>(response: Response): Promise<T> {
    if (!response.ok) {
      throw new Error(`API Error: ${response.status}`);
    }
    return response.json();
  }
}
```

**Template Files**:
- `environment.ts` - Environment variable management
- `debugUtils.ts` - Development debugging utilities
- `networkUtils.ts` - Network utility functions
- Backend-specific service files (supabase.ts, firebase.ts, etc.)

**Customization Approach**:
- Replace backend service implementations
- Maintain the utility patterns (debug, network, environment)
- Add new service files for your specific backend needs

---

### **📱 Screen Structure Template**
**Source**: `src/screens/` directory  
**Purpose**: Consistent screen patterns with zero warnings  
**Reusability**: High - Template structure, replace content  

**Screen Template Pattern**:
```typescript
import React, { useState } from 'react';
import { View, Text, StyleSheet, Alert } from 'react-native';
import { useNavigation } from '@react-navigation/native';

const TemplateScreen = () => {
  const navigation = useNavigation();
  const [localState, setLocalState] = useState(false);

  const handleAction = () => {
    Alert.alert('Action', 'Template action triggered');
  };

  return (
    <View style={styles.container}>
      <Text style={styles.title}>Screen Title</Text>
      {/* Screen content */}
    </View>
  );
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
    padding: 20,
    backgroundColor: '#fff',
  },
  title: {
    fontSize: 24,
    fontWeight: 'bold',
    marginBottom: 20,
  },
});

export default TemplateScreen;
```

**Proven Patterns**:
- ✅ StyleSheet.create() for zero warnings
- ✅ Consistent import organization
- ✅ Local state management with hooks
- ✅ Navigation integration
- ✅ Error handling with Alert

**Screen Categories**:
- **Home Screens**: Feature overview with interactive elements
- **Settings Screens**: Switch components with real functionality
- **About Screens**: Information display with platform detection
- **Authentication Screens**: Form handling with validation

---

### **🎨 Component Organization Template**
**Source**: UI patterns throughout the project  
**Purpose**: Consistent component structure and styling  
**Reusability**: Universal - Apply to any React Native component  

**Component Template**:
```typescript
import React from 'react';
import { View, Text, TouchableOpacity, StyleSheet } from 'react-native';

interface ComponentProps {
  title: string;
  onPress?: () => void;
  disabled?: boolean;
}

const TemplateComponent: React.FC<ComponentProps> = ({ 
  title, 
  onPress, 
  disabled = false 
}) => {
  return (
    <TouchableOpacity
      style={[styles.container, disabled && styles.disabled]}
      onPress={onPress}
      disabled={disabled}
    >
      <Text style={styles.title}>{title}</Text>
    </TouchableOpacity>
  );
};

const styles = StyleSheet.create({
  container: {
    padding: 15,
    backgroundColor: '#007AFF',
    borderRadius: 8,
    alignItems: 'center',
  },
  disabled: {
    backgroundColor: '#ccc',
  },
  title: {
    color: '#fff',
    fontSize: 16,
    fontWeight: '600',
  },
});

export default TemplateComponent;
```

**Organization Principles**:
- ✅ TypeScript interfaces for all props
- ✅ Default prop values
- ✅ Conditional styling
- ✅ Accessibility considerations
- ✅ Consistent naming conventions

---

## 📋 **IMPLEMENTATION GUIDE**

### **Phase 1: Copy Architecture Foundation**
1. **Navigation Structure**: Copy AppNavigator pattern, update screens
2. **Authentication System**: Copy complete auth directory, adapt provider
3. **Service Layer**: Copy service patterns, update backend integration
4. **Screen Templates**: Copy screen structure, replace content

### **Phase 2: Customize for Your Project**
1. **Update TypeScript Interfaces**: Match your data models
2. **Replace Service Implementations**: Connect to your backend
3. **Customize Navigation Routes**: Add your app's screens
4. **Apply Your Design System**: Update styling and branding

### **Phase 3: Validate Architecture**
1. **Test Navigation Flows**: Ensure all routes work correctly
2. **Validate Authentication**: Test complete auth workflows
3. **Check Service Integration**: Verify backend connectivity
4. **Run Quality Checks**: Ensure zero warnings and errors

---

## 🎯 **ADAPTATION STRATEGIES**

### **For Different Tech Stacks**
- **Redux**: Replace Context with Redux store patterns
- **GraphQL**: Adapt service layer for GraphQL queries
- **Different UI Libraries**: Maintain component structure, update styling
- **State Management**: Keep component patterns, update state logic

### **For Different App Types**
- **E-commerce**: Adapt authentication for user accounts and payments
- **Social Media**: Add social authentication and profile management
- **Enterprise**: Include role-based access control
- **Gaming**: Add game-specific state management

---

**🏗️ These architectural patterns provide proven foundations that have been validated in production, offering enterprise-grade structure while remaining flexible for customization.**
