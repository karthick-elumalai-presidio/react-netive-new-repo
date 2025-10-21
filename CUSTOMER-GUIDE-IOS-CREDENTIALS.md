# 📱 Complete Guide: How to Get iOS Code Signing Credentials

**For:** Customer/Stakeholder  
**Purpose:** Obtain all required credentials to build iOS app in CI/CD  
**Time Required:** 30-45 minutes  
**Prerequisites:** Apple Developer Program membership ($99/year)

---

## 📋 Overview: What You'll Get

By following this guide, you'll obtain:

1. ✅ **Apple Distribution Certificate** (.p12 file)
2. ✅ **Certificate Password** (you create this)
3. ✅ **Apple ID** (email)
4. ✅ **Apple Team ID** (10-character code)
5. ✅ **App-Specific Password** (for automation)
6. ✅ **Bundle ID** (app identifier)

---

## 🚀 PART 1: Get Your Apple Team ID

**Time:** 2 minutes

### Step 1.1: Log in to Apple Developer
1. Open your web browser
2. Go to: **https://developer.apple.com/account**
3. Click **"Sign In"** (top right)
4. Enter your **Apple ID** and **password**
5. Complete 2-factor authentication if prompted

### Step 1.2: Find Your Team ID
1. After logging in, you'll see your account page
2. Look for **"Membership"** section (usually on the right side)
3. Find **"Team ID"**: It's a 10-character code like `AB12CD34EF`
4. **Copy this Team ID** and save it

**📝 Save this as: `APPLE_TEAM_ID`**

**Screenshot reference:** You should see something like:
```
Team Name: Your Company Name
Team ID: AB12CD34EF
```

---

## 🎯 PART 2: Get Your Bundle ID

**Time:** 3 minutes

### Step 2.1: Go to App IDs
1. Still on **https://developer.apple.com/account**
2. Click **"Certificates, Identifiers & Profiles"** (left menu)
3. Click **"Identifiers"** (left menu)
4. You'll see a list of App IDs

### Step 2.2: Find or Create Your App ID

**Option A: App ID Already Exists**
1. Look through the list for your app
2. Click on it
3. Copy the **"Bundle ID"** (looks like `com.company.appname`)
4. **Save this Bundle ID**

**Option B: Create New App ID**
1. Click **"+"** button (top left, near "Identifiers")
2. Select **"App IDs"** → Click **"Continue"**
3. Select **"App"** → Click **"Continue"**
4. Fill in:
   - **Description**: Your app name (e.g., "My Awesome App")
   - **Bundle ID**: Select "Explicit"
   - **Bundle ID value**: Enter reverse domain format
     - Example: `com.yourcompany.yourapp`
     - Use only letters, numbers, hyphens, periods
     - Must be unique (can't use someone else's domain)
5. **Capabilities**: Leave defaults or select what your app needs
6. Click **"Continue"**
7. Click **"Register"**
8. **Copy and save the Bundle ID you just created**

**📝 Save this as: `APPLE_BUNDLE_ID`**

**Example Bundle IDs:**
- ✅ Good: `com.acmecorp.myshopping`, `com.johnsmith.calculator`
- ❌ Bad: `my app`, `com.apple.something`, `test123`

---

## 🔐 PART 3: Create Apple Distribution Certificate

**Time:** 10-15 minutes

### Step 3.1: Create Certificate Signing Request (CSR)

**On your Mac:**

1. Open **"Keychain Access"** app
   - Press `Cmd + Space`
   - Type "Keychain Access"
   - Press Enter

2. In Keychain Access menu bar:
   - Click **"Keychain Access"** → **"Certificate Assistant"** → **"Request a Certificate From a Certificate Authority..."**

3. In the popup window:
   - **User Email Address**: Enter your email (Apple ID email)
   - **Common Name**: Enter your name or company name
   - **CA Email Address**: Leave blank
   - **Request is**: Select **"Saved to disk"**
   - Check **"Let me specify key pair information"**
   - Click **"Continue"**

4. Key Pair Information:
   - **Key Size**: Select **2048 bits**
   - **Algorithm**: Select **RSA**
   - Click **"Continue"**

5. Save the file:
   - Name it: `CertificateSigningRequest.certSigningRequest`
   - Save to Desktop (easy to find)
   - Click **"Save"**

**✅ You now have:** `CertificateSigningRequest.certSigningRequest` on your Desktop

### Step 3.2: Create Certificate on Apple Developer Portal

**In your web browser:**

1. Go to: **https://developer.apple.com/account/resources/certificates/list**
2. Click **"+"** button (top left, near "Certificates")
3. Under **"Software"** section, select:
   - **"Apple Distribution"** (for App Store and TestFlight)
4. Click **"Continue"**
5. Click **"Choose File"**
6. Select the `CertificateSigningRequest.certSigningRequest` file from your Desktop
7. Click **"Continue"**
8. Wait a few seconds for processing
9. Click **"Download"**
10. A file named `distribution.cer` will download

**✅ You now have:** `distribution.cer` in your Downloads folder

### Step 3.3: Install Certificate in Keychain

**On your Mac:**

1. Go to your Downloads folder
2. **Double-click** on `distribution.cer`
3. Keychain Access will open automatically
4. The certificate is now installed

**Verify it's installed:**
1. In Keychain Access:
   - Select **"login"** keychain (top left)
   - Select **"My Certificates"** category (bottom left)
2. Look for a certificate named:
   - **"Apple Distribution: Your Name (TEAM_ID)"**
   - It should have a **small key icon** next to it (this is important!)

**⚠️ Important:** If you don't see the small key icon, the certificate is incomplete. You need to redo Step 3.1 on the same Mac.

### Step 3.4: Export Certificate as .p12

**On your Mac:**

1. In Keychain Access:
   - Still in **"My Certificates"** category
   - Find **"Apple Distribution: Your Name"**

2. **Right-click** on the certificate
3. Select **"Export 'Apple Distribution: Your Name...'"**

4. In the save dialog:
   - **Save As**: Name it `ios-distribution.p12`
   - **Where**: Save to Desktop
   - **File Format**: Must be **"Personal Information Exchange (.p12)"**
   - Click **"Save"**

5. **Create a password** popup appears:
   - Enter a strong password (e.g., `MySecurePass123!`)
   - **⚠️ IMPORTANT:** Remember this password! Write it down!
   - Re-enter the password to confirm
   - Click **"OK"**

6. Enter your **Mac login password** when prompted
   - This allows Keychain to export the certificate
   - Click **"Allow"**

**✅ You now have:** `ios-distribution.p12` on your Desktop

**📝 Save the password as: `CSC_KEY_PASSWORD`**

### Step 3.5: Convert Certificate to Base64

**On your Mac, open Terminal:**

1. Press `Cmd + Space`
2. Type "Terminal"
3. Press Enter

4. In Terminal, run this command:
```bash
base64 -i ~/Desktop/ios-distribution.p12 | pbcopy
```

5. Press **Enter**
6. You'll see no output - that's normal!
7. The base64 string is now **copied to your clipboard**

**📝 This clipboard content is: `CSC_LINK`**

**⚠️ Important:** 
- This is a VERY long string (thousands of characters)
- Don't try to view it - just paste it directly when needed
- Don't accidentally copy something else before pasting!

---

## 🔑 PART 4: Create App-Specific Password

**Time:** 5 minutes

This is needed for automation/CI/CD to access your Apple account securely.

### Step 4.1: Go to Apple ID Account

1. Open browser
2. Go to: **https://appleid.apple.com**
3. Click **"Sign In"**
4. Enter your **Apple ID** and **password**
5. Complete 2-factor authentication

### Step 4.2: Generate App-Specific Password

1. Find **"Sign-In and Security"** section
2. Click **"App-Specific Passwords"**
3. Click **"+"** or **"Generate Password..."**
4. Enter a label name:
   - Example: `CI/CD Pipeline` or `GitHub Actions`
5. Click **"Create"**
6. A password appears like: `abcd-efgh-ijkl-mnop`
7. **Copy this password immediately**
8. Click **"Done"**

**⚠️ Important:** 
- You can only see this password ONCE
- If you lose it, you must create a new one
- Save it securely

**📝 Save this as: `APPLE_APP_SPECIFIC_PASSWORD`**

---

## 📧 PART 5: Confirm Your Apple ID

**Time:** 1 minute

This is simply your Apple Developer account email.

**Example:** `john.doe@company.com`

**📝 Save this as: `APPLE_ID`**

---

## 📦 PART 6: Summary - What to Provide

Please provide the following to your development team:

### Required Credentials:

1. **`APPLE_ID`**
   - Format: Email address
   - Example: `john.doe@company.com`
   - How to get: Your Apple Developer account email

2. **`APPLE_TEAM_ID`**
   - Format: 10-character code
   - Example: `AB12CD34EF`
   - How to get: Part 1

3. **`APPLE_APP_SPECIFIC_PASSWORD`**
   - Format: 19-character code with hyphens
   - Example: `abcd-efgh-ijkl-mnop`
   - How to get: Part 4

4. **`APPLE_BUNDLE_ID`**
   - Format: Reverse domain format
   - Example: `com.company.appname`
   - How to get: Part 2

5. **`CSC_LINK`**
   - Format: Very long base64 string (3000+ characters)
   - Example: `MIIKxQIBAzCCCn8GCSqGSIb3DQEHAaCCCnAEggpsM...` (much longer)
   - How to get: Part 3.5 (in your clipboard after running command)

6. **`CSC_KEY_PASSWORD`**
   - Format: Whatever password you created
   - Example: `MySecurePass123!`
   - How to get: Part 3.4 (the password you typed)

---

## ✉️ How to Send These Credentials Securely

**❌ DON'T:**
- Send via regular email (not secure)
- Put in Slack or Teams messages
- Save in unencrypted files
- Share in public GitHub issues

**✅ DO:**
- Use password manager (1Password, LastPass, Bitwarden)
- Use encrypted messaging (Signal, ProtonMail)
- Share in-person or via video call for verbal confirmation
- Use your company's secure credential sharing system

**Recommended Method:**
1. Save all credentials in a password manager
2. Share the password manager vault with your dev team
3. Or, add directly to GitHub Secrets yourself (see Part 7)

---

## 🔒 PART 7: Adding to GitHub Secrets (Optional)

If you have access to the GitHub repository, you can add these yourself:

### Step 7.1: Go to Repository Settings

1. Go to your GitHub repository
2. Click **"Settings"** tab (top)
3. Click **"Secrets and variables"** (left menu)
4. Click **"Actions"**
5. Click **"New repository secret"** (green button)

### Step 7.2: Add Each Secret

For each credential, repeat:

1. Click **"New repository secret"**
2. **Name**: Enter the exact name (e.g., `APPLE_ID`)
3. **Secret**: Paste the value
4. Click **"Add secret"**

**Add these 6 secrets:**

| Secret Name | Value |
|------------|-------|
| `APPLE_ID` | Your Apple Developer email |
| `APPLE_TEAM_ID` | 10-character Team ID |
| `APPLE_APP_SPECIFIC_PASSWORD` | App-specific password from appleid.apple.com |
| `APPLE_BUNDLE_ID` | Your app's bundle identifier |
| `CSC_LINK` | Base64 certificate (from clipboard) |
| `CSC_KEY_PASSWORD` | Password you created for .p12 file |

---

## ❓ Troubleshooting

### "I don't have Apple Developer Program membership"

**Solution:** 
- Enroll at: https://developer.apple.com/programs/enroll/
- Cost: $99/year
- Approval takes 1-2 business days

### "I can't see Certificate Signing Request option in Keychain"

**Solution:**
- Make sure you're using macOS
- Try restarting Keychain Access app
- Use Keychain Access menu bar (not right-click)

### "Certificate has no key icon in Keychain"

**Solution:**
- You must create CSR and certificate on the SAME Mac
- Delete the certificate from Keychain
- Redo Part 3 from the beginning on the Mac you'll export from

### "I lost the App-Specific Password"

**Solution:**
- You can't recover it
- Go back to https://appleid.apple.com
- Delete the old one
- Create a new one

### "Base64 command doesn't work"

**Solution:**
```bash
# Try with full path
base64 -i ~/Desktop/ios-distribution.p12 > ~/Desktop/cert-base64.txt

# Then open the file
open ~/Desktop/cert-base64.txt

# Copy the entire content manually
```

### "I have multiple Apple Developer accounts"

**Solution:**
- Use the account that owns the app
- Check which account has the app in App Store Connect
- Use that account's credentials

---

## ✅ Verification Checklist

Before sending credentials, verify:

- [ ] `APPLE_ID` is a valid email address
- [ ] `APPLE_TEAM_ID` is exactly 10 characters
- [ ] `APPLE_APP_SPECIFIC_PASSWORD` has 4 groups of 4 letters separated by hyphens
- [ ] `APPLE_BUNDLE_ID` uses reverse domain format (com.company.app)
- [ ] `CSC_LINK` is a very long string (3000+ characters)
- [ ] `CSC_KEY_PASSWORD` is the password you remember creating
- [ ] Certificate in Keychain has a key icon
- [ ] You've saved the .p12 file as backup

---

## 🎯 Next Steps

After providing these credentials:

1. ✅ Development team will add them to GitHub Secrets
2. ✅ CI/CD pipeline will be configured to use them
3. ✅ iOS builds will run automatically
4. ✅ App will be signed and ready for TestFlight/App Store

**Expected timeline:**
- Setup: 1 hour
- First successful build: 15-20 minutes
- Subsequent builds: 10-15 minutes each

---

## 📞 Need Help?

If you get stuck:

1. Take a screenshot of the error/step
2. Note which Part and Step number you're on
3. Contact your development team
4. They can help troubleshoot or do these steps with you via screen share

---

## 🔒 Security Reminders

- ⚠️ Keep these credentials secure and private
- ⚠️ Don't share them publicly or commit to code
- ⚠️ Rotate App-Specific Password every 6-12 months
- ⚠️ Certificate expires after 1 year - you'll need to renew
- ✅ Store backups in secure password manager
- ✅ Document who has access to these credentials

---

## 📅 Maintenance

**Every 12 months:**
- Apple Distribution Certificate expires
- You'll need to create a new one (repeat Part 3)
- Update `CSC_LINK` and `CSC_KEY_PASSWORD` secrets

**Set a reminder for:** (Today's date + 11 months)

---

**Document Version:** 1.0  
**Last Updated:** October 2025  
**Compatibility:** iOS 17+, Xcode 15+, macOS 14+

