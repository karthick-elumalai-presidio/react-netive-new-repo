# 🚀 Setup Fastlane Match (Automatic Certificate Management)

## ✅ Best Practice for iOS Code Signing

Fastlane Match automatically creates and syncs certificates across your team and CI/CD.

---

## 📋 Prerequisites

1. Apple Developer Account (with Admin role)
2. Private Git repository (to store encrypted certificates)
3. Your Apple ID and App-Specific Password

---

## 🔧 Setup Steps

### **Step 1: Create Private Git Repo for Certificates**

Create a **new private repository** on GitHub:
- Name: `ios-certificates` (or any name)
- Private: ✅ MUST be private!
- Don't add README

Copy the repo URL: `https://github.com/YOUR_USERNAME/ios-certificates.git`

### **Step 2: Run Fastlane Match Init**

```bash
cd /Users/karthick/react-native-fastlane-/react-netive-new-repo/ios
bundle exec fastlane match init
```

**When prompted:**
- Select: `git`
- Enter your private repo URL: `https://github.com/YOUR_USERNAME/ios-certificates.git`

### **Step 3: Generate Certificates**

```bash
# For App Store distribution
bundle exec fastlane match appstore
```

**You'll be asked:**
1. **Git repo password:** Enter your GitHub Personal Access Token
2. **Encryption password:** Create a strong password (save this!)
3. **Apple ID:** Your Apple Developer account email
4. **App ID:** `com.anonymous.CbM-mobile-app`

Match will:
- ✅ Create Apple Distribution certificate
- ✅ Create Provisioning Profile
- ✅ Encrypt and store in private repo
- ✅ Install on your Mac

### **Step 4: Update GitHub Secrets**

Add these to your repository secrets:

1. **`MATCH_GIT_URL`**
   ```
   https://github.com/YOUR_USERNAME/ios-certificates.git
   ```

2. **`MATCH_PASSWORD`**
   ```
   The encryption password you created in Step 3
   ```

3. **`MATCH_GIT_BASIC_AUTHORIZATION`**
   ```bash
   # Generate this:
   echo -n "YOUR_GITHUB_USERNAME:YOUR_GITHUB_PAT" | base64
   ```

4. Keep existing secrets:
   - `APPLE_ID`
   - `APPLE_TEAM_ID`
   - `APPLE_APP_SPECIFIC_PASSWORD`

### **Step 5: Update Fastfile**

I'll update your iOS Fastfile to use Match instead of manual certificates.

---

## ✅ Benefits

- ✅ Automatically creates certificates
- ✅ Syncs across team members
- ✅ Works in CI/CD automatically
- ✅ Handles certificate renewal
- ✅ Proper code signing every time

---

## 🎯 After Setup

Run the CI/CD pipeline - it will:
1. Clone the certificates repo
2. Decrypt certificates with `MATCH_PASSWORD`
3. Install for signing
4. Build and sign IPA automatically

---

## 📞 Troubleshooting

**Issue: "Could not create another certificate"**
- You may have reached certificate limit (2 per type)
- Use `fastlane match nuke distribution` to revoke old ones
- Then run `fastlane match appstore` again

**Issue: "Authentication failed"**
- Make sure you're using a Personal Access Token, not password
- Token needs `repo` scope

**Issue: "No valid code signing"**
- Run `fastlane match appstore --readonly` to re-download

---

## 🔐 Security Notes

- ⚠️ Keep `MATCH_PASSWORD` secret and secure
- ⚠️ Never commit certificates directly to your app repo
- ⚠️ Only store encrypted certificates in the Match repo
- ✅ Match repo should be private always

