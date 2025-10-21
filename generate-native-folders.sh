#!/bin/bash
set -e

echo "🚀 Generating native Android and iOS folders with New Architecture DISABLED..."
echo ""

# Backup Fastlane configs
echo "📦 Backing up Fastlane configurations..."
mkdir -p /tmp/fastlane-backup
cp -r android/fastlane /tmp/fastlane-backup/android-fastlane 2>/dev/null || true
cp android/Gemfile /tmp/fastlane-backup/ 2>/dev/null || true
cp android/Gemfile.lock /tmp/fastlane-backup/ 2>/dev/null || true
cp -r ios/fastlane /tmp/fastlane-backup/ios-fastlane 2>/dev/null || true
cp ios/Gemfile /tmp/fastlane-backup/ 2>/dev/null || true
cp ios/Gemfile.lock /tmp/fastlane-backup/ 2>/dev/null || true

# Backup gradle.properties with newArchEnabled=false
echo "📦 Backing up gradle.properties..."
cp android/gradle.properties /tmp/fastlane-backup/gradle.properties 2>/dev/null || true

# Clean any existing native folders
echo "🧹 Cleaning existing native folders..."
rm -rf android/app android/build.gradle android/gradlew android/gradlew.bat android/settings.gradle android/gradle
rm -rf ios/CbMmobileapp ios/CbMmobileapp.xcodeproj ios/CbMmobileapp.xcworkspace ios/Podfile ios/Podfile.lock ios/Pods

# Generate native folders
echo ""
echo "🔨 Running expo prebuild (this will take a few minutes)..."
npx expo prebuild --clean

# Restore gradle.properties with newArchEnabled=false
echo ""
echo "✅ Restoring gradle.properties with newArchEnabled=false..."
if [ -f "/tmp/fastlane-backup/gradle.properties" ]; then
  cp /tmp/fastlane-backup/gradle.properties android/gradle.properties
else
  # Make sure newArchEnabled=false is set
  if ! grep -q "newArchEnabled=false" android/gradle.properties; then
    echo "" >> android/gradle.properties
    echo "# Disable New Architecture (fixes autolinking C++ errors)" >> android/gradle.properties
    echo "newArchEnabled=false" >> android/gradle.properties
  fi
fi

# Restore Fastlane configs
echo "✅ Restoring Fastlane configurations..."
cp -r /tmp/fastlane-backup/android-fastlane android/fastlane 2>/dev/null || true
cp /tmp/fastlane-backup/Gemfile android/ 2>/dev/null || true
cp /tmp/fastlane-backup/Gemfile.lock android/ 2>/dev/null || true
cp -r /tmp/fastlane-backup/ios-fastlane ios/fastlane 2>/dev/null || true
cp /tmp/fastlane-backup/Gemfile ios/ 2>/dev/null || true
cp /tmp/fastlane-backup/Gemfile.lock ios/ 2>/dev/null || true

# Verify
echo ""
echo "🔍 Verifying generation..."
if [ -f "android/gradlew" ] && [ -f "ios/Podfile" ]; then
  echo "✅ Native folders generated successfully!"
  echo ""
  echo "📋 Next steps:"
  echo "  1. git add android/ ios/"
  echo "  2. git commit -m 'chore: add native folders with New Architecture disabled'"
  echo "  3. git push origin develop"
  echo ""
  echo "After pushing, the CI/CD will use these folders directly (no prebuild needed)!"
else
  echo "❌ ERROR: Native folder generation failed"
  exit 1
fi

