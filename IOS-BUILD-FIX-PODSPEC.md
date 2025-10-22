# iOS Build Fix - ExpoHead.podspec Error

## Issue
The iOS build in GitHub Actions was failing with the following error:

```
[!] Invalid `Podfile` file: 
[!] Invalid `ExpoHead.podspec` file: undefined method `[]' for nil.
 #  from /Users/runner/work/react-netive-new-repo/react-netive-new-repo/node_modules/expo-router/ios/ExpoHead.podspec:30
```

## Root Cause
The error was caused by **incompatibility between Bun's node_modules structure and CocoaPods**:

1. **Bun's package installation** creates a different node_modules structure compared to npm
2. **CocoaPods requires** a standard npm-compatible node_modules structure to properly read podspec files
3. When the `Podfile` tried to evaluate the `expo-router` podspec, it couldn't find the necessary dependencies because of the non-standard structure
4. This caused the podspec to try to access a nil object with `[]`, resulting in the error

## Solution Applied

### 1. Switched iOS Build to Use npm Instead of Bun
Changed the iOS build job to use `npm` for dependency installation instead of `bun`:

**Before:**
```yaml
- name: Setup Bun
  uses: oven-sh/setup-bun@v2
  with:
    bun-version: ${{ env.BUN_VERSION }}

- name: Install JS dependencies
  run: bun install --frozen-lockfile || bun install
```

**After:**
```yaml
- name: Setup Node.js
  uses: actions/setup-node@v4
  with:
    node-version: ${{ env.NODE_VERSION }}
    cache: 'npm'

- name: Install JS dependencies (using npm for CocoaPods compatibility)
  run: |
    echo "📦 Installing JavaScript dependencies with npm..."
    echo "Using npm instead of bun for iOS builds to ensure CocoaPods compatibility"
    npm ci --legacy-peer-deps || npm install --legacy-peer-deps || npm install
```

### 2. Added Node.js Dependency Verification
Added a verification step to ensure critical packages are installed before running `pod install`:

```yaml
- name: Verify Node.js dependencies for iOS
  run: |
    echo "🔍 Verifying Node.js dependencies before pod install..."
    
    # Verify critical packages exist
    if [ ! -d "node_modules/expo" ]; then
      echo "❌ ERROR: expo package not found in node_modules"
      exit 1
    fi
    
    if [ ! -d "node_modules/react-native" ]; then
      echo "❌ ERROR: react-native package not found in node_modules"
      exit 1
    fi
    
    if [ ! -d "node_modules/expo-router" ]; then
      echo "❌ ERROR: expo-router package not found in node_modules"
      exit 1
    fi
```

### 3. Cleaned CocoaPods Cache
Added a step to clean CocoaPods cache before installation to avoid any corrupted cache issues:

```yaml
- name: Clean CocoaPods cache if corrupted
  run: |
    echo "🧹 Cleaning potential CocoaPods cache issues..."
    cd ios
    rm -rf Pods
    rm -rf ~/Library/Caches/CocoaPods
    rm -rf ~/.cocoapods
```

### 4. Improved Pod Install Error Handling
Enhanced the `pod install` step with better error handling and diagnostics:

```yaml
- name: Install CocoaPods dependencies
  run: |
    cd ios
    
    # Verify node module resolution works
    node --print "require.resolve('expo/package.json')" || {
      echo "❌ ERROR: Cannot resolve expo/package.json from ios directory"
      exit 1
    }
    
    # Try pod install without --repo-update first (faster and more reliable)
    pod install || {
      echo "⚠️  First pod install attempt failed, trying with --repo-update..."
      pod install --repo-update || {
        # Detailed error diagnostics
        exit 1
      }
    }
```

### 5. Updated Cache Keys
Changed the cache key version from `v4` to `v5` to ensure a fresh start:

```yaml
key: v5-${{ runner.os }}-pods-${{ hashFiles('ios/Podfile.lock', 'ios/Podfile', 'package.json') }}
```

## Why This Fix Works

1. **npm creates a standard node_modules structure** that CocoaPods understands and can properly traverse
2. **npm's symlink structure** is compatible with Ruby's `require` statements used in podspecs
3. **Cleaning the cache** ensures no corrupted or incompatible cached data is used
4. **Better error handling** provides more visibility into what's failing

## Trade-offs

- **iOS builds are slightly slower** because npm is generally slower than bun for package installation
- **Android builds still use bun** for faster performance since Gradle doesn't have the same compatibility issues

## Future Considerations

If you want to use bun for iOS builds in the future:
1. Wait for bun to improve compatibility with CocoaPods
2. Or use bun with the `--backend=hardlink` flag which might create a more compatible structure
3. Monitor this issue: https://github.com/oven-sh/bun/issues (check for CocoaPods compatibility)

## Testing

After applying these changes, the iOS build should:
1. ✅ Install dependencies successfully with npm
2. ✅ Verify critical packages are present
3. ✅ Run `pod install` without podspec errors
4. ✅ Create the `.xcworkspace` successfully
5. ✅ Proceed to build the iOS app

## Date Fixed
October 22, 2025

