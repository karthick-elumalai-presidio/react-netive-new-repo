# GitHub Actions CI/CD Pipeline - Setup Guide

## 🚀 Overview

This repository uses **GitHub Actions** for automated CI/CD pipeline to build, test, and deploy React Native mobile applications (Android & iOS) across multiple environments.

## 📋 Pipeline Structure

### Workflows

1. **`pr-validation.yml`** - Runs on Pull Requests
   - Code quality checks (ESLint, Prettier, TypeScript)
   - Unit tests with coverage
   - Android build validation
   - Automated PR comments with results

2. **`mobile-ci-cd.yml`** - Main CI/CD Pipeline
   - **Validate**: Lint, typecheck, and test on every push
   - **Build Android**: Creates APK and AAB artifacts
   - **Build iOS**: Creates IPA artifacts (requires signing)
   - **Manual Approvals**: Environment-specific approval gates
   - **Deploy**: Automated deployment to Play Store / App Store

## 🔄 Workflow Triggers

### Automatic Triggers
- **Push to `develop`**: Runs validation and builds artifacts
- **Push to `main`**: Runs validation and builds production artifacts
- **Pull Requests**: Runs full validation suite

### Manual Triggers
- **Workflow Dispatch**: Manually trigger builds and deployments
  - Choose environment: `development`, `qa`, or `production`
  - Requires manual approval before deployment

## 🏗️ Environments

### Development
- **Trigger**: Push to `develop` branch OR manual workflow dispatch
- **iOS Deploy**: TestFlight (Internal Testing)
- **Android Deploy**: Google Play Internal Track
- **Approval**: Required via GitHub Environment Protection

### QA
- **Trigger**: Manual workflow dispatch with `qa` environment
- **iOS Deploy**: TestFlight (Beta Testing)
- **Android Deploy**: Google Play Internal/Beta Track
- **Approval**: Required via GitHub Environment Protection

### Production
- **Trigger**: Manual workflow dispatch with `production` environment
- **iOS Deploy**: App Store Connect
- **Android Deploy**: Google Play Production Track
- **Approval**: **Always Required** via GitHub Environment Protection

## 🔐 Required Secrets

### GitHub Repository Secrets

Navigate to: **Settings → Secrets and variables → Actions → Repository secrets**

#### Android Secrets
```
ANDROID_SERVICE_ACCOUNT_JSON
  - Google Play Service Account JSON key
  - Used for: Upload to Play Store
  - How to get: Google Play Console → Setup → API Access
```

#### iOS Secrets
```
APPLE_ID
  - Your Apple Developer account email
  - Example: developer@company.com

APPLE_TEAM_ID
  - Your Apple Developer Team ID
  - Find at: https://developer.apple.com/account

MATCH_GIT_URL
  - Git repository URL for Fastlane Match certificates
  - Example: git@github.com:your-org/certificates.git

MATCH_PASSWORD
  - Password to decrypt Match certificates

APP_STORE_CONNECT_API_KEY_JSON
  - App Store Connect API Key (JSON format)
  - Create at: https://appstoreconnect.apple.com/access/api
```

#### Optional Secrets
```
CODECOV_TOKEN
  - For code coverage reports
  - Get from: https://codecov.io
```

## 🔧 Environment Configuration

### GitHub Environments Setup

1. Go to **Settings → Environments**
2. Create three environments:
   - `development`
   - `qa`
   - `production`

3. For each environment, configure:
   - **Protection Rules**: 
     - ✅ Required reviewers (recommended: 1+ for production)
     - ✅ Wait timer (optional, for production)
   - **Deployment branches**: 
     - Development: `develop`
     - QA: `develop`, `qa`
     - Production: `main` only

## 📦 Build Artifacts

### Android
- **Location**: `android/app/build/outputs/`
- **Files**:
  - `bundle/release/app-release.aab` - Android App Bundle (for Play Store)
  - `apk/release/app-release.apk` - APK (for testing)

### iOS
- **Location**: `ios/build/ios/`
- **Files**:
  - `release.ipa` - Production IPA
  - `dev.ipa` - Development IPA (when applicable)

## 🎯 How to Use

### 1. Running PR Validation
- Create a PR to `develop`, `qa`, or `main`
- Pipeline automatically runs validation
- Bot comments on PR with results
- Fix any issues before merging

### 2. Building for Development
**Option A: Automatic**
```bash
git push origin develop
```

**Option B: Manual**
1. Go to **Actions** tab
2. Select **Mobile App CI/CD**
3. Click **Run workflow**
4. Select: `develop` branch, `development` environment
5. Click **Run workflow**

### 3. Deploying to Development
1. Workflow builds artifacts automatically
2. Navigate to **Actions** → Running workflow
3. Click **Review deployments** when approval step appears
4. Approve **development** environment
5. Deployment proceeds automatically

### 4. Deploying to QA
1. Go to **Actions** → **Mobile App CI/CD** → **Run workflow**
2. Select: `develop` or `qa` branch, `qa` environment
3. Click **Run workflow**
4. Wait for builds to complete
5. Approve **qa** environment when prompted
6. Both Android and iOS deploy to beta tracks

### 5. Deploying to Production
1. Ensure `main` branch has tested code
2. Go to **Actions** → **Mobile App CI/CD** → **Run workflow**
3. Select: `main` branch, `production` environment
4. Click **Run workflow**
5. Wait for builds to complete
6. **Approve production environment** (requires authorized reviewer)
7. Deployment to production stores

## 🛠️ Fastlane Configuration

### Android Fastlane Lanes

```ruby
# Build debug APK
bundle exec fastlane build

# Build release AAB and APK
bundle exec fastlane build_release

# Deploy to Play Store Internal Track
bundle exec fastlane deploy_beta

# Deploy to Play Store Production
bundle exec fastlane deploy_production
```

### iOS Fastlane Lanes

```ruby
# Build debug IPA
bundle exec fastlane build

# Sync certificates (development)
bundle exec fastlane match_development

# Sync certificates (App Store)
bundle exec fastlane match_appstore

# Build + Deploy to TestFlight
bundle exec fastlane deploy_testflight

# Build + Deploy to App Store
bundle exec fastlane deploy_appstore

# Upload existing IPA to TestFlight
bundle exec fastlane upload_testflight_ipa ipa:path/to/file.ipa

# Upload existing IPA to App Store
bundle exec fastlane upload_appstore_ipa ipa:path/to/file.ipa
```

## 🔍 Troubleshooting

### Build Failures

#### "Fastlane not found"
- Ensure `Gemfile` and `Gemfile.lock` exist in `android/` and `ios/`
- Check Ruby version (3.2 required)
- Verify bundler is installing dependencies

#### "No signing identity found" (iOS)
- Check iOS secrets are configured correctly
- Verify `MATCH_GIT_URL` and `MATCH_PASSWORD`
- Ensure Match repository contains valid certificates
- Run `fastlane match` locally to verify setup

#### "Google Play API error" (Android)
- Verify `ANDROID_SERVICE_ACCOUNT_JSON` secret
- Ensure service account has correct permissions in Google Play Console
- Check package name matches in Fastlane `Appfile`

### Expo Prebuild Issues

If native folders don't exist:
```bash
# Locally generate native projects
npm run prebuild

# Clean prebuild
npm run prebuild:clean
```

The pipeline automatically runs `expo prebuild` if native folders are missing.

## 📊 Pipeline Stages Diagram

```
┌─────────────────────────────────────────────────────────┐
│                     PR or Push                           │
└─────────────────┬───────────────────────────────────────┘
                  │
                  ▼
         ┌────────────────┐
         │   Validate     │ ◄── Lint, TypeCheck, Tests
         └────────┬───────┘
                  │
         ┌────────┴────────┐
         │                 │
    ┌────▼─────┐     ┌────▼─────┐
    │  Build   │     │  Build   │
    │ Android  │     │   iOS    │
    └────┬─────┘     └────┬─────┘
         │                │
         │  ┌─────────────┘
         │  │
         ▼  ▼
    ┌─────────────┐
    │   Approval  │ ◄── Manual Gate
    │  (Dev/QA/   │
    │   Prod)     │
    └──────┬──────┘
           │
           ▼
    ┌─────────────┐
    │   Deploy    │ ◄── Play Store / App Store
    └─────────────┘
```

## 🎓 Best Practices

### Branch Strategy
- `develop` → Development builds
- `qa` → QA/Staging builds
- `main` → Production builds only

### Version Management
- Update `version` in `package.json`
- Update `versionCode`/`versionName` in `android/app/build.gradle`
- Update `CFBundleShortVersionString` and `CFBundleVersion` in `ios/Info.plist`
- Use semantic versioning: `MAJOR.MINOR.PATCH`

### Testing Before Production
1. Deploy to `development` → Test internally
2. Deploy to `qa` → QA team validates
3. Deploy to `production` → Only after QA approval

### Rollback Strategy
If production deployment fails:
1. Revert the problematic commit on `main`
2. Run production workflow with fixed code
3. Use Play Store / App Store Console to roll back if needed

## 📚 Additional Resources

- [Fastlane Documentation](https://docs.fastlane.tools/)
- [GitHub Actions Documentation](https://docs.github.com/en/actions)
- [Expo Prebuild](https://docs.expo.dev/workflow/prebuild/)
- [Google Play Console](https://play.google.com/console)
- [App Store Connect](https://appstoreconnect.apple.com/)

## 🤝 Contributing

When modifying the pipeline:
1. Test changes on a feature branch first
2. Document any new secrets or configuration
3. Update this README with changes
4. Ensure backward compatibility

## 📞 Support

For pipeline issues:
1. Check workflow logs in GitHub Actions tab
2. Review secrets configuration
3. Verify Fastlane configuration
4. Check environment protection rules

---

**Last Updated**: October 2025
**Maintained by**: DevOps Team

