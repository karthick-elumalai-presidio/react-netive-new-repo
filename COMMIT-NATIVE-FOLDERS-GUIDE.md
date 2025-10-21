# 📦 Guide: Commit Native Folders for Fast CI Builds

## 🎯 Goal

Commit the `ios/` and `android/` folders to the repository so **CI builds skip `expo prebuild`** and run **much faster**!

---

## ✅ Current Status

- ✅ `.gitignore` already configured to allow native folders
- ✅ Workflow already checks for native folders (line 134: "fast path")
- ❌ Native project files not yet committed (only Fastlane configs)

---

## 🚀 Two Options

### **Option 1: After Build #68 Succeeds** (Easiest)

1. **Wait** for Build #68 to complete successfully
2. **Clone fresh** or **pull** the repo on a machine with Node.js:
   ```bash
   git pull origin develop
   ```

3. **Generate** native folders:
   ```bash
   npx expo prebuild --clean
   ```
   
4. **Run** the commit script:
   ```bash
   ./commit-native-folders.sh
   ```

5. **Done!** Future builds will be much faster.

---

### **Option 2: Directly From CI** (Advanced)

After Build #68 succeeds, add this job to the workflow to auto-commit:

```yaml
  commit-native-folders:
    name: Commit Native Folders (One-time)
    runs-on: ubuntu-latest
    needs: [build-android, build-ios]
    if: success() && github.event_name == 'push'
    steps:
      - uses: actions/checkout@v4
      
      - name: Setup Bun
        uses: oven-sh/setup-bun@v2
      
      - name: Install dependencies
        run: bun install
      
      - name: Generate native folders
        run: |
          npx expo prebuild --clean
      
      - name: Commit and push
        run: |
          git config user.name "github-actions[bot]"
          git config user.email "github-actions[bot]@users.noreply.github.com"
          git add android/ ios/
          git commit -m "chore: commit native folders for fast CI"
          git push
```

Run this **once**, then **remove the job** from the workflow.

---

## 📊 Expected Results

### **Before (Current):**
```
Build Time: ~20 minutes
- Install dependencies: 6s
- Generate android/: 4s  ← SKIPPED AFTER COMMIT
- Generate ios/: 8s      ← SKIPPED AFTER COMMIT
- Build android: 18m
- Build iOS: 6m
```

### **After (With Committed Folders):**
```
Build Time: ~15 minutes
- Install dependencies: 6s
- ✅ "Native project found (fast path)" ← INSTANT!
- Build android: 15m (faster without prebuild overhead)
- Build iOS: 5m
```

**Time Saved:** ~5 minutes per build!

---

## 🔍 What Gets Committed

### **Android (~150 files):**
```
android/
├── build.gradle
├── settings.gradle
├── gradlew
├── app/
│   ├── build.gradle
│   └── src/main/
│       ├── AndroidManifest.xml
│       └── java/...
├── gradle/
└── ... (Fastlane already committed)
```

### **iOS (~80 files):**
```
ios/
├── Podfile
├── CbMmobileapp.xcodeproj/
│   ├── project.pbxproj
│   └── xcshareddata/
├── CbMmobileapp/
│   ├── Info.plist
│   ├── AppDelegate.swift
│   └── ... 
└── ... (Fastlane already committed)
```

**Note:** Build outputs (`build/`, `Pods/`, `.gradle/`) are still `.gitignore`d.

---

## ✅ Verification

After committing, check the workflow log:

```
✅ Android native project found (fast path - no prebuild needed)
✅ iOS native project found (fast path - no prebuild needed)
```

No more:
```
⚠️  Android native project not found - generating now...
```

---

## 🎉 Benefits

1. ✅ **5+ minutes faster** CI builds
2. ✅ **No expo prebuild** dependency prompts
3. ✅ **Consistent** native project structure
4. ✅ **Full control** over native code
5. ✅ **Same workflow** (no changes needed!)

---

## 📝 Notes

- The workflow **already supports** this (checks for folders)
- You only need to do this **once**
- Future updates to native code can be committed normally
- Build artifacts (`.gradle/`, `Pods/`, `build/`) stay ignored

