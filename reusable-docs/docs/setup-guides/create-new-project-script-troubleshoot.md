rogerharris@Rogers-MacBook-Pro ReactNativeTest % ./scripts/create-new-project-from-exemplar.sh
🛡️ Phase 2: Enhanced Safety and Quality Setup
  Copying enhanced Metro safety script...
cp: /scripts/enhanced-metro-safety.sh: No such file or directory
chmod: enhanced-metro-safety.sh: No such file or directory
  Copying legacy safety script as backup...
  ⚠️  Legacy start-metro.sh not found
  Adding enhanced safety scripts to package.json...
  ✅ Enhanced scripts added using jq
  ✅ Enhanced safety and quality setup completeeate new React Native projects using proven ReactNativeTest patterns
🚀 React Native Project Generator (ReactNativeTest Exemplar)
================================================================
✅ ReactNativeTest exemplar project found

📋 Project Configuration
========================
🏷️  Project Name (e.g., MyNewApp): TestAppC
📱 Content Type (replace 'game' with your domain, e.g., 'fitness', 'learning'): education
📝 Project Description: App for school resources and conncetions

🎯 App Architecture Selection
==============================

Choose your app's architecture pattern:

1. 📱 Single Feature App (like ReactNativeTest)
   • Home → Authentication → One Main Feature
   • Examples: Game app, workout app, single-purpose tool

2. 🏫 Multi-Feature Dashboard App (like school/business apps)
   • Authentication → Onboarding → Dashboard with multiple features
   • Examples: School communication, business portal, multi-service app

🔧 Select architecture (1=single, 2=multi): 2
✅ Multi-Feature Dashboard App selected

🎯 Multi-Feature Dashboard Configuration
========================================

📋 Onboarding Screens (after authentication, before dashboard):
  • Examples: PreferredNameScreen, EmailSettingsScreen, ClassroomSelectionScreen
  • Enter screen names separated by commas (or press Enter for default 3-screen onboarding)
🎨 Onboarding Screens (comma-separated): 
  ✅ Using default onboarding: Preferred Name, Email Settings, Classroom Selection

🏠 Dashboard Features (main feature buttons after onboarding):
  • Examples: Messages, Calendar, Announcements, Events, News, Directory
  • Enter feature names separated by commas (or press Enter for school app defaults)
🔧 Dashboard Features (comma-separated): 
  ✅ Using default school features: Messages, Calendar, Announcements, Events, News, Directory

📋 Configuration Summary:
  Project Name: TestAppC
  Content Type: education
  Description: App for school resources and conncetions
  Architecture: multi (Multi-Feature Dashboard)
  Onboarding Screens: PreferredNameScreen,EmailSettingsScreen,ClassroomSelectionScreen
  Dashboard Features: Messages,Calendar,Announcements,Events,News,Directory

🔄 User Flow Preview:
  Authentication → Onboarding Screens → DashboardScreen with feature buttons

📁 Files that will be created:
  • Multiple onboarding screens in src/screens/onboarding/
  • DashboardScreen with feature navigation buttons
  • Individual feature screen templates

✅ Proceed with project creation? (y=yes, n=no, e=edit configuration): y

🚀 Starting project creation...
📦 Phase 1: Project Initialization
  Creating React Native project with TypeScript...
warn Ignoring custom template: 'react-native-template-typescript'. Starting from React Native v0.71 TypeScript is used by default.
                                                          
               ######                ######               
             ###     ####        ####     ###             
            ##          ###    ###          ##            
            ##             ####             ##            
            ##             ####             ##            
            ##           ##    ##           ##            
            ##         ###      ###         ##            
             ##  ########################  ##             
          ######    ###            ###    ######          
      ###     ##    ##              ##    ##     ###      
   ###         ## ###      ####      ### ##         ###   
  ##           ####      ########      ####           ##  
 ##             ###     ##########     ###             ## 
  ##           ####      ########      ####           ##  
   ###         ## ###      ####      ### ##         ###   
      ###     ##    ##              ##    ##     ###      
          ######    ###            ###    ######          
             ##  ########################  ##             
            ##         ###      ###         ##            
            ##           ##    ##           ##            
            ##             ####             ##            
            ##             ####             ##            
            ##          ###    ###          ##            
             ###     ####        ####     ###             
               ######                ######               
                                                          

              Welcome to React Native 0.80.2!                
                 Learn once, write anywhere               

✔ Downloading template
⠋ Copying template

error Couldn't find the "/var/folders/rv/tct52wxn0gs3f65mhdsw28y40000gn/T/rncli-init-template-4ljEdw/node_modules/react-native/template.config.js file inside "react-native" template. Please make sure the template is valid. Read more: https://github.com/react-native-community/cli/blob/main/docs/init.md#creating-custom-template
❌ Error: Failed to create React Native project
💡 Manual creation steps:
1. npx @react-native-community/cli@latest init TestAppC --template react-native-template-typescript
2. cd TestAppC
3. Re-run this script from the project directory
rogerharris@Rogers-MacBook-Pro ReactNativeTest % cd ..
rogerharris@Rogers-MacBook-Pro Projects % npx @react-native-community/cli@latest init TestAppC --template react-native-template-typescript

warn Ignoring custom template: 'react-native-template-typescript'. Starting from React Native v0.71 TypeScript is used by default.
                                                          
               ######                ######               
             ###     ####        ####     ###             
            ##          ###    ###          ##            
            ##             ####             ##            
            ##             ####             ##            
            ##           ##    ##           ##            
            ##         ###      ###         ##            
             ##  ########################  ##             
          ######    ###            ###    ######          
      ###     ##    ##              ##    ##     ###      
   ###         ## ###      ####      ### ##         ###   
  ##           ####      ########      ####           ##  
 ##             ###     ##########     ###             ## 
  ##           ####      ########      ####           ##  
   ###         ## ###      ####      ### ##         ###   
      ###     ##    ##              ##    ##     ###      
          ######    ###            ###    ######          
             ##  ########################  ##             
            ##         ###      ###         ##            
            ##           ##    ##           ##            
            ##             ####             ##            
            ##             ####             ##            
            ##          ###    ###          ##            
             ###     ####        ####     ###             
               ######                ######               
                                                          

              Welcome to React Native 0.80.2!                
                 Learn once, write anywhere               

✔ Downloading template
⠋ Copying template

error Couldn't find the "/var/folders/rv/tct52wxn0gs3f65mhdsw28y40000gn/T/rncli-init-template-pAlCDk/node_modules/react-native/template.config.js file inside "react-native" template. Please make sure the template is valid. Read more: https://github.com/react-native-community/cli/blob/main/docs/init.md#creating-custom-template
rogerharris@Rogers-MacBook-Pro Projects % cd /Users/rogerharris/Projects/ReactNativeTest

rogerharris@Rogers-MacBook-Pro ReactNativeTest % npx @react-native-community/cli@latest init TestAppC --template react-native-template-typescript
warn Ignoring custom template: 'react-native-template-typescript'. Starting from React Native v0.71 TypeScript is used by default.
                                                          
               ######                ######               
             ###     ####        ####     ###             
            ##          ###    ###          ##            
            ##             ####             ##            
            ##             ####             ##            
            ##           ##    ##           ##            
            ##         ###      ###         ##            
             ##  ########################  ##             
          ######    ###            ###    ######          
      ###     ##    ##              ##    ##     ###      
   ###         ## ###      ####      ### ##         ###   
  ##           ####      ########      ####           ##  
 ##             ###     ##########     ###             ## 
  ##           ####      ########      ####           ##  
   ###         ## ###      ####      ### ##         ###   
      ###     ##    ##              ##    ##     ###      
          ######    ###            ###    ######          
             ##  ########################  ##             
            ##         ###      ###         ##            
            ##           ##    ##           ##            
            ##             ####             ##            
            ##             ####             ##            
            ##          ###    ###          ##            
             ###     ####        ####     ###             
               ######                ######               
                                                          

              Welcome to React Native 0.80.2!                
                 Learn once, write anywhere               

✔ Downloading template
⠋ Copying template

error Couldn't find the "/var/folders/rv/tct52wxn0gs3f65mhdsw28y40000gn/T/rncli-init-template-cMNfnr/node_modules/react-native/template.config.js file inside "react-native" template. Please make sure the template is valid. Read more: https://github.com/react-native-community/cli/blob/main/docs/init.md#creating-custom-template
rogerharris@Rogers-MacBook-Pro ReactNativeTest % cd TestAppC
rogerharris@Rogers-MacBook-Pro TestAppC % ./scripts/create-new-project-from-exemplar.sh
zsh: no such file or directory: ./scripts/create-new-project-from-exemplar.sh
rogerharris@Rogers-MacBook-Pro TestAppC % 
