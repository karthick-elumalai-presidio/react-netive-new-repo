#!/bin/bash

# Pipeline Validation Script
echo "🔍 Validating CI/CD Pipeline Configuration..."

# Check if required files exist
echo "📁 Checking required files..."

files=(
  ".github/workflows/mobile-ci-cd.yml"
  "android/Gemfile"
  "android/fastlane/Fastfile"
  "android/fastlane/Appfile"
  "ios/Gemfile"
  "ios/fastlane/Fastfile"
  "ios/fastlane/Appfile"
  "package.json"
  "bun.lock"
  "app.json"
)

for file in "${files[@]}"; do
  if [ -f "$file" ]; then
    echo "✅ $file exists"
  else
    echo "❌ $file missing"
    exit 1
  fi
done

# Check package.json scripts
echo "📦 Checking package.json scripts..."
if grep -q "prebuild:clean" package.json; then
  echo "✅ prebuild:clean script found"
else
  echo "❌ prebuild:clean script missing"
  exit 1
fi

# Check workflow file syntax
echo "⚙️ Validating GitHub Actions workflow..."
if command -v yamllint &> /dev/null; then
  yamllint .github/workflows/mobile-ci-cd.yml
  if [ $? -eq 0 ]; then
    echo "✅ Workflow YAML syntax is valid"
  else
    echo "❌ Workflow YAML syntax errors found"
    exit 1
  fi
else
  echo "⚠️ yamllint not installed, skipping YAML validation"
fi

# Check Fastlane syntax
echo "🚀 Validating Fastlane files..."
if command -v ruby &> /dev/null; then
  ruby -c android/fastlane/Fastfile
  if [ $? -eq 0 ]; then
    echo "✅ Android Fastfile syntax is valid"
  else
    echo "❌ Android Fastfile syntax errors found"
    exit 1
  fi

  ruby -c ios/fastlane/Fastfile
  if [ $? -eq 0 ]; then
    echo "✅ iOS Fastfile syntax is valid"
  else
    echo "❌ iOS Fastfile syntax errors found"
    exit 1
  fi
else
  echo "⚠️ Ruby not installed, skipping Fastlane validation"
fi

echo "🎉 Pipeline validation completed successfully!"
echo ""
echo "📋 Next steps:"
echo "1. Configure GitHub Secrets (see CICD-README.md)"
echo "2. Push to develop branch to trigger development build"
echo "3. Monitor GitHub Actions for build status"
