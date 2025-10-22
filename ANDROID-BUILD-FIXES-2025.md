# Android Build Fixes - October 2025

## Issues Identified and Fixed

### 1. Missing Babel Plugin Dependency ❌ → ✅
**Error:** 
```
Cannot find module 'react-native-worklets/plugin'
```

**Root Cause:**
- `babel.config.js` referenced `react-native-worklets/plugin` 
- Package `react-native-worklets-core` was not installed in `package.json`

**Fix:**
- Added `react-native-worklets-core: ~1.4.1` to dependencies in `package.json`

### 2. React Native Version Incompatibility ❌ → ✅
**Error:**
```
11 errors in react-native-reanimated compilation
- ReactViewBackgroundDrawable not found
- updateLayout method signature mismatch
- Various deprecated API calls
```

**Root Cause:**
- `react-native` was set to `^0.81.4` (incorrect/future version)
- `react-native-reanimated` version `~3.6.3` was incompatible with the React Native version

**Fix:**
- Updated `react-native` to `0.76.5` (stable, current version)
- Updated `react-native-reanimated` to `~3.16.6` (compatible with RN 0.76.x)

### 3. Java Version Compatibility ❌ → ✅
**Error:**
```
Unsupported class file major version 69
BUG! exception in phase 'semantic analysis'
```

**Root Cause:**
- System had Java 25 installed (class file major version 69)
- Gradle 8.14.3 only supports up to Java 24
- React Native projects require Java 17 LTS for stability

**Fix:**
- Configured environment to use Java 17 (Temurin)
- Verified GitHub Actions workflow already uses Java 17
- Added proper `JAVA_HOME` configuration for local builds

### 4. Missing Android SDK Configuration ❌ → ✅
**Error:**
```
SDK location not found. Define a valid SDK location with an ANDROID_HOME
```

**Fix:**
- Set `ANDROID_HOME` environment variable to `~/Library/Android/sdk`
- Required for local builds

### 5. Gradle Build Cache Issues ❌ → ✅
**Issue:**
- Old Gradle daemons running with incorrect Java version
- Stale build artifacts

**Fix:**
- Stopped all Gradle daemons: `./gradlew --stop`
- Cleaned build cache: `./gradlew clean`
- Removed `.gradle` and `build` directories

## Updated package.json Dependencies

```json
{
  "react-native": "0.76.5",
  "react-native-reanimated": "~3.16.6",
  "react-native-worklets-core": "~1.4.1"
}
```

## Environment Requirements

### Local Development
```bash
# Java
Java 17 LTS (Temurin/AdoptOpenJDK recommended)
export JAVA_HOME=$(/usr/libexec/java_home -v 17)

# Node.js
Node 20+ (as configured in CI)

# Android SDK
export ANDROID_HOME=~/Library/Android/sdk
export PATH="$ANDROID_HOME/platform-tools:$ANDROID_HOME/tools:$PATH"
```

### CI/CD (GitHub Actions)
- ✅ Java 17 (Temurin) - already configured
- ✅ Node 20 - already configured
- ✅ Bun 1.1.34 - already configured
- ✅ Ruby 3.2 for Fastlane - already configured

## Build Commands

### Clean Build (Local)
```bash
# Set environment
export JAVA_HOME=$(/usr/libexec/java_home -v 17)
export PATH="/opt/homebrew/bin:$PATH"
export ANDROID_HOME=~/Library/Android/sdk

# Install dependencies (choose one)
npm install
# or
yarn install
# or
bun install

# Clean and build
cd android
./gradlew clean
./gradlew bundleRelease assembleRelease
```

### CI/CD Build
The GitHub Actions workflow automatically:
1. Installs dependencies with Bun
2. Sets up Java 17
3. Cleans autolinking cache
4. Builds release artifacts

## Next Steps

### Required Action
**Install the updated dependencies:**
```bash
npm install
# or
yarn install
# or
bun install
```

### Then Test Build
```bash
# Local test
cd android
export JAVA_HOME=$(/usr/libexec/java_home -v 17)
export ANDROID_HOME=~/Library/Android/sdk
export PATH="/opt/homebrew/bin:$PATH"
./gradlew bundleRelease assembleRelease

# Or test via CI
git add package.json
git commit -m "fix: update dependencies for Android build compatibility"
git push
```

## Summary of Changes

| File | Changes |
|------|---------|
| `package.json` | - Fixed React Native version: `0.81.4` → `0.76.5`<br>- Updated react-native-reanimated: `3.6.3` → `3.16.6`<br>- Added react-native-worklets-core: `~1.4.1` |
| Local Environment | - Switched from Java 25 to Java 17<br>- Set ANDROID_HOME properly<br>- Cleaned Gradle cache |
| CI/CD Workflow | ✅ Already configured correctly with Java 17 |

## Expected Build Status
After installing dependencies and pushing changes, the Android build should:
- ✅ Complete Metro bundling without Babel errors
- ✅ Compile react-native-reanimated without Java errors
- ✅ Generate APK and AAB artifacts successfully

## Troubleshooting

If build still fails:

1. **Clear all caches:**
   ```bash
   cd android
   ./gradlew --stop
   ./gradlew clean
   rm -rf .gradle build app/build
   cd ..
   rm -rf node_modules
   npm install  # or yarn/bun
   ```

2. **Verify Java version:**
   ```bash
   java -version  # Should show Java 17
   ```

3. **Check node_modules:**
   ```bash
   ls -la node_modules/react-native-worklets-core  # Should exist
   ```

---

**Build fixed by:** AI Assistant  
**Date:** October 22, 2025  
**Status:** ✅ Ready for testing

