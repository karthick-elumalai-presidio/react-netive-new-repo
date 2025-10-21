# 🔐 Export Correct iOS Distribution Certificate

## ❌ Current Problem

Your `CSC_LINK` contains a **"Developer ID Application"** certificate.
You need an **"Apple Distribution"** certificate for App Store builds.

---

## ✅ Solution: Export Apple Distribution Certificate

### **Step 1: Open Keychain Access on your Mac**

1. Open **Keychain Access** app (Spotlight → "Keychain Access")
2. Make sure you're viewing **"login"** keychain (top left)
3. Click **"Certificates"** category (bottom left)

### **Step 2: Find the RIGHT Certificate**

Look for one of these names:
- **"Apple Distribution: YOUR NAME (TEAM_ID)"**
- **"iOS Distribution: YOUR NAME"**

**❌ DON'T use:**
- "Apple Development" (wrong - for local testing)
- "Developer ID Application" (wrong - for Mac apps)
- "Mac Distribution" (wrong - for Mac App Store)

### **Step 3: Export the Certificate**

1. Right-click on **"Apple Distribution"** certificate
2. Select **"Export"**
3. Choose location and name (e.g., `ios-distribution.p12`)
4. **Set a strong password** (you'll need this!)
5. Click **Save**
6. Enter your Mac password to allow export

### **Step 4: Convert to Base64**

Open Terminal and run:

```bash
# Replace with your actual file path
base64 -i ~/Downloads/ios-distribution.p12 | pbcopy
```

This copies the base64 string to your clipboard.

### **Step 5: Update GitHub Secret**

1. Go to: https://github.com/karthick-elumalai-presidio/react-netive-new-repo/settings/secrets/actions
2. Click on **`CSC_LINK`**
3. Click **"Update"**
4. **Paste** the base64 string (from clipboard)
5. Click **"Update secret"**

6. Also update **`CSC_KEY_PASSWORD`**:
   - Click on it
   - Update with the password you set in Step 3
   - Save

---

## 🚨 What if You Don't Have This Certificate?

### **Scenario 1: You don't see "Apple Distribution" in Keychain**

You need to create one in Apple Developer Portal:

1. Go to: https://developer.apple.com/account/resources/certificates/list
2. Click **"+"** to create new certificate
3. Select **"Apple Distribution"**
4. Follow the instructions to create a Certificate Signing Request (CSR)
5. Upload CSR
6. Download the certificate (.cer file)
7. Double-click to install in Keychain
8. Then follow export steps above

### **Scenario 2: Someone else manages certificates**

Ask your team's Apple Developer admin to:
1. Export the Apple Distribution certificate as .p12
2. Provide the .p12 file and its password to you
3. Follow Step 4 & 5 above

---

## ⚡ Alternative: Use Fastlane Match (Recommended for Teams)

If you have multiple team members or want proper certificate management:

```bash
cd ios
bundle exec fastlane match init
bundle exec fastlane match appstore
```

Then add these GitHub secrets:
- `MATCH_GIT_URL` - Private git repo URL for certificates
- `MATCH_PASSWORD` - Encryption password

This automatically syncs certificates across your team and CI/CD.

---

## 🎯 After Updating Certificate

1. Go to: https://github.com/karthick-elumalai-presidio/react-netive-new-repo/actions
2. Click **"Actions"** tab
3. Click **"Mobile CI/CD"** workflow (left sidebar)
4. Click **"Run workflow"** (right side)
5. Select branch: **develop**
6. Click **"Run workflow"**

The iOS build should succeed! 🚀

---

## ✅ How to Verify You Have the Right Certificate

After export, check it:

```bash
# Replace with your .p12 path
openssl pkcs12 -in ~/Downloads/ios-distribution.p12 -nokeys | openssl x509 -noout -subject
```

**✅ Good output:**
```
subject=UID=..., CN=Apple Distribution: Your Name (TEAMID), OU=TEAMID, O=Your Name, C=US
```

**❌ Bad output (current):**
```
subject=... CN=Developer ID Application: ...
```

---

## 📞 Need Help?

If you can't find or create the certificate, you may need to:
1. Contact your Apple Developer Program admin
2. Verify you have "Admin" or "App Manager" role in App Store Connect
3. Ensure your Apple Developer subscription is active

