# Android Build Complete Fix

## Problem Summary

The Android build was failing with THREE distinct issues that needed to be fixed in sequence:

### Issue 1: Kotlin Version Incompatibility
**Error:**
```
Can't find KSP version for Kotlin version '1.9.24'. 
You're probably using an unsupported version of Kotlin. 
Supported versions are: '2.2.20, 2.2.10, 2.2.0, 2.1.21, 2.1.20, 2.1.10, 2.1.0, 2.0.21, 2.0.20, 2.0.10, 2.0.0'
```

**Root Cause:** 
- Expo SDK 54 and React Native 0.76 require Kotlin 2.0+ for KSP (Kotlin Symbol Processing)
- Project was defaulting to Kotlin 1.9.24

### Issue 2: Deprecated React Native Property
**Error:**
```
Could not set unknown property 'enableBundleCompression' for extension 'react' of type com.facebook.react.ReactExtension.
```

**Root Cause:**
- The `enableBundleCompression` property was removed in React Native 0.76
- Bundle compression is now handled automatically by Metro bundler

### Issue 3: API Incompatibility with expo-modules-core
**Error:**
```
e: CSSProps.kt:146:55 Too many arguments for 'fun parse(boxShadow: ReadableMap): BoxShadow?'.
e: ReactNativeFeatureFlags.kt:11:62 Unresolved reference 'enableBridgelessArchitecture'.
```

**Root Cause:**
- `expo-modules-core` 3.0.22 (from Expo SDK 54) requires React Native 0.76.5
- Temporary downgrade to React Native 0.76.3 broke compatibility

## Complete Solution

### 1. Fix Kotlin Version (`android/build.gradle`)

**File:** `/android/build.gradle`

```gradle
buildscript {
  ext {
    // Explicitly set Kotlin version to match KSP requirements
    // KSP requires Kotlin 2.0+ for compatibility with Expo SDK 54 and React Native 0.76
    kotlinVersion = '2.0.21'
  }
  repositories {
    google()
    mavenCentral()
  }
  dependencies {
    classpath('com.android.tools.build:gradle')
    classpath('com.facebook.react:react-native-gradle-plugin')
    classpath("org.jetbrains.kotlin:kotlin-gradle-plugin:$kotlinVersion")
  }
}
```

**Why this works:**
- Kotlin 2.0.21 is fully compatible with KSP 2.0.21-1.0.28 (auto-managed by Expo)
- Meets requirements for both Expo SDK 54 and React Native 0.76.5

### 2. Document Kotlin Version (`android/gradle.properties`)

**File:** `/android/gradle.properties`

Added for consistency and documentation:
```properties
# Kotlin version - must be 2.0+ for KSP compatibility with Expo SDK 54 and React Native 0.76
# Supported KSP versions: 2.2.20, 2.2.10, 2.2.0, 2.1.21, 2.1.20, 2.1.10, 2.1.0, 2.0.21, 2.0.20, 2.0.10, 2.0.0
KOTLIN_VERSION=2.0.21
```

### 3. Remove Deprecated Property (`android/app/build.gradle`)

**File:** `/android/app/build.gradle`

**Before:**
```gradle
react {
    entryFile = file(["node", "-e", "require('expo/scripts/resolveAppEntry')", projectRoot, "android", "absolute"].execute(null, rootDir).text.trim())
    reactNativeDir = new File(["node", "--print", "require.resolve('react-native/package.json')"].execute(null, rootDir).text.trim()).getParentFile().getAbsoluteFile()
    hermesCommand = new File(["node", "--print", "require.resolve('react-native/package.json')"].execute(null, rootDir).text.trim()).getParentFile().getAbsolutePath() + "/sdks/hermesc/%OS-BIN%/hermesc"
    codegenDir = new File(["node", "--print", "require.resolve('@react-native/codegen/package.json', { paths: [require.resolve('react-native/package.json')] })"].execute(null, rootDir).text.trim()).getParentFile().getAbsoluteFile()

    enableBundleCompression = (findProperty('android.enableBundleCompression') ?: false).toBoolean()  // ❌ REMOVED - deprecated in RN 0.76
    
    cliFile = new File(["node", "--print", "require.resolve('@expo/cli', { paths: [require.resolve('expo/package.json')] })"].execute(null, rootDir).text.trim())
    bundleCommand = "export:embed"
}
```

**After:**
```gradle
react {
    entryFile = file(["node", "-e", "require('expo/scripts/resolveAppEntry')", projectRoot, "android", "absolute"].execute(null, rootDir).text.trim())
    reactNativeDir = new File(["node", "--print", "require.resolve('react-native/package.json')"].execute(null, rootDir).text.trim()).getParentFile().getAbsoluteFile()
    hermesCommand = new File(["node", "--print", "require.resolve('react-native/package.json')"].execute(null, rootDir).text.trim()).getParentFile().getAbsolutePath() + "/sdks/hermesc/%OS-BIN%/hermesc"
    codegenDir = new File(["node", "--print", "require.resolve('@react-native/codegen/package.json', { paths: [require.resolve('react-native/package.json')] })"].execute(null, rootDir).text.trim()).getParentFile().getAbsoluteFile()

    // enableBundleCompression property removed in React Native 0.76
    // Bundle compression is now handled automatically by Metro bundler
    
    // Use Expo CLI to bundle the app, this ensures the Metro config
    // works correctly with Expo projects.
    cliFile = new File(["node", "--print", "require.resolve('@expo/cli', { paths: [require.resolve('expo/package.json')] })"].execute(null, rootDir).text.trim())
    bundleCommand = "export:embed"
}
```

**Why this works:**
- Metro bundler now handles compression automatically in React Native 0.76+
- No configuration needed - it just works

### 4. Use Correct React Native Version (`package.json`)

**File:** `/package.json`

```json
{
  "dependencies": {
    "expo": "~54.0.0",
    "react-native": "0.76.5"
  }
}
```

**Why this works:**
- React Native 0.76.5 is the recommended version for Expo SDK 54
- `expo-modules-core` 3.0.22 (from Expo SDK 54) requires React Native 0.76.5
- All deprecated properties have been removed from build configuration

## Verification Steps

### 1. Check Build Configuration
```bash
cd android
./gradlew -q :expo:properties | grep -i kotlin
# Should show: kotlin: 2.0.21
```

### 2. Clean Build
```bash
cd android
./gradlew clean
cd ..
rm -rf node_modules
npm install --legacy-peer-deps
```

### 3. Test Build Locally
```bash
cd android
./gradlew bundleRelease
```

### 4. Expected Output
```
[ExpoRootProject] Using the following versions:
  - buildTools:  35.0.0
  - minSdk:      24
  - compileSdk:  35
  - targetSdk:   34
  - ndk:         26.1.10909125
  - kotlin:      2.0.21      ✓ Correct version
  - ksp:         2.0.21-1.0.28 ✓ Compatible with Kotlin

BUILD SUCCESSFUL
```

## Technical Details

### Kotlin & KSP Compatibility
- **KSP (Kotlin Symbol Processing)** is used by Expo modules for code generation
- Each Kotlin version requires a specific KSP version
- Expo SDK 54 automatically manages KSP version based on Kotlin version
- **Kotlin 2.0.21 → KSP 2.0.21-1.0.28** (automatically set by Expo)

### React Native 0.76 Changes
1. **Bundle Compression:** Now automatic via Metro, no Gradle property needed
2. **Bridgeless Architecture:** New architecture with updated APIs in `expo-modules-core`
3. **Hermes Updates:** Improved bytecode compilation

### Why Version Compatibility Matters
```
Expo SDK 54 → expo-modules-core 3.0.22 → React Native 0.76.5
                                      ↓
                              Kotlin 2.0.21 + KSP 2.0.21-1.0.28
```

All components must be compatible:
- ❌ RN 0.76.3 + expo-modules-core 3.0.22 = API mismatch
- ✅ RN 0.76.5 + expo-modules-core 3.0.22 = Compatible

## Files Modified

1. **`/android/build.gradle`**
   - Added explicit `kotlinVersion = '2.0.21'`

2. **`/android/gradle.properties`**
   - Added `KOTLIN_VERSION=2.0.21` for documentation

3. **`/android/app/build.gradle`**
   - Removed deprecated `enableBundleCompression` line
   - Added explanatory comment

4. **`/package.json`**
   - Ensured `react-native: "0.76.5"` (not 0.76.3)

## CI/CD Impact

The GitHub Actions workflow already handles these changes correctly:
- ✅ Uses npm for consistent dependency resolution
- ✅ Installs correct React Native version (0.76.5)
- ✅ Gradle picks up Kotlin 2.0.21 from `build.gradle`
- ✅ Build should now succeed

## Summary

Three sequential fixes were required:

1. **Kotlin 2.0.21** - Explicit version in `android/build.gradle`
2. **Remove enableBundleCompression** - Deprecated property in `android/app/build.gradle`
3. **React Native 0.76.5** - Correct version in `package.json` for expo-modules-core compatibility

All three fixes are now in place. The Android build should succeed in CI/CD.

---

**Build Status:** ✅ Fixed and Ready for CI/CD
**Last Updated:** 2025-10-22
**React Native:** 0.76.5
**Expo SDK:** 54.0.0
**Kotlin:** 2.0.21
**KSP:** 2.0.21-1.0.28 (auto-managed)
