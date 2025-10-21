#!/bin/bash

# Commit Native Folders Script
# Run this ONCE after Build #68 succeeds to commit ios/ and android/ folders
# This makes future CI builds much faster (skips expo prebuild)

set -e

echo "📋 Checking for native project files..."

# Check if native projects exist
if [ ! -f "android/build.gradle" ]; then
  echo "❌ ERROR: android/build.gradle not found!"
  echo "   Run this after CI generates the folders, or run:"
  echo "   npx expo prebuild --platform android --clean"
  exit 1
fi

if [ ! -f "ios/Podfile" ]; then
  echo "❌ ERROR: ios/Podfile not found!"
  echo "   Run this after CI generates the folders, or run:"
  echo "   npx expo prebuild --platform ios --clean"
  exit 1
fi

echo "✅ Native projects found!"
echo ""
echo "📦 Adding files to git..."

# Add all native files except build outputs (already in .gitignore)
git add android/ ios/

echo ""
echo "📊 Files to be committed:"
git status --short android/ ios/

echo ""
echo "🔍 Summary:"
android_files=$(git diff --cached --numstat android/ | wc -l | xargs)
ios_files=$(git diff --cached --numstat ios/ | wc -l | xargs)

echo "  Android files: $android_files"
echo "  iOS files: $ios_files"

echo ""
read -p "📝 Commit these files? (y/N): " confirm

if [ "$confirm" = "y" ] || [ "$confirm" = "Y" ]; then
  git commit -m "chore: commit native ios/ and android/ folders for fast CI builds

This commit adds the generated native project folders to the repository.

Benefits:
- ✅ Faster CI builds (skips expo prebuild step)
- ✅ No more dependency prompts in CI
- ✅ Consistent native project structure
- ✅ Full control over native code

Generated using:
- expo prebuild --platform android --clean
- expo prebuild --platform ios --clean

The workflow will automatically detect these folders and skip generation."
  
  echo ""
  echo "✅ Committed!"
  echo ""
  echo "🚀 Push to remote?"
  read -p "   Push now? (y/N): " push_confirm
  
  if [ "$push_confirm" = "y" ] || [ "$push_confirm" = "Y" ]; then
    git push origin develop
    echo "✅ Pushed to develop!"
  else
    echo "⏸️  Not pushed. Run 'git push origin develop' when ready."
  fi
else
  echo "❌ Cancelled. No files committed."
  git reset HEAD android/ ios/
fi

