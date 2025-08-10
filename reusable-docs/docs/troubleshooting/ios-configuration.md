# iOS Configuration Guide - ReactNativeTest

## Quick Setup Summary

### Your Apple Developer Account Status ✅

- **Team**: "The New School, Inc." (TLN4X39D5X)
- **Certificates**:
  - 2x Development certificates (Roger Harris)
  - 1x iOS Distribution certificate (The New School, Inc.)
- **Registered Device**: "Hands Off my iPhone" (00008130-000A03583C98001C)
- **Bundle ID Target**: `org.montessoricenter.reactnativetest`

### What You Need to Do

1. **Change Bundle ID in Xcode** (see detailed steps below)
2. **Select "The New School, Inc." as Team**
3. **Keep "Automatically manage signing" checked**
4. **Skip manual creation of**: Provisioning Profiles, Keys, Services

### What Xcode Will Handle Automatically

- ✅ Create provisioning profiles including your registered device
- ✅ Select appropriate certificates for Debug/Release builds
- ✅ Register bundle ID when first building/uploading

---

## Bundle Identifier Configuration

### Current Status

- **Default Bundle ID**: `org.reactjs.native.example.ReactNativeTest`
- **Status**: ⚠️ Needs to be changed for production
- **File Location**: `ios/ReactNativeTest.xcodeproj/project.pbxproj`

### Why This Matters

- Required for App Store submissions
- Needed for push notifications
- Required for proper app identification
- Must be unique across the App Store
- Used for app signing and provisioning profiles

### Recommended Bundle ID Format

**For this project**: `org.montessoricenter.reactnativetest`

General format examples:

```
com.yourcompany.reactnativetest
```

or

```
com.yourdomain.appname
```

### How to Change Bundle Identifier

#### Method 1: Using Xcode (Recommended)

1. Open `ios/ReactNativeTest.xcodeproj` in Xcode
2. Select the ReactNativeTest project in the navigator
3. Select the ReactNativeTest target
4. Go to "General" tab
5. **IMPORTANT**: There are 2 Bundle Identifier fields - update BOTH:
   - **Top field**: Change from
     `org.reactjs.native.example.$(PRODUCT_NAME:rfc1034identifier)` to
     `org.montessoricenter.reactnativetest`
   - **Bottom field (iOS section)**: Change from
     `org.reactjs.native.example.ReactNativeTest` to
     `org.montessoricenter.reactnativetest`
   - **Note**: If "Automatically manage signing" is checked, entering the Bundle
     ID into the **Top field** will automatically update the **Bottom field**
6. Xcode will automatically update both Debug and Release configurations

#### Method 2: Manual Edit (Advanced)

1. Open `ios/ReactNativeTest.xcodeproj/project.pbxproj`
2. Find lines containing `PRODUCT_BUNDLE_IDENTIFIER`
3. Replace `org.reactjs.native.example.$(PRODUCT_NAME:rfc1034identifier)` with
   `org.montessoricenter.reactnativetest`
4. Make sure to update both Debug and Release configurations

#### Method 3: Using sed command

```bash
cd ios
sed -i '' 's/org.reactjs.native.example.$(PRODUCT_NAME:rfc1034identifier)/org.montessoricenter.reactnativetest/g' ReactNativeTest.xcodeproj/project.pbxproj
```

### Certificate Usage in Your Project

#### Available Certificates

Based on your Apple Developer account, you have:

1. **Development Certificates** (2 available)
   - **Purpose**: For testing on physical devices during development
   - **When Used**: Debug builds, running on connected iOS devices
   - **Automatic Selection**: Xcode will pick an available development
     certificate

2. **iOS Distribution Certificate** (The New School, Inc.)
   - **Purpose**: For App Store submissions and TestFlight uploads
   - **When Used**: Release builds, archive/upload to App Store Connect
   - **Team**: Associated with "The New School, Inc." team

#### How Xcode Uses These Certificates

**For Development (Debug builds):**

- Xcode will automatically use one of your development certificates
- Allows you to test on your iPhone/iPad
- Used when running `npx react-native run-ios` on a physical device

**For Distribution (Release builds):**

- Xcode will use the distribution certificate from "The New School, Inc."
- Required for TestFlight beta testing
- Required for App Store submission

#### Recommended Setup for Your Project

1. **Enable Automatic Signing** (Recommended)
   - In Xcode: Check "Automatically manage signing"
   - Xcode will handle certificate selection automatically
   - Uses development certs for debug, distribution cert for release

2. **Manual Signing** (Advanced)
   - Uncheck "Automatically manage signing"
   - Manually select certificates for Debug/Release configurations
   - More control but requires more setup

#### Team Selection

Since your bundle ID will be `org.montessoricenter.reactnativetest`, you should:

- Set the **Team** to "The New School, Inc." (matches your distribution
  certificate)
- This ensures consistency for App Store submissions

#### Registered Device Usage

Your registered device "Hands Off my iPhone" will be automatically used:

- **No manual configuration needed** - Xcode handles this automatically
- **Provisioning profiles** will include your device when created
- **Testing on device**: Connect your iPhone and select it as build destination
  in Xcode

#### How to Test on Your Registered Device

1. **Connect your iPhone** to your Mac via USB
2. **Trust the computer** when prompted on your iPhone
3. **In Xcode**: Select your iPhone from the device dropdown (next to the scheme
   selector)
4. **Build and run**: Press the "Play" button or use `Cmd+R`
5. **First time**: Xcode will create provisioning profile automatically
   including your device

#### Troubleshooting Device Issues

- **Device not appearing in Xcode**: Check USB connection, trust computer
- **Provisioning errors**: Ensure device is registered (✅ already done)
- **"Device not in team"**: Verify team selection matches your Apple Developer
  account

### Keys and Services Management

#### What Are Keys and Services?

**Keys** are used for server-to-server authentication with Apple services:

- **APNs (Push Notifications)** - Send push notifications from your server
- **DeviceCheck** - Verify device authenticity
- **App Store Connect API** - Automate App Store operations
- **MapKit JS** - Use Apple Maps in web applications

**Services** shown in your dashboard:

- **Sign in with Apple for Email Communication**
- **Account & Organizational Data Sharing**

#### Do You Need These for React Native? **Not initially!**

**For a basic React Native app**: ❌ Skip these for now

- **Keys**: Only needed if you plan server-side push notifications or API
  automation
- **Services**: Only needed for specific Apple ID integration features

#### When You MIGHT Need Keys (Future Features)

1. **Push Notifications with Custom Server**:
   - Create an **APNs Key** if you want to send push notifications from your own
     server
   - Alternative: Use Firebase Cloud Messaging (simpler setup)

2. **App Store Connect API**:
   - Automate app uploads, metadata updates
   - Useful for CI/CD pipelines

3. **DeviceCheck**:
   - Prevent fraud, verify device authenticity
   - Advanced security feature

#### When You MIGHT Need Services

1. **Sign in with Apple for Email Communication**:
   - If you want users to sign in with their Apple ID
   - Required if you offer other social login options

2. **Account & Organizational Data Sharing**:
   - Share Apple ID information with your app
   - Advanced user account integration

#### Recommended Action for ReactNativeTest

**Skip Keys and Services for now** because:

- ✅ Your basic React Native app doesn't need them
- ✅ You can add them later when you need specific features
- ✅ Focus on getting the basic app working first
- ✅ Xcode will prompt you if/when you need to configure specific services

#### When to Come Back to These

**Add Keys later when you need**:

- Custom push notification server
- App Store automation
- Advanced security features

**Configure Services when you add**:

- Apple ID sign-in to your app
- Advanced user account features

### Provisioning Profiles Management

#### What You See in Developer Dashboard

The "Getting Started with Provisioning Profiles" page with "Generate a profile"
button is for manual provisioning profile creation.

#### What You Should Do: **Nothing (for now)!**

**Recommended Approach**: Let Xcode handle provisioning profiles automatically

- **Don't click "Generate a profile"** - Xcode will do this for you
- **Automatic management is easier** and less error-prone
- **Xcode creates profiles on-demand** when you build/run

#### When Provisioning Profiles Are Created Automatically

1. **First device build**: When you build for your registered iPhone
2. **App Store upload**: When you archive and upload to App Store Connect
3. **TestFlight upload**: When you distribute for beta testing

#### Manual vs Automatic Provisioning

**Automatic (Recommended for React Native)**:

- ✅ Xcode handles everything
- ✅ Creates profiles as needed
- ✅ Includes registered devices automatically
- ✅ Updates when certificates/devices change
- ✅ Less chance of errors

**Manual (Advanced users only)**:

- ❌ More complex setup
- ❌ Need to manually update when devices change
- ❌ Must manually renew expired profiles
- ✅ More control over specific configurations

#### When You MIGHT Need Manual Profiles

- **Enterprise distribution** (not typical for React Native apps)
- **Specific app extensions** requiring custom entitlements
- **Complex multi-target projects** with special requirements
- **CI/CD pipelines** that need consistent profile management

### Apple Developer Account Registration

#### When Bundle IDs are Registered

- **Automatic Registration**: Bundle IDs are automatically registered when you:
  - First build and upload to App Store Connect
  - Upload to TestFlight
  - Use Xcode's automatic signing and build for device
- **Manual Registration**: You can optionally register early at:
  - developer.apple.com > Certificates, Identifiers & Profiles > Identifiers

#### Do You Need to Register Manually?

**No, manual registration is optional** for most cases:

- Xcode will handle registration automatically when needed
- Useful for early registration if you want to set up push notifications, etc.
- Required only for specific capabilities that need early setup

#### How to Manually Register (Optional)

1. Go to [Apple Developer Portal](https://developer.apple.com)
2. Sign in with your Apple ID
3. Navigate to "Certificates, Identifiers & Profiles"
4. Click "Identifiers" in the sidebar
5. Click the "+" button to add new identifier
6. Select "App IDs" and continue
7. Enter your bundle ID: `org.montessoricenter.reactnativetest`
8. Configure any additional capabilities needed

### Additional iOS Setup Steps

- [ ] Configure bundle identifier
- [ ] Set up development team/signing
- [ ] Install CocoaPods dependencies
- [ ] Configure app icons
- [ ] Set app display name
- [ ] Configure launch screen

### References

- [Apple Developer Documentation](https://developer.apple.com/documentation/bundleresources/information_property_list/cfbundleidentifier)
- [React Native iOS Setup Guide](https://reactnative.dev/docs/running-on-ios)

---

_Created: August 4, 2025_ _Part of ReactNativeTest project documentation_
