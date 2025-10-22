#!/bin/bash

# Android Build Helper Script
# This script sets up the correct environment for Android builds

set -e

echo "🚀 Android Build Helper"
echo "======================="

# Set Java 17
export JAVA_HOME=$(/usr/libexec/java_home -v 17 2>/dev/null || echo "")
if [ -z "$JAVA_HOME" ]; then
    echo "❌ Error: Java 17 not found. Please install Java 17 LTS."
    echo "   Download from: https://adoptium.net/"
    exit 1
fi

echo "✅ Using Java 17: $JAVA_HOME"
java -version

# Set Android SDK
if [ -d "$HOME/Library/Android/sdk" ]; then
    export ANDROID_HOME="$HOME/Library/Android/sdk"
elif [ -d "$HOME/Android/Sdk" ]; then
    export ANDROID_HOME="$HOME/Android/Sdk"
else
    echo "❌ Error: Android SDK not found"
    echo "   Please install Android Studio or set ANDROID_HOME manually"
    exit 1
fi

echo "✅ Using Android SDK: $ANDROID_HOME"

# Add Node to PATH (for Homebrew users)
if [ -d "/opt/homebrew/bin" ]; then
    export PATH="/opt/homebrew/bin:$PATH"
fi

# Check if node_modules exists
if [ ! -d "node_modules" ]; then
    echo "⚠️  node_modules not found. Installing dependencies..."
    if command -v bun &> /dev/null; then
        echo "📦 Using Bun..."
        bun install
    elif command -v yarn &> /dev/null; then
        echo "📦 Using Yarn..."
        yarn install
    elif command -v npm &> /dev/null; then
        echo "📦 Using npm..."
        npm install
    else
        echo "❌ Error: No package manager found (npm, yarn, or bun)"
        exit 1
    fi
fi

# Check for required package
if [ ! -d "node_modules/react-native-worklets-core" ]; then
    echo "❌ Error: react-native-worklets-core not installed"
    echo "   Run: npm install (or yarn/bun install)"
    exit 1
fi

echo "✅ Dependencies verified"

# Navigate to android directory
cd android

# Parse command line arguments
CLEAN=false
BUILD_TYPE="release"

while [[ $# -gt 0 ]]; do
    case $1 in
        --clean)
            CLEAN=true
            shift
            ;;
        --debug)
            BUILD_TYPE="debug"
            shift
            ;;
        --release)
            BUILD_TYPE="release"
            shift
            ;;
        *)
            echo "Unknown option: $1"
            echo "Usage: $0 [--clean] [--debug|--release]"
            exit 1
            ;;
    esac
done

# Clean if requested
if [ "$CLEAN" = true ]; then
    echo "🧹 Cleaning Android build..."
    ./gradlew --stop
    ./gradlew clean
    rm -rf .gradle build app/build
    echo "✅ Clean completed"
fi

# Build
echo "🔨 Building Android ($BUILD_TYPE)..."
if [ "$BUILD_TYPE" = "release" ]; then
    ./gradlew bundleRelease assembleRelease
    echo ""
    echo "✅ Build completed successfully!"
    echo ""
    echo "📦 Build artifacts:"
    echo "   AAB: android/app/build/outputs/bundle/release/app-release.aab"
    echo "   APK: android/app/build/outputs/apk/release/app-release.apk"
else
    ./gradlew assembleDebug
    echo ""
    echo "✅ Build completed successfully!"
    echo ""
    echo "📦 Build artifacts:"
    echo "   APK: android/app/build/outputs/apk/debug/app-debug.apk"
fi

echo ""
echo "🎉 All done!"

