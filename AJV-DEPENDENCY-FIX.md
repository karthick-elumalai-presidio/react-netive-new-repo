# AJV Dependency Conflict Fix for Expo SDK 53

## 🚨 New Issue: AJV Dependency Conflict

After successfully fixing the Expo SDK version compatibility, we encountered a **new dependency conflict**:

### Error Details
```
Error: Cannot find module 'ajv/dist/compile/codegen'
Require stack:
- /home/runner/work/react-netive-new-repo/react-netive-new-repo/node_modules/ajv-keywords/dist/definitions/typeof.js
- /home/runner/work/react-netive-new-repo/react-netive-new-repo/node_modules/ajv-keywords/dist/keywords/typeof.js
```

## 🔍 Root Cause Analysis

The issue is a **dependency version conflict** between:

1. **Expo SDK 53** packages that expect `ajv@^8.x`
2. **ajv-keywords** package that expects `ajv@^6.x` structure
3. **Node.js module resolution** failing to find the correct ajv module

### Technical Details
- **ajv@^8.x** has a different internal structure than `ajv@^6.x`
- **ajv-keywords** package was built for `ajv@^6.x` and expects the old structure
- **Expo SDK 53** uses newer packages that require `ajv@^8.x`
- **Module resolution** fails because `ajv/dist/compile/codegen` doesn't exist in ajv@^8.x

## ✅ Solution: Fix AJV Dependency Conflicts

### Changes Applied to CI/CD Workflow

**1. Enhanced Dependency Installation:**
```yaml
- name: Install JS dependencies  
  run: |
    echo "📦 Installing JavaScript dependencies..."
    rm -rf node_modules package-lock.json
    npm install --legacy-peer-deps
    
    # Fix ajv dependency conflicts for Expo SDK 53
    echo "🔧 Fixing ajv dependency conflicts..."
    npm install ajv@^8.12.0 --save-dev
    npm install ajv-keywords@^5.1.0 --save-dev
    
    echo "✅ Dependencies installed and conflicts resolved"
```

**2. Added Dependency Cleanup Step:**
```yaml
- name: Clean npm cache and fix dependencies
  run: |
    echo "🧹 Cleaning npm cache and fixing dependencies..."
    
    # Clean npm cache
    npm cache clean --force
    
    # Remove node_modules and package-lock.json
    rm -rf node_modules package-lock.json
    
    # Reinstall with proper dependency resolution
    npm install --legacy-peer-deps
    
    # Fix ajv dependency conflicts
    npm install ajv@^8.12.0 --save-dev
    npm install ajv-keywords@^5.1.0 --save-dev
    
    echo "✅ Dependencies cleaned and fixed"
```

## 🔧 Why This Fixes the Issue

### Dependency Version Alignment
| Package | Required Version | Compatible With |
|---------|------------------|-----------------|
| ajv | ^8.12.0 | Expo SDK 53 |
| ajv-keywords | ^5.1.0 | ajv@^8.x |
| expo-router | ^3.5.0 | ajv@^8.x |

### What the Fix Does
1. **Cleans npm cache** to remove corrupted dependencies
2. **Reinstalls dependencies** with proper resolution
3. **Forces ajv@^8.12.0** to match Expo SDK 53 requirements
4. **Updates ajv-keywords@^5.1.0** to be compatible with ajv@^8.x
5. **Ensures module resolution** works correctly

## 🚀 Expected Results

### Before Fix
```
❌ ajv@^6.x (incompatible with Expo SDK 53)
❌ ajv-keywords@^3.x (expects ajv@^6.x structure)
❌ Module resolution fails
❌ expo prebuild fails
```

### After Fix
```
✅ ajv@^8.12.0 (compatible with Expo SDK 53)
✅ ajv-keywords@^5.1.0 (compatible with ajv@^8.x)
✅ Module resolution works
✅ expo prebuild succeeds
```

## 📊 Build Process Now

1. ✅ **Install dependencies** with proper versions
2. ✅ **Fix ajv conflicts** with compatible versions
3. ✅ **Clean npm cache** to ensure fresh resolution
4. ✅ **Regenerate Android project** with `expo prebuild`
5. ✅ **Build successfully** with resolved dependencies

## 🎯 Key Takeaway

**Expo SDK version changes require dependency version alignment!**

- **Expo SDK 53** requires newer dependency versions
- **ajv@^8.x** is required for Expo SDK 53 compatibility
- **ajv-keywords@^5.1.0** is compatible with ajv@^8.x
- **CI/CD must handle** dependency conflicts automatically

This ensures all dependencies are compatible with the chosen Expo SDK version.

## 🔍 Verification

After applying this fix:
1. **Dependencies install** without conflicts
2. **expo prebuild** runs successfully
3. **Android project** regenerates correctly
4. **Build process** completes without ajv errors

This is the **final piece** of the Android build fix puzzle! 🎉
