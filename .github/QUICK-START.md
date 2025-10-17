# 🚀 Quick Start - CI/CD Pipeline

## ⚡ 5-Minute Setup

### Step 1: Configure GitHub Secrets

Go to **Settings → Secrets and variables → Actions**

#### Android (Minimum Required)
```
ANDROID_SERVICE_ACCOUNT_JSON = <your-google-play-service-account-json>
```

#### iOS (Optional, for iOS builds)
```
APPLE_ID = developer@example.com
APPLE_TEAM_ID = XXXXXXXXXX
MATCH_GIT_URL = git@github.com:your-org/certificates.git
MATCH_PASSWORD = your-match-password
APP_STORE_CONNECT_API_KEY_JSON = <your-api-key-json>
```

### Step 2: Create GitHub Environments

Go to **Settings → Environments** and create:
- ✅ `development`
- ✅ `qa`
- ✅ `production`

For each environment, enable **Required reviewers** (especially for production).

### Step 3: Push Code
```bash
git add .
git commit -m "ci: setup GitHub Actions pipeline"
git push origin develop
```

### Step 4: Monitor Pipeline
1. Go to **Actions** tab
2. Watch your pipeline run automatically
3. Builds will create artifacts

### Step 5: Deploy (Manual)
1. **Actions** → **Mobile App CI/CD** → **Run workflow**
2. Select environment (`development`, `qa`, or `production`)
3. Approve when prompted
4. App deploys automatically! 🎉

---

## 📱 Common Commands

### Local Fastlane Commands

#### Android
```bash
cd android
bundle install
bundle exec fastlane build              # Debug build
bundle exec fastlane build_release      # Release build
```

#### iOS
```bash
cd ios
bundle install
bundle exec fastlane build              # Debug build
bundle exec fastlane match_development  # Sync certificates
bundle exec fastlane deploy_testflight  # TestFlight
```

### Expo Commands
```bash
npm run prebuild         # Generate native folders
npm run prebuild:clean   # Clean rebuild
```

---

## 🔥 Quick Troubleshooting

| Issue | Solution |
|-------|----------|
| Fastlane not found | Check `Gemfile.lock` exists in `android/` and `ios/` |
| No signing identity | Verify iOS secrets (MATCH_GIT_URL, MATCH_PASSWORD) |
| Google Play API error | Check ANDROID_SERVICE_ACCOUNT_JSON secret |
| Build fails on missing files | Run `npm run prebuild` locally first |
| Deployment needs approval | Go to Actions → workflow → "Review deployments" |

---

## 📖 Full Documentation

See [CICD-SETUP.md](./CICD-SETUP.md) for complete documentation.

---

## ✅ What's Included

- ✅ Automated PR validation
- ✅ Lint, TypeScript, Prettier checks
- ✅ Android builds (APK + AAB)
- ✅ iOS builds (IPA)
- ✅ Multi-environment deployments (dev/qa/prod)
- ✅ Manual approval gates
- ✅ Artifact uploads
- ✅ Auto-deployment to stores
- ✅ Expo prebuild support (with Fastlane config preservation!)
- ✅ Fastlane integration
- ✅ Graceful handling of missing iOS secrets
- ✅ Production-ready pipeline

## 🆕 Latest Fixes (Oct 2025)

- ✅ **Expo prebuild now works perfectly** - Native folders generated automatically
- ✅ **Custom Fastlane configs preserved** - Backup/restore pattern implemented
- ✅ **iOS builds handle missing secrets** - Shows warnings instead of failing
- ✅ **Android gradlew issue fixed** - Prebuild runs when needed
- ✅ **All builds working** - Android ✓ iOS ✓ Deployments ✓

---

**Need Help?** Check the [full setup guide](./CICD-SETUP.md) or workflow logs in the Actions tab.

