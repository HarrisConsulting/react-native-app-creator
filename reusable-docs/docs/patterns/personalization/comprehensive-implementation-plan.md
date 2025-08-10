# Preferred Name & Preferences System Implementation Plan

**Document Version**: 1.1  
**Created**: August 7, 2025  
**Updated**: August 7, 2025 - 🎉 **Phase 1 COMPLETE** - Core Infrastructure Deployed  
**Project**: ReactNativeTest  
**Status**: � **Phase 1 COMPLETE - Ready for Phase 2 UI Implementation**  
**Follows**: ReactNativeTest enterprise-grade patterns and zero-warning standards  

---

## **🎉 MILESTONE ACHIEVED: Phase 1 Complete**

**Date**: August 7, 2025  
**Achievement**: Core preference management infrastructure successfully implemented

### **✅ Completed Components**
- ✅ **Database Schema**: Supabase tables and functions deployed and tested
- ✅ **Authentication Service**: Preference management methods implemented  
- ✅ **Context Provider**: Real implementations replacing placeholders
- ✅ **Type System**: Enhanced TypeScript interfaces with game preferences
- ✅ **Quality Validation**: Zero TypeScript errors, zero ESLint warnings

### **🎯 Current Capabilities**
- Users can set and update preferred names via `updatePreferredName()`
- Complete preference management via `updateUserPreferences()`
- Server-side storage with JSONB flexibility for unlimited expansion
- Real-time state synchronization with automatic profile refresh

**📚 Complete Milestone Documentation**: `docs/authentication/phase-1-authentication-service-enhancement-complete.md`

---

## 🎯 **Executive Summary**

This document outlines the implementation of a comprehensive user preferences system, starting with a preferred name feature that allows users to personalize their experience. The implementation addresses **critical gaps in the existing preferences system** and provides a **future-proof foundation** for additional user customization options.

### **Key Objectives**
1. **Verify Supabase database state** before any implementation (MANDATORY)
2. **Implement preferred name feature** for personalized user experience
3. **Fix existing broken preferences** (Email Notifications, Remember Device)
4. **Create scalable preferences infrastructure** for future enhancements
5. **Maintain ReactNativeTest quality standards** (zero warnings, comprehensive testing)

---

## 🚨 **CRITICAL: Database Verification Requirement**

### **MANDATORY Phase 0: Database State Verification**

**🔍 BEFORE ANY IMPLEMENTATION**, verify Supabase database state:

```bash
# 1. Check current database structure
# File: supabase/check-current-database-state.sql
# Location: Supabase SQL Editor

# 2. Apply schema if needed
# File: supabase/cloud-migration-script.sql
# Location: Supabase SQL Editor

# 3. Verify all systems operational
# Expected: All verification queries show ✅ status
```

**📋 Required Verification Steps:**
1. ✅ Confirm `email_whitelist` table exists
2. ✅ Confirm `user_profiles` table exists
3. ✅ Verify `preferred_name` column present
4. ✅ Verify `preferences` JSONB column present
5. ✅ Confirm security functions available
6. ✅ Test Row Level Security policies

**❌ DO NOT PROCEED** without completing database verification.

**📚 Reference**: `docs/authentication/supabase-database-verification-guide.md`

---

## 🔍 **Current State Analysis**

### **Existing Preferences Implementation Issues**

#### **Current Broken Implementation**
```typescript
// From src/screens/auth/ProfileScreen.tsx
const [notificationsEnabled, setNotificationsEnabled] = useState(true);
const [rememberDevice, setRememberDevice] = useState(false);

// ❌ PROBLEMS:
// 1. No persistence - resets on app restart
// 2. No server storage - not saved anywhere
// 3. No local storage - not using AsyncStorage
// 4. UI-only feedback - no actual functionality
```

#### **Current Storage Architecture**
- ✅ **Authentication Data**: Uses AsyncStorage (`src/auth/storage.ts`) for tokens and email
- ✅ **User Profile Data**: Uses Supabase (`user_profiles` table) for basic profile info
- ❌ **Preferences**: **Only React state** - no persistence whatsoever

#### **Database Schema Current State**
```sql
-- Current user_profiles table (from supabase/schema.sql)
CREATE TABLE user_profiles (
  id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  email TEXT UNIQUE NOT NULL,
  status TEXT DEFAULT 'active' CHECK (status IN ('active', 'inactive')),
  last_login_at TIMESTAMP WITH TIME ZONE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);
-- ❌ Missing: preferred_name and preferences fields
```

---

## 🏗 **Proposed Solution Architecture**

### **Server-Side Storage Strategy (Recommended)**

**Rationale**: 
- Fixes existing preference persistence issues
- Provides cross-device synchronization
- Enables server-side preference validation
- Follows ReactNativeTest enterprise patterns
- Creates foundation for future features

### **Enhanced Database Schema**
```sql
-- Enhanced user_profiles table
ALTER TABLE user_profiles 
ADD COLUMN preferred_name TEXT,
ADD COLUMN preferences JSONB DEFAULT '{}';

-- Performance indexes
CREATE INDEX idx_user_profiles_preferred_name ON user_profiles(preferred_name);
CREATE INDEX idx_user_profiles_preferences ON user_profiles USING GIN (preferences);
```

### **Preferences Data Structure**
```json
{
  "notifications": {
    "email": true,
    "push": false
  },
  "device": {
    "rememberDevice": false,
    "sessionExtension": false
  },
  "gameTypes": ["Arcade", "Strategy", "RPG", "Puzzle"],
  "theme": "light",
  "accessibility": {
    "fontSize": "medium",
    "highContrast": false
  }
}
```

---

## 📋 **Implementation Phases**

## **Phase 0: Database Verification (MANDATORY - 30 minutes)**

### **0.1 Supabase Database State Check**

**🚨 CRITICAL STEP**: Verify database configuration before proceeding.

**Required Actions**:
1. **Run database state check**:
   - File: `supabase/check-current-database-state.sql`
   - Location: Supabase SQL Editor
   - Purpose: Verify existing table structure

2. **Apply schema if needed**:
   - File: `supabase/cloud-migration-script.sql` 
   - Location: Supabase SQL Editor
   - Purpose: Create complete database schema

3. **Verify setup success**:
   - All verification queries must show ✅ status
   - Document verification results
   - Confirm database matches TypeScript interfaces

**Expected Results**:
```
check_type        | result
Table Status      | ✅ Tables created successfully
Column Status     | ✅ Preference columns added successfully
Index Status      | ✅ Indexes created successfully  
Function Status   | ✅ Functions created successfully
RLS Status        | ✅ Row Level Security enabled
Whitelist Status  | ✅ Test emails added to whitelist
```

**🛡️ Quality Gate**: Do not proceed to Phase 1 without ✅ database verification.

**📚 Reference**: `docs/authentication/supabase-database-verification-guide.md`

---

## **Phase 1: TypeScript Interface Enhancement (1-2 hours)**

## **Phase 1: TypeScript Interface Enhancement (1-2 hours)**

### **1.1 Enhanced User Interface**

**File**: `src/auth/types.ts`

**TypeScript Updates**:
```typescript
export interface User {
    id: string;
    email: string;
    createdAt: Date;
    lastLoginAt: Date;
    isVerified: boolean;
    preferredName?: string;        // NEW: Optional preferred name
    preferences?: UserPreferences;  // NEW: Structured preferences
}

export interface UserPreferences {
    // Fixed: Current broken preferences with server persistence
    notifications?: {
        email: boolean;
        push: boolean;
    };
    device?: {
        rememberDevice: boolean;
        sessionExtension?: boolean;
    };
    
    // Future: Game selection preferences
    gameTypes?: GameType[];
    
    // Future: Theme and accessibility
    theme?: 'light' | 'dark';
    accessibility?: {
        fontSize: 'small' | 'medium' | 'large';
        highContrast: boolean;
    };
}

export type GameType = 'Arcade' | 'Strategy' | 'RPG' | 'Puzzle' | 'Action' | 'Sports';
```

---

## **Phase 2: Authentication Service Enhancement (2-3 hours)**
  
  // New game preferences (future expansion)
  gameTypes?: GameType[];
  theme?: 'light' | 'dark';
  
  // Accessibility (future expansion)
  accessibility?: {
    fontSize: 'small' | 'medium' | 'large';
    highContrast: boolean;
  };
}
```

---

## **Phase 2: TypeScript Interface Updates (1-2 hours)**

### **2.1 User Type Enhancement**

**File**: `src/auth/types.ts`

```typescript
export interface User {
  id: string;
  email: string;
  isVerified: boolean;
  createdAt: Date;
  lastLoginAt: Date;
  // NEW FIELDS
  preferredName?: string;
  preferences: UserPreferences;
}

export interface UserPreferences {
  notifications?: {
    email: boolean;
    push: boolean;
  };
  device?: {
    rememberDevice: boolean;
    sessionExtension: boolean;
  };
  gameTypes?: GameType[];
  theme?: 'light' | 'dark';
  accessibility?: {
    fontSize: 'small' | 'medium' | 'large';
    highContrast: boolean;
  };
}

export type GameType = 'Arcade' | 'Strategy' | 'RPG' | 'Puzzle' | 'Action' | 'Sports';
```

### **2.2 Navigation Type Updates**

**File**: `src/navigation/AppNavigator.tsx`

```typescript
export type AuthStackParamList = {
  Login: { returnTo?: string };
  Verification: { email: string; returnTo?: string };
  PreferredName: { email: string; isFirstTime: boolean }; // NEW SCREEN
  Profile: undefined;
  Game: undefined;
};
```

---

## **Phase 3: Authentication Service Enhancement (2-3 hours)**

### **3.1 Supabase Service Updates**

**File**: `src/auth/supabaseAuthService.ts`

**New Methods**:
```typescript
// Update user preferred name
static async updatePreferredName(preferredName: string): Promise<{success: boolean; error?: string}> {
  try {
    const session = await this.getCurrentSession();
    if (!session?.user) {
      return { success: false, error: 'No authenticated user' };
    }

    const { error } = await supabase.rpc('update_user_preferences', {
      user_id: session.user.id,
      new_preferred_name: preferredName.trim()
    });

    if (error) {
      return { success: false, error: error.message };
    }

    return { success: true };
  } catch (error) {
    return { success: false, error: 'Network error occurred' };
  }
}

// Update user preferences (fixes existing broken preferences)
static async updateUserPreferences(preferences: Partial<UserPreferences>): Promise<{success: boolean; error?: string}> {
  try {
    const session = await this.getCurrentSession();
    if (!session?.user) {
      return { success: false, error: 'No authenticated user' };
    }

    // Get current preferences first
    const { data: currentProfile } = await supabase
      .from('user_profiles')
      .select('preferences')
      .eq('id', session.user.id)
      .single();

    // Merge with new preferences
    const mergedPreferences = {
      ...currentProfile?.preferences || {},
      ...preferences
    };

    const { error } = await supabase.rpc('update_user_preferences', {
      user_id: session.user.id,
      new_preferences: mergedPreferences
    });

    if (error) {
      return { success: false, error: error.message };
    }

    return { success: true };
  } catch (error) {
    return { success: false, error: 'Network error occurred' };
  }
}

// Get user profile with preferences
static async getUserProfile(): Promise<{preferredName?: string; preferences: UserPreferences} | null> {
  try {
    const session = await this.getCurrentSession();
    if (!session?.user) {
      return null;
    }

    const { data, error } = await supabase
      .from('user_profiles')
      .select('preferred_name, preferences')
      .eq('id', session.user.id)
      .single();

    if (error || !data) {
      return null;
    }

    return {
      preferredName: data.preferred_name,
      preferences: data.preferences || {}
    };
  } catch (error) {
    console.error('Failed to get user profile:', error);
    return null;
  }
}
```

### **3.2 AuthContext Enhancement**

**File**: `src/auth/AuthContext.tsx`

```typescript
interface AuthContextType {
  // Existing fields...
  userProfile: {preferredName?: string; preferences: UserPreferences} | null;
  updatePreferredName: (name: string) => Promise<{success: boolean; error?: string}>;
  updateUserPreferences: (preferences: Partial<UserPreferences>) => Promise<{success: boolean; error?: string}>;
  refreshUserProfile: () => Promise<void>;
}
```

---

## **Phase 4: UI Implementation (4-5 hours)**

### **4.1 Preferred Name Setup Screen**

**File**: `src/screens/auth/PreferredNameScreen.tsx` (NEW)

**Features**:
- Professional text input with validation (max 30 characters)
- Real-time character count display
- Skip option for optional setup
- Loading states and error handling
- Consistent with existing authentication UI design

**Key Components**:
```typescript
const PreferredNameScreen = ({ navigation, route }) => {
  const [preferredName, setPreferredName] = useState('');
  const [isLoading, setIsLoading] = useState(false);
  const [error, setError] = useState('');
  
  const handleSave = async () => {
    if (preferredName.trim().length === 0) {
      setError('Please enter a preferred name');
      return;
    }
    
    setIsLoading(true);
    const result = await updatePreferredName(preferredName.trim());
    
    if (result.success) {
      navigation.navigate('Profile');
    } else {
      setError(result.error || 'Failed to save preferred name');
    }
    setIsLoading(false);
  };
  
  const handleSkip = () => {
    navigation.navigate('Profile');
  };
  
  // UI implementation with StyleSheet.create()...
};
```

### **4.2 Enhanced ProfileScreen**

**File**: `src/screens/auth/ProfileScreen.tsx` (MAJOR ENHANCEMENT)

**Fixes Existing Broken Preferences**:
```typescript
const ProfileScreen = ({ navigation }) => {
  const { user, userProfile, updateUserPreferences } = useAuth();
  const [isLoading, setIsLoading] = useState(false);
  
  // FIXED: Now using server-stored preferences instead of local state
  const preferences = userProfile?.preferences || {};
  
  const handleNotificationToggle = async (value: boolean) => {
    setIsLoading(true);
    const result = await updateUserPreferences({
      notifications: { ...preferences.notifications, email: value }
    });
    
    if (result.success) {
      Alert.alert('Notifications Updated', `Email notifications are now ${value ? 'enabled' : 'disabled'}.`);
      await refreshUserProfile(); // Refresh from server
    } else {
      Alert.alert('Error', result.error || 'Failed to update notification preference');
    }
    setIsLoading(false);
  };
  
  const handleRememberDeviceToggle = async (value: boolean) => {
    setIsLoading(true);
    const result = await updateUserPreferences({
      device: { ...preferences.device, rememberDevice: value }
    });
    
    if (result.success) {
      Alert.alert('Device Preference Updated', `Device remembering is now ${value ? 'enabled' : 'disabled'}.`);
      await refreshUserProfile();
    } else {
      Alert.alert('Error', result.error || 'Failed to update device preference');
    }
    setIsLoading(false);
  };
  
  // Enhanced UI with preferred name editing, loading states, etc.
};
```

### **4.3 Game Screen Personalization**

**File**: `src/screens/auth/GameScreen.tsx`

**Enhanced Welcome Message**:
```typescript
const GameScreen = ({ navigation }) => {
  const { user, userProfile } = useAuth();
  
  const welcomeMessage = userProfile?.preferredName 
    ? `Hello ${userProfile.preferredName}! Ready to play?`
    : `Hello ${user?.email?.split('@')[0] || 'Player'}! Ready to play?`;
    
  // Enhanced game UI with personalization...
};
```

### **4.4 Navigation Flow Integration**

**Updated Authentication Flow**:
```
Login → Verification → PreferredName (NEW - Optional) → Profile
                    ↓
               (Skip Option) → Profile
```

---

## **Phase 5: Testing Implementation (3-4 hours)**

### **5.1 Database Testing**

**File**: `__tests__/auth/preferredNameService.test.ts` (NEW)

**Test Coverage**:
```typescript
describe('PreferredNameService', () => {
  beforeEach(() => {
    jest.clearAllMocks();
  });

  describe('updatePreferredName', () => {
    test('updates preferred name successfully', async () => {
      // Test successful preferred name update
    });

    test('validates preferred name length', async () => {
      // Test validation (max 30 characters)
    });

    test('handles network errors gracefully', async () => {
      // Test error handling
    });
  });

  describe('updateUserPreferences', () => {
    test('merges preferences correctly', async () => {
      // Test JSONB preference merging
    });

    test('preserves existing preferences', async () => {
      // Test that updating one preference doesn't delete others
    });
  });
});
```

### **5.2 UI Component Testing**

**File**: `__tests__/auth/PreferredNameScreen.test.tsx` (NEW)

**Test Coverage**:
```typescript
describe('PreferredNameScreen', () => {
  test('renders preferred name input correctly', () => {
    // Test UI rendering
  });

  test('validates input and shows errors', async () => {
    // Test input validation
  });

  test('saves preferred name and navigates', async () => {
    // Test save functionality and navigation
  });

  test('skip functionality works correctly', () => {
    // Test skip button
  });
});
```

### **5.3 Enhanced ProfileScreen Testing**

**File**: `__tests__/auth/ProfileScreen.test.tsx` (ENHANCEMENT)

**Additional Test Coverage**:
```typescript
describe('ProfileScreen Enhanced Preferences', () => {
  test('loads preferences from server correctly', async () => {
    // Test server preference loading
  });

  test('updates preferences and persists to server', async () => {
    // Test preference updates with server persistence
  });

  test('handles preference update errors gracefully', async () => {
    // Test error handling for failed updates
  });

  test('shows loading states during preference updates', () => {
    // Test loading state UI
  });
});
```

---

## **Phase 6: Future-Proofing Implementation (2-3 hours)**

### **6.1 Game Type Preferences Foundation**

**File**: `src/screens/auth/GamePreferencesScreen.tsx` (NEW)

**Design Foundation**:
```typescript
const GamePreferencesScreen = () => {
  const { userProfile, updateUserPreferences } = useAuth();
  const [selectedGameTypes, setSelectedGameTypes] = useState<GameType[]>(
    userProfile?.preferences.gameTypes || []
  );

  const gameTypes: GameType[] = ['Arcade', 'Strategy', 'RPG', 'Puzzle', 'Action', 'Sports'];

  const handleGameTypeToggle = (gameType: GameType) => {
    const updated = selectedGameTypes.includes(gameType)
      ? selectedGameTypes.filter(type => type !== gameType)
      : [...selectedGameTypes, gameType];
    
    setSelectedGameTypes(updated);
  };

  const handleSave = async () => {
    const result = await updateUserPreferences({
      gameTypes: selectedGameTypes
    });
    
    if (result.success) {
      Alert.alert('Game Preferences Updated', 'Your game type preferences have been saved.');
      navigation.goBack();
    }
  };

  // Multi-select checkbox UI implementation...
};
```

### **6.2 Preferences Management System**

**File**: `src/components/PreferencesManager.tsx` (NEW)

**Reusable Component Design**:
```typescript
interface PreferencesManagerProps {
  category: 'notifications' | 'device' | 'gameTypes' | 'accessibility';
  preferences: UserPreferences;
  onUpdate: (preferences: Partial<UserPreferences>) => Promise<{success: boolean; error?: string}>;
}

const PreferencesManager: React.FC<PreferencesManagerProps> = ({
  category,
  preferences,
  onUpdate
}) => {
  // Modular preference category management
  // Consistent UI patterns for different preference types
  // Validation and error handling
  // Loading states and user feedback
};
```

---

## **📊 Implementation Timeline**

| Phase | Duration | Priority | Dependencies | Outcome | Status |
|-------|----------|----------|-------------|---------|--------|
| **Phase 0: Database Verification** | **30 min** | **Critical** | **None** | ✅ **Database schema confirmed** | **✅ COMPLETE** |
| **Phase 1: Service Enhancement** | **2-3 hours** | **Critical** | **Phase 0** | ✅ **Server preference management** | **✅ COMPLETE** |
| Phase 2: TypeScript Updates | 1-2 hours | Critical | Phase 1 | ✅ Type safety for preferences | ⏳ Ready |
| Phase 3: UI Implementation | 4-5 hours | Critical | Phase 1-2 | ✅ Complete user experience | ⏳ Ready |
| Phase 4: Testing | 3-4 hours | Critical | Phase 1-3 | ✅ Quality assurance | ⏳ Ready |
| Phase 5: Future-Proofing | 2-3 hours | High | Phase 1-4 | ✅ Scalable foundation | ⏳ Ready |
| **Phase 6: Game Preferences** | **5-6 hours** | **Medium** | **Phase 1-5** | ✅ **Complete game preference system** | ⏳ **Ready** |

**Phase 1 Completed**: 3 hours ✅  
**Remaining Estimated Time**: 18-25 hours  
**Critical Path**: 9-14 hours (Phases 2-4)  
**Enhanced Features**: 7-9 hours (Phases 5-6)

---

## **Phase 7: Game Preferences System (5-6 hours)**

### **7.1 Game Preference Categories Implementation**

**Purpose**: Enable users to select their favorite games across multiple categories for personalized game recommendations and content.

**Database Schema Updates**:
```sql
-- Extend user_profiles.preferences JSONB structure
-- No schema changes needed - JSONB supports the new structure
```

**Enhanced TypeScript Interfaces** (already implemented):
```typescript
// Comprehensive Game Preferences System
export interface GamePreferences {
    strategyBoardGames?: StrategyBoardGame[];
    puzzleGames?: PuzzleGame[];
    arcadeGames?: ArcadeGame[];
    actionGames?: ActionGame[];
    sportsGames?: SportsGame[];
    skillLevel?: SkillLevel;
    preferredSessionLength?: SessionLength;
    competitiveMode?: boolean;
}

export type StrategyBoardGame = 'Chess' | 'Checkers' | 'Backgammon' | 'Go' | 'Othello' | 'Shogi';
export type PuzzleGame = 'Tetris' | 'Rubik\'s Cube' | 'Sudoku' | 'Crossword' | 'Jigsaw' | 'Word Search';
export type ArcadeGame = 'Pac-Man' | 'Space Invaders' | 'Donkey Kong' | 'Frogger' | 'Asteroids' | 'Centipede';
export type ActionGame = 'Call of Duty' | 'God of War' | 'Street Fighter' | 'Mortal Kombat' | 'Tekken' | 'Doom';
export type SportsGame = 'Soccer' | 'Golf' | 'Tennis' | 'Basketball' | 'Baseball' | 'Football';

export type SkillLevel = 'Beginner' | 'Intermediate' | 'Advanced' | 'Expert';
export type SessionLength = '5-15 minutes' | '15-30 minutes' | '30-60 minutes' | '1+ hours';
```

### **7.2 Game Preferences UI Implementation**

**File**: `src/screens/GamePreferencesScreen.tsx`

**Screen Features**:
```typescript
const GamePreferencesScreen = () => {
  const { user, userProfile, updateUserPreferences } = useAuth();
  const [gamePreferences, setGamePreferences] = useState<GamePreferences>(
    userProfile?.preferences?.gamePreferences || {}
  );
  const [isLoading, setIsLoading] = useState(false);

  // Category-based game selection with expandable sections
  const renderGameCategory = (
    title: string,
    games: readonly string[],
    selectedGames: string[],
    onSelectionChange: (games: string[]) => void
  ) => {
    return (
      <View style={styles.categoryContainer}>
        <Text style={styles.categoryTitle}>{title}</Text>
        <View style={styles.gameGrid}>
          {games.map((game) => (
            <TouchableOpacity
              key={game}
              style={[
                styles.gameButton,
                selectedGames.includes(game) && styles.gameButtonSelected
              ]}
              onPress={() => toggleGameSelection(game, selectedGames, onSelectionChange)}
            >
              <Text style={[
                styles.gameButtonText,
                selectedGames.includes(game) && styles.gameButtonTextSelected
              ]}>
                {game}
              </Text>
            </TouchableOpacity>
          ))}
        </View>
      </View>
    );
  };

  const handleSavePreferences = async () => {
    setIsLoading(true);
    const result = await updateUserPreferences({
      gamePreferences
    });
    
    if (result.success) {
      Alert.alert('Success', 'Your game preferences have been saved!');
    } else {
      Alert.alert('Error', result.error || 'Failed to save preferences');
    }
    setIsLoading(false);
  };

  return (
    <ScrollView style={styles.container}>
      <Text style={styles.title}>Choose Your Favorite Games</Text>
      <Text style={styles.subtitle}>Select games you enjoy playing to get personalized recommendations</Text>

      {renderGameCategory(
        'Strategy Board Games',
        ['Chess', 'Checkers', 'Backgammon', 'Go', 'Othello', 'Shogi'],
        gamePreferences.strategyBoardGames || [],
        (games) => setGamePreferences(prev => ({ ...prev, strategyBoardGames: games as StrategyBoardGame[] }))
      )}

      {renderGameCategory(
        'Puzzle Games',
        ['Tetris', 'Rubik\'s Cube', 'Sudoku', 'Crossword', 'Jigsaw', 'Word Search'],
        gamePreferences.puzzleGames || [],
        (games) => setGamePreferences(prev => ({ ...prev, puzzleGames: games as PuzzleGame[] }))
      )}

      {renderGameCategory(
        'Arcade Games',
        ['Pac-Man', 'Space Invaders', 'Donkey Kong', 'Frogger', 'Asteroids', 'Centipede'],
        gamePreferences.arcadeGames || [],
        (games) => setGamePreferences(prev => ({ ...prev, arcadeGames: games as ArcadeGame[] }))
      )}

      {renderGameCategory(
        'Action Games',
        ['Call of Duty', 'God of War', 'Street Fighter', 'Mortal Kombat', 'Tekken', 'Doom'],
        gamePreferences.actionGames || [],
        (games) => setGamePreferences(prev => ({ ...prev, actionGames: games as ActionGame[] }))
      )}

      {renderGameCategory(
        'Sports Games',
        ['Soccer', 'Golf', 'Tennis', 'Basketball', 'Baseball', 'Football'],
        gamePreferences.sportsGames || [],
        (games) => setGamePreferences(prev => ({ ...prev, sportsGames: games as SportsGame[] }))
      )}

      {/* Additional Preferences */}
      <View style={styles.additionalPreferences}>
        <Text style={styles.sectionTitle}>Gaming Preferences</Text>
        
        {/* Skill Level Picker */}
        <View style={styles.preferenceRow}>
          <Text style={styles.preferenceLabel}>Skill Level:</Text>
          <Picker
            selectedValue={gamePreferences.skillLevel || 'Intermediate'}
            onValueChange={(value) => 
              setGamePreferences(prev => ({ ...prev, skillLevel: value as SkillLevel }))
            }
            style={styles.picker}
          >
            <Picker.Item label="Beginner" value="Beginner" />
            <Picker.Item label="Intermediate" value="Intermediate" />
            <Picker.Item label="Advanced" value="Advanced" />
            <Picker.Item label="Expert" value="Expert" />
          </Picker>
        </View>

        {/* Session Length Picker */}
        <View style={styles.preferenceRow}>
          <Text style={styles.preferenceLabel}>Preferred Session Length:</Text>
          <Picker
            selectedValue={gamePreferences.preferredSessionLength || '15-30 minutes'}
            onValueChange={(value) => 
              setGamePreferences(prev => ({ ...prev, preferredSessionLength: value as SessionLength }))
            }
            style={styles.picker}
          >
            <Picker.Item label="Quick (5-15 min)" value="5-15 minutes" />
            <Picker.Item label="Normal (15-30 min)" value="15-30 minutes" />
            <Picker.Item label="Long (30-60 min)" value="30-60 minutes" />
            <Picker.Item label="Extended (1+ hours)" value="1+ hours" />
          </Picker>
        </View>

        {/* Competitive Mode Switch */}
        <View style={styles.preferenceRow}>
          <Text style={styles.preferenceLabel}>Competitive Mode:</Text>
          <Switch
            value={gamePreferences.competitiveMode || false}
            onValueChange={(value) => 
              setGamePreferences(prev => ({ ...prev, competitiveMode: value }))
            }
            trackColor={{ false: '#767577', true: '#81b0ff' }}
            thumbColor={gamePreferences.competitiveMode ? '#007AFF' : '#f4f3f4'}
          />
        </View>
      </View>

      <TouchableOpacity
        style={[styles.saveButton, isLoading && styles.saveButtonDisabled]}
        onPress={handleSavePreferences}
        disabled={isLoading}
      >
        <Text style={styles.saveButtonText}>
          {isLoading ? 'Saving...' : 'Save Game Preferences'}
        </Text>
      </TouchableOpacity>
    </ScrollView>
  );
};
```

### **7.3 Game Preference Integration**

**Home Screen Enhancement**:
```typescript
// Display personalized game recommendations based on preferences
const HomeScreen = () => {
  const { userProfile } = useAuth();
  const gamePreferences = userProfile?.preferences?.gamePreferences;

  const getPersonalizedRecommendations = (): string[] => {
    if (!gamePreferences) return ['Try our featured games!'];

    const recommendations = [];
    
    if (gamePreferences.strategyBoardGames?.length) {
      recommendations.push(`Strategy lover? Try ${gamePreferences.strategyBoardGames[0]}!`);
    }
    
    if (gamePreferences.puzzleGames?.length) {
      recommendations.push(`${gamePreferences.puzzleGames[0]} challenges await!`);
    }
    
    if (gamePreferences.skillLevel === 'Expert') {
      recommendations.push('Expert mode games available!');
    }
    
    return recommendations.length ? recommendations : ['Discover new games based on your preferences!'];
  };

  return (
    <View style={styles.container}>
      {/* Existing content */}
      
      <View style={styles.gameRecommendations}>
        <Text style={styles.recommendationsTitle}>Recommended for You</Text>
        {getPersonalizedRecommendations().map((recommendation, index) => (
          <Text key={index} style={styles.recommendationText}>• {recommendation}</Text>
        ))}
      </View>
    </View>
  );
};
```

**Profile Screen Updates**:
```typescript
// Add game preferences summary and edit navigation
const ProfileScreen = () => {
  const { userProfile } = useAuth();
  const navigation = useNavigation();
  
  const getGamePreferencesSummary = (): string => {
    const prefs = userProfile?.preferences?.gamePreferences;
    if (!prefs) return 'No game preferences set';
    
    const totalGames = [
      ...(prefs.strategyBoardGames || []),
      ...(prefs.puzzleGames || []),
      ...(prefs.arcadeGames || []),
      ...(prefs.actionGames || []),
      ...(prefs.sportsGames || [])
    ].length;
    
    return `${totalGames} favorite games selected`;
  };

  return (
    <ScrollView style={styles.container}>
      {/* Existing profile content */}
      
      <TouchableOpacity
        style={styles.preferenceButton}
        onPress={() => navigation.navigate('GamePreferences' as never)}
      >
        <Text style={styles.preferenceButtonTitle}>Game Preferences</Text>
        <Text style={styles.preferenceButtonSubtitle}>{getGamePreferencesSummary()}</Text>
        <Text style={styles.preferenceButtonArrow}>></Text>
      </TouchableOpacity>
    </ScrollView>
  );
};
```

### **7.4 Navigation Integration**

**Add to Navigation Stack**:
```typescript
// src/navigation/AppNavigator.tsx
import GamePreferencesScreen from '../screens/GamePreferencesScreen';

const AuthStack = createStackNavigator();

const AuthStackNavigator = () => {
  return (
    <AuthStack.Navigator>
      {/* Existing screens */}
      <AuthStack.Screen 
        name="GamePreferences" 
        component={GamePreferencesScreen}
        options={{ title: 'Game Preferences' }}
      />
    </AuthStack.Navigator>
  );
};
```

### **7.5 Testing Implementation**

**Game Preferences Tests**:
```typescript
// __tests__/screens/GamePreferencesScreen.test.tsx
describe('GamePreferencesScreen', () => {
  test('renders all game categories correctly', () => {
    // Test category rendering
  });

  test('handles game selection toggling', () => {
    // Test game selection logic
  });

  test('saves preferences successfully', async () => {
    // Test preference saving
  });

  test('displays skill level and session preferences', () => {
    // Test additional preference controls
  });
});

// __tests__/auth/gamePreferences.test.ts
describe('Game Preferences Service', () => {
  test('merges game preferences correctly', async () => {
    // Test JSONB merging for game preferences
  });

  test('validates game preference data structure', () => {
    // Test data validation
  });
});
```

### **7.6 Quality Validation**

**Phase 7 Validation Checklist**:
- ✅ All game categories render correctly with proper selection states
- ✅ Multi-selection works for each game category independently  
- ✅ Skill level and session length preferences save correctly
- ✅ Competitive mode toggle functions properly
- ✅ Game preferences persist across app restarts
- ✅ Personalized recommendations display based on selected games
- ✅ Navigation between profile and game preferences works smoothly
- ✅ Loading states and error handling implemented
- ✅ TypeScript compilation passes with zero errors
- ✅ ESLint passes with zero warnings
- ✅ Comprehensive test coverage for all game preference functionality

**Estimated Time**: 5-6 hours  
**Dependencies**: Phases 1-6 (preferred name and core preferences system)  
**Priority**: Medium (enhancement after core functionality)

---

## **🎯 Success Criteria**

### **Immediate Success (Phases 1-5)**
- ✅ Users can set and edit preferred names
- ✅ **FIXED**: Email notification preferences persist across app restarts
- ✅ **FIXED**: Remember device preferences persist across app restarts
- ✅ Game screen displays personalized welcome messages
- ✅ All preferences stored securely in Supabase
- ✅ Comprehensive test coverage (>85%)
- ✅ Zero ESLint warnings maintained
- ✅ Clean build validation passes

### **Long-term Success (Phase 6-7)**
- ✅ Foundation ready for game type preferences (Phase 6)
- ✅ **NEW**: Complete game preferences system (Phase 7)
- ✅ **NEW**: Multi-category game selection (Strategy, Puzzle, Arcade, Action, Sports)
- ✅ **NEW**: Skill level and session length preferences
- ✅ **NEW**: Personalized game recommendations based on user preferences
- ✅ Scalable preference management system
- ✅ JSONB structure supports complex preference queries
- ✅ Reusable components for future preference categories

---

## **🛡 Risk Mitigation**

### **Technical Risks**
1. **Database Migration**: Test schema changes in development environment first
2. **Breaking Changes**: Maintain backward compatibility with existing `user_profiles` data
3. **Performance**: Implement proper indexing for JSONB queries
4. **Data Integrity**: Validate preference data structure on both client and server

### **User Experience Risks**
1. **Migration Path**: Existing users won't lose functionality during update
2. **Progressive Enhancement**: Preferred name is optional to avoid authentication friction
3. **Fallback Handling**: App works correctly even if preferences fail to load
4. **Loading States**: Clear feedback during preference updates

---

## **🔄 Migration Strategy**

### **Existing User Handling**
```sql
-- Safe migration for existing users
UPDATE user_profiles 
SET preferences = '{
  "notifications": {"email": true, "push": false},
  "device": {"rememberDevice": false}
}'::jsonb 
WHERE preferences IS NULL OR preferences = '{}'::jsonb;
```

### **Rollback Plan**
```sql
-- Emergency rollback capability
ALTER TABLE user_profiles 
DROP COLUMN IF EXISTS preferred_name,
DROP COLUMN IF EXISTS preferences;
```

---

## **📚 Implementation Standards**

### **Code Quality Requirements**
- ✅ Follow ReactNativeTest enterprise patterns
- ✅ Maintain zero ESLint warnings
- ✅ Use StyleSheet.create() for all styling
- ✅ Implement comprehensive error handling
- ✅ Add loading states for all async operations
- ✅ Follow TypeScript strict mode compliance

### **Testing Requirements**
- ✅ Minimum 85% test coverage for new code
- ✅ Unit tests for all service methods
- ✅ Component tests for all UI screens
- ✅ Integration tests for complete user flows
- ✅ Database operation tests with proper mocking

### **Documentation Requirements**
- ✅ Update authentication flow documentation
- ✅ Create preference management API documentation
- ✅ Document database schema changes
- ✅ Update troubleshooting guides

---

## **🎉 Expected Outcomes**

### **User Experience Improvements**
1. **Personalized Experience**: Users see their preferred name in the Game screen
2. **Persistent Preferences**: Settings saved across app sessions (fixes current broken behavior)
3. **Professional UX**: Smooth preference management with proper feedback
4. **Game Preferences System**: Multi-category game selection with personalized recommendations
5. **Intelligent Recommendations**: Content suggestions based on skill level and preferred session length
6. **Comprehensive Gaming Profile**: Complete user gaming preferences including competitive mode settings

### **Technical Improvements**
1. **Scalable Architecture**: JSONB-based preference system supports unlimited expansion
2. **Performance Optimized**: Proper indexing for fast preference queries
3. **Enterprise-Grade**: Server-side storage with proper validation and security
4. **Zero Regression**: Fixes existing broken preferences while adding new functionality
5. **Type-Safe Game System**: Complete TypeScript coverage for all game preference categories
6. **Modular Component Design**: Reusable game preference components for future expansion

### **Development Benefits**
1. **Maintainable Code**: Reusable preference management components
2. **Type Safety**: Complete TypeScript coverage for all preference operations
3. **Test Coverage**: Comprehensive testing infrastructure for preferences
4. **Documentation**: Clear patterns for future preference implementations
5. **Extensible Game Categories**: Easy addition of new game types and preference options
6. **Personalization Engine**: Foundation for advanced recommendation algorithms

---

**This implementation plan provides a complete solution that not only adds the requested preferred name feature but also fixes the existing broken preferences system and creates a comprehensive game preferences platform. The 7-phase approach delivers both immediate user personalization (preferred names) and advanced gaming customization (multi-category game preferences with intelligent recommendations) while maintaining enterprise-grade code quality and scalability.**
