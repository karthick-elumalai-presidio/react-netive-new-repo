# ⚡ Quick Reference: iOS Credentials Setup

**For:** Technical team members  
**Full guide:** See `CUSTOMER-GUIDE-IOS-CREDENTIALS.md` for detailed steps

---

## 📋 Required Credentials

| Credential | Where to Get | Format |
|-----------|-------------|--------|
| `APPLE_ID` | Your Apple Developer account email | `email@example.com` |
| `APPLE_TEAM_ID` | https://developer.apple.com/account → Membership | `AB12CD34EF` |
| `APPLE_BUNDLE_ID` | https://developer.apple.com/account → Identifiers | `com.company.app` |
| `APPLE_APP_SPECIFIC_PASSWORD` | https://appleid.apple.com → App-Specific Passwords | `abcd-efgh-ijkl-mnop` |
| `CSC_LINK` | Export cert as .p12 → Base64 encode | Base64 string (3000+ chars) |
| `CSC_KEY_PASSWORD` | Password for .p12 file | Your chosen password |

---

## 🚀 Quick Setup Commands

### 1. Create Certificate Signing Request (CSR)
```bash
# Open Keychain Access
open -a "Keychain Access"

# Then: Keychain Access > Certificate Assistant > Request a Certificate...
# Save to disk, 2048-bit RSA
```

### 2. Create Certificate on Apple Portal
```bash
# Open browser
open "https://developer.apple.com/account/resources/certificates/list"

# 1. Click '+' to add new certificate
# 2. Select 'Apple Distribution'
# 3. Upload CSR file
# 4. Download .cer file
# 5. Double-click to install
```

### 3. Export Certificate as .p12
```bash
# In Keychain Access:
# - Find "Apple Distribution" in My Certificates
# - Right-click > Export
# - Save as .p12 with password
```

### 4. Convert to Base64
```bash
# Copy to clipboard
base64 -i ~/Desktop/ios-distribution.p12 | pbcopy

# Or save to file
base64 -i ~/Desktop/ios-distribution.p12 > ~/Desktop/cert-base64.txt
```

### 5. Create App-Specific Password
```bash
open "https://appleid.apple.com"

# 1. Sign in
# 2. Security > App-Specific Passwords
# 3. Generate new password
# 4. Label: "CI/CD Pipeline"
# 5. Copy the password
```

### 6. Get Team ID
```bash
open "https://developer.apple.com/account"

# Look for "Team ID" in Membership section
```

---

## 🔧 Add to GitHub Secrets

```bash
# Open repository settings
open "https://github.com/YOUR_USERNAME/YOUR_REPO/settings/secrets/actions"

# Add each secret:
# 1. Click "New repository secret"
# 2. Name: exact name from table above
# 3. Value: paste the credential
# 4. Click "Add secret"
```

**Required secrets:**
- `APPLE_ID`
- `APPLE_TEAM_ID`  
- `APPLE_BUNDLE_ID`
- `APPLE_APP_SPECIFIC_PASSWORD`
- `CSC_LINK`
- `CSC_KEY_PASSWORD`

---

## ✅ Verification

### Check certificates on local Mac:
```bash
# Show all signing identities
security find-identity -v -p codesigning

# Should show:
# "Apple Distribution: Your Name (TEAM_ID)"
```

### Verify .p12 file:
```bash
# Check certificate details
openssl pkcs12 -in ~/Desktop/ios-distribution.p12 -nokeys | openssl x509 -noout -subject

# Should show:
# subject=... CN=Apple Distribution: Your Name (TEAM_ID) ...
```

### Test base64 encoding:
```bash
# Encode
base64 -i ~/Desktop/ios-distribution.p12 > test.txt

# Check file size (should be 3000+ characters)
wc -c test.txt

# Decode back (test)
base64 -d -i test.txt > test.p12

# Compare
diff ~/Desktop/ios-distribution.p12 test.p12
# Should output nothing (files are identical)
```

---

## 🐛 Common Issues

### Certificate has no key icon
**Problem:** CSR created on different Mac  
**Solution:** Redo CSR + certificate on same Mac

### "No signing certificate found"
**Problem:** Wrong certificate type  
**Solution:** Use "Apple Distribution" not "Developer ID Application"

### Base64 too short
**Problem:** Only exported certificate, not private key  
**Solution:** Export as .p12 (includes private key)

### App-Specific Password doesn't work
**Problem:** Using regular Apple password  
**Solution:** Create app-specific password at appleid.apple.com

---

## 🔄 Alternative: Use Fastlane Match

### Setup Match (Recommended)
```bash
cd ios

# Initialize
bundle exec fastlane match init
# Select: git
# Enter: URL of private repo for certificates

# Generate certificates
bundle exec fastlane match appstore
# Enter: encryption password
# Enter: Apple ID
# Enter: bundle ID
```

### GitHub Secrets for Match
```bash
# Add these instead of CSC_LINK/CSC_KEY_PASSWORD:
MATCH_GIT_URL=https://github.com/your-org/certificates.git
MATCH_PASSWORD=your-encryption-password
MATCH_GIT_BASIC_AUTHORIZATION=$(echo -n "user:token" | base64)
```

---

## 📞 Support

**Detailed guide:** `CUSTOMER-GUIDE-IOS-CREDENTIALS.md`  
**Fastlane Match guide:** `SETUP-FASTLANE-MATCH.md`  
**Export certificate guide:** `EXPORT-CORRECT-CERT.md`

---

## ⏱️ Time Estimates

| Task | Time |
|------|------|
| Get Team ID | 2 min |
| Create/find Bundle ID | 3 min |
| Create certificate | 10 min |
| Export + encode | 3 min |
| App-specific password | 5 min |
| Add to GitHub | 5 min |
| **Total** | **~30 min** |

---

## 🔒 Security Checklist

- [ ] All secrets added to GitHub (not hardcoded)
- [ ] .p12 file stored in secure location (not in repo)
- [ ] App-specific password documented
- [ ] Certificate expiry date noted (12 months)
- [ ] Backup of credentials in password manager
- [ ] Access restricted to authorized team members only

---

**Quick Start:** If stuck, use `CUSTOMER-GUIDE-IOS-CREDENTIALS.md` for step-by-step instructions with screenshots references.

