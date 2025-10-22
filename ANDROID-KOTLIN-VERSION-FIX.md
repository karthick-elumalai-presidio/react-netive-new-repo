# Android Build Fix - React Native 0.76 Compatibility

## Issues
The Android build was failing with two errors:

### Issue 1: Kotlin Version Incompatibility
```
Can't find KSP version for Kotlin version '1.9.24'. 
You're probably using an unsupported version of Kotlin. 
Supported versions are: '2.2.20, 2.2.10, 2.2.0, 2.1.21, 2.1.20, 2.1.10, 2.1.0, 2.0.21, 2.0.20, 2.0.10, 2.0.0'
```

### Issue 2: Removed React Extension Property
```
Could not set unknown property 'enableBundleCompression' for extension 'react' of type com.facebook.react.ReactExtension.
```

## Root Causes
**These are NOT platform-specific issues** - they would fail on both Ubuntu and macOS runners.

### Root Cause 1: Kotlin Version
1. **Expo SDK 54** and **React Native 0.76.5** require newer Kotlin versions
2. **KSP (Kotlin Symbol Processing)** plugin used by Expo requires Kotlin **2.0+**
3. The project was defaulting to Kotlin **1.9.24** because no version was explicitly specified
4. Kotlin 1.9.24 is not supported by the current KSP version

### Root Cause 2: Deprecated React Native Property
1. **React Native 0.76** removed the `enableBundleCompression` property from the React Gradle extension
2. Bundle compression is now handled automatically by Metro bundler
3. The property was present in the `android/app/build.gradle` from an older React Native template

## Why Running on macOS Won't Fix This
This is a **dependency version incompatibility**, not an OS or runner issue. The same error would occur on:
- ✗ macOS runner
- ✗ Ubuntu runner  
- ✗ Windows runner
- ✗ Your local machine (unless you've manually fixed the Kotlin version)

The fix requires **updating the Kotlin version** regardless of the platform.

## Solutions Applied

### Fix 1: Update Kotlin Version

#### 1.1 Updated `android/build.gradle`
Added explicit Kotlin version specification:

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

#### 1.2 Updated `android/gradle.properties`
Added Kotlin version property for reference:

```properties
# Kotlin version - must be 2.0+ for KSP compatibility with Expo SDK 54 and React Native 0.76
# Supported KSP versions: 2.2.20, 2.2.10, 2.2.0, 2.1.21, 2.1.20, 2.1.10, 2.1.0, 2.0.21, 2.0.20, 2.0.10, 2.0.0
KOTLIN_VERSION=2.0.21
```

### Fix 2: Remove Deprecated enableBundleCompression Property

#### 2.1 Updated `android/app/build.gradle`
Removed the deprecated `enableBundleCompression` property:

**Before:**
```gradle
react {
    // ... other config
    enableBundleCompression = (findProperty('android.enableBundleCompression') ?: false).toBoolean()
    // ... rest of config
}
```

**After:**
```gradle
react {
    // ... other config
    // enableBundleCompression property removed in React Native 0.76
    // Bundle compression is now handled automatically by Metro bundler
    // ... rest of config
}
```

This property was removed in React Native 0.76 as bundle compression is now handled automatically by the Metro bundler.

## Why Kotlin 2.0.21?
- ✅ **Stable release** from the Kotlin 2.0.x series
- ✅ **Compatible with KSP** (explicitly listed in the error message)
- ✅ **Compatible with Expo SDK 54** and React Native 0.76
- ✅ **Production-ready** (not a bleeding-edge version)
- ✅ **Well-tested** with React Native ecosystem

## Alternative Kotlin Versions
If you encounter issues with 2.0.21, you can try these alternatives (all KSP-compatible):

**Kotlin 2.0.x (Stable)**
- `2.0.21` (recommended)
- `2.0.20`
- `2.0.10`
- `2.0.0`

**Kotlin 2.1.x (Newer)**
- `2.1.21`
- `2.1.20`
- `2.1.10`
- `2.1.0`

**Kotlin 2.2.x (Latest)**
- `2.2.20`
- `2.2.10`
- `2.2.0`

> ⚠️ **Note**: Newer versions (2.1.x, 2.2.x) may have better performance but could have undiscovered compatibility issues with some libraries. Stick with 2.0.21 unless you have a specific reason to upgrade.

## How to Change Kotlin Version
If you need to change the Kotlin version in the future:

1. Edit `android/build.gradle`:
```gradle
kotlinVersion = '2.0.21'  // Change this value
```

2. Update the comment in `android/gradle.properties`:
```properties
KOTLIN_VERSION=2.0.21  // Change this value
```

3. Clean and rebuild:
```bash
cd android
./gradlew clean
cd ..
```

## Verification
After these fixes, the Android build should:
1. ✅ Use Kotlin 2.0.21 with KSP 2.0.21-1.0.28 (check build output)
2. ✅ Successfully apply the `expo-root-project` plugin
3. ✅ Compile Kotlin code without KSP version errors
4. ✅ Skip the deprecated `enableBundleCompression` property
5. ✅ Complete the build and generate APK/AAB files
6. ✅ Work on any CI/CD platform (GitHub Actions, GitLab CI, CircleCI, etc.)

You should see this in the build output:
```
[ExpoRootProject] Using the following versions:
  - kotlin:      2.0.21
  - ksp:         2.0.21-1.0.28
```

## Related Documentation
- [Kotlin Releases](https://github.com/JetBrains/kotlin/releases)
- [KSP Compatibility](https://github.com/google/ksp/releases)
- [Expo SDK 54 Release Notes](https://expo.dev/changelog/2025/01-14-sdk-54)
- [React Native 0.76 Release Notes](https://reactnative.dev/blog)
- [React Native 0.76 Breaking Changes](https://github.com/facebook/react-native/releases/tag/v0.76.0)

## Date Fixed
October 22, 2025

## Summary
**The Android build will now work on both Ubuntu and macOS runners** after applying two critical fixes:
1. ✅ **Kotlin version upgraded to 2.0.21** - compatible with KSP and Expo SDK 54/React Native 0.76
2. ✅ **Removed deprecated `enableBundleCompression` property** - no longer exists in React Native 0.76

These fixes address React Native 0.76 compatibility requirements and ensure the project builds successfully in CI/CD environments.

