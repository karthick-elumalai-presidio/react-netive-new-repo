# CI/CD Architecture Overview

## High-Level Architecture Diagram

```mermaid
graph TB
    subgraph "Development Workflow"
        DEV[Developer] --> PR[Pull Request]
        PR --> PR_VAL[PR Validation Workflow]
        PR_VAL --> |Pass| MERGE[Merge to Branch]
        PR_VAL --> |Fail| FIX[Fix Issues]
        FIX --> PR
    end

    subgraph "Branch Strategy"
        MERGE --> |to develop| DEV_BRANCH[develop branch]
        MERGE --> |to qa| QA_BRANCH[qa branch] 
        MERGE --> |to main| MAIN_BRANCH[main branch]
    end

    subgraph "CI/CD Pipeline"
        DEV_BRANCH --> CI_DEV[Development Build]
        QA_BRANCH --> CI_QA[QA Build & Deploy]
        MAIN_BRANCH --> CI_PROD[Production Build & Deploy]
        
        subgraph "Development Environment"
            CI_DEV --> DEV_ANDROID[Android Debug Build]
            CI_DEV --> DEV_IOS[iOS Debug Build]
            DEV_ANDROID --> DEV_ARTIFACTS[Development Artifacts]
            DEV_IOS --> DEV_ARTIFACTS
        end
        
        subgraph "QA Environment"
            CI_QA --> QA_ANDROID[Android Release Build]
            CI_QA --> QA_IOS[iOS Release Build]
            QA_ANDROID --> QA_ANDROID_DEPLOY[Deploy to Play Store Beta]
            QA_IOS --> QA_IOS_DEPLOY[Deploy to TestFlight]
        end
        
        subgraph "Production Environment"
            CI_PROD --> PROD_ANDROID[Android Production Build]
            CI_PROD --> PROD_IOS[iOS Production Build]
            PROD_ANDROID --> PROD_ANDROID_DEPLOY[Deploy to Play Store]
            PROD_IOS --> PROD_IOS_DEPLOY[Deploy to App Store]
        end
    end

    subgraph "External Services"
        PLAY_STORE[Google Play Store]
        APP_STORE[Apple App Store]
        TESTFLIGHT[TestFlight]
        CODECOV[Codecov]
        
        QA_ANDROID_DEPLOY --> PLAY_STORE
        PROD_ANDROID_DEPLOY --> PLAY_STORE
        QA_IOS_DEPLOY --> TESTFLIGHT
        PROD_IOS_DEPLOY --> APP_STORE
    end

    subgraph "Quality Gates"
        PR_VAL --> LINT[ESLint]
        PR_VAL --> FORMAT[Prettier]
        PR_VAL --> TYPESCRIPT[TypeScript Check]
        PR_VAL --> TESTS[Unit Tests]
        PR_VAL --> COVERAGE[Code Coverage]
        PR_VAL --> ANDROID_BUILD[Android Build Check]
        PR_VAL --> IOS_BUILD[iOS Build Check]
        
        COVERAGE --> CODECOV
    end

    subgraph "Build Tools & Technologies"
        BUN[Bun Runtime]
        NODE[Node.js 18]
        JAVA[Java 17]
        RUBY[Ruby 3.1]
        FASTLANE[Fastlane]
        EXPO[Expo]
        
        CI_DEV --> BUN
        CI_QA --> BUN
        CI_PROD --> BUN
        CI_DEV --> NODE
        CI_QA --> NODE
        CI_PROD --> NODE
        CI_DEV --> JAVA
        CI_QA --> JAVA
        CI_PROD --> JAVA
        CI_DEV --> RUBY
        CI_QA --> RUBY
        CI_PROD --> RUBY
        CI_DEV --> FASTLANE
        CI_QA --> FASTLANE
        CI_PROD --> FASTLANE
    end
```

## Merge Flow Diagram

```mermaid
flowchart TD
    subgraph "Branch Protection Rules"
        DEVELOP[develop branch]
        QA[qa branch]
        MAIN[main branch]
        
        DEVELOP --> |Requires PR| PR_DEV[PR to develop]
        QA --> |Requires PR| PR_QA[PR to qa]
        MAIN --> |Requires PR| PR_MAIN[PR to main]
    end

    subgraph "PR Validation Process"
        PR_DEV --> VALIDATE[PR Validation Workflow]
        PR_QA --> VALIDATE
        PR_MAIN --> VALIDATE
        
        VALIDATE --> |Quality Checks| QC[Code Quality Checks]
        QC --> LINT_CHECK[ESLint Validation]
        QC --> FORMAT_CHECK[Prettier Format Check]
        QC --> TS_CHECK[TypeScript Compilation]
        QC --> TEST_RUN[Unit Tests with Coverage]
        QC --> ANDROID_CHECK[Android Build Validation]
        QC --> IOS_CHECK[iOS Build Validation]
        
        LINT_CHECK --> |Pass| FORMAT_CHECK
        LINT_CHECK --> |Fail| REJECT[❌ Reject PR]
        FORMAT_CHECK --> |Pass| TS_CHECK
        FORMAT_CHECK --> |Fail| REJECT
        TS_CHECK --> |Pass| TEST_RUN
        TS_CHECK --> |Fail| REJECT
        TEST_RUN --> |Pass| ANDROID_CHECK
        TEST_RUN --> |Fail| REJECT
        ANDROID_CHECK --> |Pass| IOS_CHECK
        ANDROID_CHECK --> |Fail| REJECT
        IOS_CHECK --> |Pass| APPROVE[✅ Approve for Merge]
        IOS_CHECK --> |Fail| REJECT
    end

    subgraph "Merge Strategy"
        APPROVE --> |Auto-merge if enabled| AUTO_MERGE[Automatic Merge]
        APPROVE --> |Manual merge| MANUAL_MERGE[Manual Merge by Developer]
        
        AUTO_MERGE --> TRIGGER_CI[Trigger CI/CD Pipeline]
        MANUAL_MERGE --> TRIGGER_CI
    end

    subgraph "Environment Deployment"
        TRIGGER_CI --> |develop branch| DEV_DEPLOY[Development Deployment]
        TRIGGER_CI --> |qa branch| QA_DEPLOY[QA Deployment]
        TRIGGER_CI --> |main branch| PROD_DEPLOY[Production Deployment]
        
        DEV_DEPLOY --> DEV_BUILD[Build Debug APK/IPA]
        QA_DEPLOY --> QA_BUILD[Build Release & Deploy Beta]
        PROD_DEPLOY --> PROD_BUILD[Build Release & Deploy Production]
        
        DEV_BUILD --> DEV_ARTIFACTS[Upload Development Artifacts]
        QA_BUILD --> QA_STORES[Deploy to TestFlight & Play Store Beta]
        PROD_BUILD --> PROD_STORES[Deploy to App Store & Play Store]
    end

    subgraph "Manual Workflow Dispatch"
        MANUAL[Manual Trigger] --> ENV_SELECT[Select Environment]
        ENV_SELECT --> |development| DEV_DEPLOY
        ENV_SELECT --> |qa| QA_DEPLOY
        ENV_SELECT --> |production| PROD_DEPLOY
        
        MANUAL --> PLATFORM_SELECT[Select Platform]
        PLATFORM_SELECT --> |ios| IOS_ONLY[iOS Only Build]
        PLATFORM_SELECT --> |android| ANDROID_ONLY[Android Only Build]
        PLATFORM_SELECT --> |all| ALL_PLATFORMS[All Platforms Build]
    end

    REJECT --> FEEDBACK[PR Comment with Results]
    FEEDBACK --> FIX[Developer Fixes Issues]
    FIX --> PR_DEV
```

## Key Architecture Components

### 1. PR Validation Workflow (`pr-validation.yml`)
- **Trigger**: Pull requests to `develop`, `main`, or `qa` branches
- **Purpose**: Quality gate before code merge
- **Validations**:
  - Code quality (ESLint, Prettier, TypeScript)
  - Unit tests with coverage reporting
  - Android build validation
  - iOS build validation (limited on Ubuntu)
  - Automatic PR commenting with results

### 2. Mobile CI/CD Workflow (`mobile-ci-cd.yml`)
- **Trigger**: Push to branches or manual workflow dispatch
- **Environments**:
  - **Development** (`develop` branch): Debug builds, artifact uploads
  - **QA** (`qa` branch): Release builds, beta deployments
  - **Production** (`main` branch): Production builds, store deployments

### 3. Build Technology Stack
- **Runtime**: Bun (primary), Node.js 18
- **Mobile**: React Native with Expo
- **Build Tools**: Fastlane for iOS/Android automation
- **Languages**: Java 17 (Android), Ruby 3.1 (Fastlane)
- **Package Management**: npm/bun for dependencies

### 4. Deployment Strategy
- **Development**: Debug builds, local artifact storage
- **QA**: Beta releases to TestFlight (iOS) and Play Store Beta (Android)
- **Production**: Full releases to App Store (iOS) and Play Store (Android)

### 5. Quality Assurance
- **Automated**: ESLint, Prettier, TypeScript, unit tests
- **Coverage**: Codecov integration for test coverage tracking
- **Build Validation**: Cross-platform build verification
- **Manual Gates**: Production deployments require manual approval

### 6. Artifact Management
- **Development**: 7-day retention for debug builds
- **QA**: 14-day retention for beta builds
- **Production**: 30-day retention for release builds

This architecture provides a robust, multi-environment CI/CD pipeline with comprehensive quality gates and automated deployment capabilities for React Native mobile applications.
