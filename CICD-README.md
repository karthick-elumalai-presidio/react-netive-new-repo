# Mobile App CI/CD Pipeline

This repository contains a complete CI/CD pipeline for React Native Expo app deployment using GitHub Actions and Fastlane.

## 🚀 Features

- **Multi-environment deployment**: Development, QA, and Production
- **Cross-platform builds**: Android and iOS support
- **Fastlane integration**: Automated building and deployment
- **Expo prebuild**: Native project generation
- **Bun package manager**: Fast dependency management
- **Automated notifications**: Build status updates

## 📋 Prerequisites

### Required GitHub Secrets

Configure the following secrets in your GitHub repository settings:

#### Apple/iOS Secrets
- `APPLE_ID`: Your Apple Developer account email
- `APPLE_TEAM_ID`: Your Apple Developer Team ID
- `FASTLANE_PASSWORD`: Your Apple ID password (consider using App-Specific Password)
- `MATCH_GIT_URL`: Git repository URL for fastlane match certificates
- `MATCH_PASSWORD`: Password for fastlane match certificates repository

#### Android Secrets
- `GOOGLE_PLAY_JSON_KEY_PATH`: Path to Google Play Console service account JSON key

### Required Tools
- Bun package manager
- Ruby 3.1+ for Fastlane
- Java 17 for Android builds
- Xcode for iOS builds (macOS runners only)

## 🔧 Pipeline Configuration

### Workflow Triggers
- **Push to branches**: `develop`, `main`, `qa`
- **Manual dispatch**: With environment and platform selection

### Environments

#### Development (`develop` branch)
- Runs on Ubuntu (faster, cost-effective)
- Builds debug APKs for testing
- Uploads artifacts for 7 days

#### QA (`qa` branch)
- Runs on macOS (required for iOS builds)
- Builds release versions
- Deploys to TestFlight (iOS) and Google Play Internal Testing (Android)
- Uploads artifacts for 14 days

#### Production (`main` branch)
- Requires manual approval
- Runs on macOS
- Deploys to App Store (iOS) and Google Play Production (Android)
- Uploads artifacts for 30 days

## 🛠 Fastlane Configuration

### Android Fastlane
Located in `android/fastlane/`:
- `build_debug`: Builds debug APK
- `build_release`: Builds release APK and AAB
- `deploy_beta`: Uploads to Google Play Internal Testing
- `deploy_production`: Uploads to Google Play Production

### iOS Fastlane
Located in `ios/fastlane/`:
- `build_debug`: Builds debug version
- `match_appstore`: Syncs certificates and provisioning profiles
- `deploy_testflight`: Builds and uploads to TestFlight
- `deploy_appstore`: Builds and uploads to App Store

## 📱 Platform Support

### Android
- Builds both APK and AAB formats
- Supports debug and release configurations
- Integrates with Google Play Console
- Java 17 and Gradle builds

### iOS
- Xcode project builds
- TestFlight and App Store deployment
- Certificate and provisioning profile management via fastlane match
- Requires macOS runners for builds

## 🔄 Build Process

1. **Checkout**: Clone repository
2. **Setup Bun**: Install Bun package manager
3. **Install Dependencies**: `bun install --frozen-lockfile`
4. **Prebuild**: Generate native Android/iOS projects with `expo prebuild`
5. **Setup Ruby**: Install Ruby and Fastlane dependencies
6. **Build**: Execute platform-specific build lanes
7. **Deploy**: Upload to respective app stores (QA/Production)
8. **Upload Artifacts**: Store build outputs for download
9. **Notify**: Send build status notifications

## 🚨 Troubleshooting

### Common Issues

1. **Missing lock file error**: 
   - Ensure `bun.lock` is committed to repository
   - Pipeline now uses Bun instead of npm/yarn

2. **Certificate issues**:
   - Verify fastlane match configuration
   - Check Apple Developer account access
   - Ensure secrets are properly configured

3. **Build failures**:
   - Check platform-specific requirements (Java 17, Xcode, etc.)
   - Verify app.json configuration
   - Review Fastlane logs for specific errors

### Debug Steps

1. Check GitHub Actions logs for detailed error messages
2. Verify all required secrets are configured
3. Test Fastlane commands locally
4. Ensure app bundle identifiers match configuration

## 📚 Additional Resources

- [Expo Documentation](https://docs.expo.dev/)
- [Fastlane Documentation](https://docs.fastlane.tools/)
- [GitHub Actions Documentation](https://docs.github.com/en/actions)
- [Bun Documentation](https://bun.sh/docs)

## 🔐 Security Notes

- Never commit sensitive keys or certificates to the repository
- Use GitHub Secrets for all sensitive configuration
- Consider using App-Specific Passwords for Apple ID
- Regularly rotate API keys and certificates