# Quick Fix Guide - Script Setup Errors

**If you're seeing errors when trying to copy or run the starter script, follow this guide.**

---

## 🚨 **Error 1: cp command usage error**

**You see**:
```
usage: cp [-R [-H | -L | -P]] [-fi | -n] [-aclpSsvXx] source_file target_file
```

**Problem**: Incomplete copy command (missing target directory)

**Solution**: Use the complete command:
```bash
# ✅ CORRECT - Copy this exact line:
cp /Users/rogerharris/Projects/ReactNativeTest/scripts/create-react-native-project.sh /Users/rogerharris/Projects/

# ❌ WRONG - Don't copy incomplete commands like:
# cp /Users/rogerharris/Projects/ReactNativeTest/scripts/
```

---

## 🚨 **Error 2: command not found**

**You see**:
```
zsh: command not found: create-react-native-project.sh
```

**Problem**: Either script not copied, or trying to run from wrong directory, or missing `./` prefix

**Solution**: Follow these exact steps:
```bash
# 1. Make sure you're in the Projects directory
cd /Users/rogerharris/Projects

# 2. Check if the script exists
ls -la create-react-native-project.sh

# 3. If script exists, run it with ./ prefix
./create-react-native-project.sh

# 4. If script doesn't exist, copy it first
cp /Users/rogerharris/Projects/ReactNativeTest/scripts/create-react-native-project.sh /Users/rogerharris/Projects/
```

---

## 🚨 **Error 3: Permission denied**

**You see**:
```
zsh: permission denied: ./create-react-native-project.sh
```

**Problem**: Script is not executable

**Solution**: Make it executable:
```bash
chmod +x /Users/rogerharris/Projects/create-react-native-project.sh
./create-react-native-project.sh
```

---

## 🚨 **Error 4: Script continues without waiting for input**

**You see**:
```
📚 Add reusable documentation? (y/n): 
📋 Configuration Summary
[Script continues without waiting for response]
```

**Problem**: Input validation issue (fixed in latest version)

**Solution**: Use the updated script with improved input validation:
```bash
# 1. Copy the latest version of the script
cp /Users/rogerharris/Projects/ReactNativeTest/scripts/create-react-native-project.sh /Users/rogerharris/Projects/

# 2. The script now requires valid input:
# - Architecture: Must enter '1' or '2'  
# - Documentation: Must enter 'y' or 'n'
# - Continue: Must enter 'y' or 'n'

# 3. Invalid inputs will show error and ask again:
# ❌ Please enter 'y' for Yes or 'n' for No
```

---

## 🚨 **Error 5: binary operator expected**

**You see**:
```
./create-react-native-project.sh: line 113: [: =~: binary operator expected
```

**Problem**: Script syntax error (fixed in latest version)

**Solution**: Copy the updated script:
```bash
cp /Users/rogerharris/Projects/ReactNativeTest/scripts/create-react-native-project.sh /Users/rogerharris/Projects/
```

---

## ✅ **Complete Working Sequence**

**Copy and paste these commands one by one:**

```bash
# 1. Copy the script
cp /Users/rogerharris/Projects/ReactNativeTest/scripts/create-react-native-project.sh /Users/rogerharris/Projects/

# 2. Navigate to Projects directory
cd /Users/rogerharris/Projects

# 3. Verify script exists and check permissions
ls -la create-react-native-project.sh

# 4. Make sure it's executable (if not already)
chmod +x create-react-native-project.sh

# 5. Run the script
./create-react-native-project.sh
```

---

## 🔍 **Verification Commands**

**Use these to check your setup:**

```bash
# Check current directory
pwd
# Should show: /Users/rogerharris/Projects

# Check if ReactNativeTest exists
ls -la ReactNativeTest/
# Should show the exemplar project directory

# Check if script was copied
ls -la create-react-native-project.sh
# Should show: -rwxr-xr-x ... create-react-native-project.sh

# Check if script is executable (look for 'x' in permissions)
ls -la create-react-native-project.sh | grep rwx
# Should show executable permissions
```

---

## 🎯 **Success Indicators**

**You know it's working when:**

1. ✅ `cp` command completes without errors
2. ✅ `ls -la create-react-native-project.sh` shows the file exists
3. ✅ `pwd` shows you're in `/Users/rogerharris/Projects`
4. ✅ `./create-react-native-project.sh` starts the interactive setup

**Then you'll see:**
```
🚀 React Native Project Creator - Complete Guided Setup
=====================================================

✅ ReactNativeTest exemplar found
✅ Running from correct directory

📋 Project Configuration
========================
🏷️  Project Name (e.g., TestAppF, MyNewApp):
```

---

## 💡 **Pro Tips to Avoid Errors**

1. **Always copy complete commands** - Don't copy partial lines
2. **Use Tab completion** - Type first few characters and press Tab
3. **Check your directory** - Run `pwd` to confirm location
4. **Use `./` prefix** - Required to run scripts in current directory
5. **Verify before running** - Use `ls -la` to check files exist

---

**Once these steps work, you're ready for smooth React Native project creation!** 🚀
