# 📱 iOS Signing Setup for CI/CD

## 🔴 Current Issue

Your iOS builds are failing with:
```
git@github.com: Permission denied (publickey).
fatal: Could not read from remote repository.
```

**This is expected!** iOS signing requires additional setup beyond just adding secrets.

---

## ✅ Current Pipeline Status

- ✅ **Android builds**: WORKING (APK + AAB created)
- ⚠️ **iOS builds**: SKIPPED (signing not fully configured)
- ✅ **Pipeline**: PASSES (iOS is optional, not a failure)

---

## 🎯 iOS Signing Options

You have **3 options** to enable iOS builds in CI. Choose the one that works best for you:

### Option 1: SSH Deploy Key (Recommended for Match)

**Best for**: Teams using Fastlane Match with private GitHub repos

#### Steps:

1. **Generate SSH key pair**:
   ```bash
   ssh-keygen -t ed25519 -C "github-actions-match" -f ~/.ssh/match_deploy_key
   # Press Enter for no passphrase
   ```

2. **Add public key to Match repository**:
   - Go to your Match certificates repo (e.g., `your-org/certificates`)
   - **Settings** → **Deploy keys** → **Add deploy key**
   - Title: `GitHub Actions CI`
   - Key: Paste contents of `~/.ssh/match_deploy_key.pub`
   - ✅ Check "Allow write access" (if you need to add new certificates)
   - Click **Add key**

3. **Add private key to GitHub Actions secrets**:
   - Go to your app repo → **Settings** → **Secrets and variables** → **Actions**
   - **New repository secret**
   - Name: `MATCH_DEPLOY_KEY`
   - Value: Paste contents of `~/.ssh/match_deploy_key` (entire private key)

4. **Update workflow to use SSH key**:
   
   Add this step BEFORE the iOS build step in `.github/workflows/mobile-ci-cd.yml`:

   ```yaml
   - name: Setup SSH for Match
     if: ${{ env.HAS_IOS_SIGNING == 'true' }}
     uses: webfactory/ssh-agent@v0.9.0
     with:
       ssh-private-key: ${{ secrets.MATCH_DEPLOY_KEY }}
   ```

5. **Test it**:
   ```bash
   git add .github/workflows/mobile-ci-cd.yml
   git commit -m "ci: add SSH key for iOS Match"
   git push origin develop
   ```

---

### Option 2: HTTPS with Personal Access Token

**Best for**: Simpler setup without SSH keys

#### Steps:

1. **Create GitHub Personal Access Token**:
   - Go to **GitHub** → **Settings** → **Developer settings** → **Personal access tokens** → **Tokens (classic)**
   - Click **Generate new token (classic)**
   - Name: `Match Certificates Access`
   - Expiration: Choose appropriate duration
   - Scopes: Check `repo` (Full control of private repositories)
   - Click **Generate token**
   - **Copy the token** (you won't see it again!)

2. **Convert SSH URL to HTTPS**:
   
   If your `MATCH_GIT_URL` is:
   ```
   git@github.com:your-org/certificates.git
   ```

   Change it to:
   ```
   https://YOUR_TOKEN@github.com/your-org/certificates.git
   ```

3. **Update GitHub secret**:
   - Go to **Settings** → **Secrets and variables** → **Actions**
   - Edit `MATCH_GIT_URL`
   - New value: `https://YOUR_TOKEN@github.com/your-org/certificates.git`

4. **Test it**:
   ```bash
   git push origin develop
   ```

**Note**: With this approach, the token is embedded in the URL, so keep MATCH_GIT_URL secret!

---

### Option 3: App Store Connect API Key (No Match)

**Best for**: Don't want to use Match, prefer Xcode automatic signing

#### Steps:

1. **Create App Store Connect API Key**:
   - Go to [App Store Connect](https://appstoreconnect.apple.com)
   - **Users and Access** → **Keys** → **+** (Add)
   - Name: `GitHub Actions CI`
   - Access: **Developer** or **Admin**
   - Click **Generate**
   - **Download** the `.p8` file
   - Note the **Key ID** and **Issuer ID**

2. **Add secrets to GitHub**:
   ```
   APP_STORE_CONNECT_KEY_ID = <Key ID from above>
   APP_STORE_CONNECT_ISSUER_ID = <Issuer ID from above>
   APP_STORE_CONNECT_KEY_CONTENT = <Contents of .p8 file>
   ```

3. **Update Fastfile** to use API key instead of Match:
   
   In `ios/fastlane/Fastfile`, update `build_appstore_ipa`:

   ```ruby
   lane :build_appstore_ipa do
     if ENV['APP_STORE_CONNECT_KEY_CONTENT']
       # Use App Store Connect API authentication
       app_store_connect_api_key(
         key_id: ENV['APP_STORE_CONNECT_KEY_ID'],
         issuer_id: ENV['APP_STORE_CONNECT_ISSUER_ID'],
         key_content: ENV['APP_STORE_CONNECT_KEY_CONTENT'],
         in_house: false
       )
       
       # Use automatic signing
       update_code_signing_settings(
         use_automatic_signing: true,
         team_id: ENV['APPLE_TEAM_ID'],
         code_sign_identity: "iPhone Distribution"
       )
     end
     
     build_app(
       workspace: "CbMmobileapp.xcworkspace",
       scheme: "CbMmobileapp",
       configuration: "Release",
       export_method: "app-store",
       output_directory: "build/ios",
       output_name: "release.ipa"
     )
   end
   ```

4. **Remove Match requirements** - You won't need `MATCH_GIT_URL` anymore

---

## 📊 Comparison

| Method | Pros | Cons | Complexity |
|--------|------|------|------------|
| **SSH Deploy Key** | Most secure, works with private repos | Requires SSH setup | Medium |
| **HTTPS + Token** | Simple, no SSH | Token in URL | Easy |
| **API Key** | No Match needed, direct Apple auth | Different signing approach | Medium |

---

## 🔧 Quick Fix: Skip iOS for Now

If you want to **skip iOS builds temporarily** and focus on Android:

1. **Remove iOS secrets** from GitHub Actions (or leave them)
2. **Pipeline will pass** with iOS marked as "skipped"
3. **Android builds will work** perfectly
4. **Set up iOS later** when ready

The current configuration already handles this gracefully!

---

## ✅ What Works NOW (Without iOS Signing)

Your pipeline currently:

- ✅ Validates code (lint, typecheck, tests)
- ✅ Builds Android (APK + AAB) 
- ✅ Uploads Android artifacts
- ⚠️ Skips iOS gracefully (not a failure!)
- ✅ Allows manual deployment for Android
- ✅ Shows helpful messages about iOS setup

**This is a valid production setup!** Many teams deploy Android first, then add iOS later.

---

## 🎯 Recommended Approach

For most teams, I recommend:

1. **Start with Option 2 (HTTPS + Token)** - Easiest to set up
2. **If it doesn't work**, try Option 1 (SSH Deploy Key)
3. **If you want to avoid Match entirely**, use Option 3 (API Key)

---

## 📚 Additional Resources

- [Fastlane Match Documentation](https://docs.fastlane.tools/actions/match/)
- [GitHub Deploy Keys](https://docs.github.com/en/developers/overview/managing-deploy-keys)
- [App Store Connect API](https://developer.apple.com/documentation/appstoreconnectapi)

---

## 🆘 Still Having Issues?

### Common Problems:

**"Permission denied (publickey)"**
- ✅ Solution: Use Option 2 (HTTPS) or set up SSH deploy key (Option 1)

**"Could not read from remote repository"**
- ✅ Solution: Verify Match repository exists and is accessible
- ✅ Check: MATCH_GIT_URL is correct
- ✅ Try: HTTPS URL instead of SSH

**"No provisioning profiles found"**
- ✅ Solution: Run `fastlane match appstore` locally first to create profiles
- ✅ Check: Certificates exist in Match repository

**"Code signing error"**
- ✅ Solution: Verify APPLE_TEAM_ID is correct
- ✅ Check: App identifier matches in Xcode and Appfile

---

## 🎉 Next Steps

1. **Choose one of the 3 options above**
2. **Follow the steps for that option**
3. **Push to GitHub and test**
4. **iOS builds should work!** 🚀

Or:

1. **Skip iOS for now** (current setup works!)
2. **Deploy Android to production**
3. **Set up iOS when ready**

---

**Need help?** Open an issue or check the Fastlane documentation.

**Last Updated**: October 2025

