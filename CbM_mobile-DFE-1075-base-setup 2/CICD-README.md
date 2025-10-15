# CI/CD and Fastlane Setup for CbM Mobile

This document provides an overview of the CI/CD pipeline and fastlane setup for the CbM Mobile application.

## Table of Contents

- [Fastlane Setup](#fastlane-setup)
  - [Android](#android-fastlane)
  - [iOS](#ios-fastlane)
- [CI/CD Pipelines](#cicd-pipelines)
  - [GitHub Actions](#github-actions)
  - [Azure Pipelines](#azure-pipelines)
- [Environment Configuration](#environment-configuration)
- [Required Secrets](#required-secrets)

## Fastlane Setup

### Android Fastlane

The Android fastlane configuration is located in the `android/fastlane` directory and includes the following lanes:

- `test`: Run unit tests
- `build`: Build debug APK
- `build_release`: Build release APK
- `build_aab`: Build Android App Bundle for Google Play
- `deploy_internal`: Deploy to Google Play internal testing track
- `deploy_beta`: Deploy to Google Play beta track
- `deploy_production`: Deploy to Google Play production track
- `increment_version`: Increment version code

#### Usage

```bash
cd android
bundle install
bundle exec fastlane [lane_name]
```

### iOS Fastlane

The iOS fastlane configuration is located in the `ios/fastlane` directory and includes the following lanes:

- `test`: Run unit tests
- `build`: Build development IPA
- `build_release`: Build release IPA
- `deploy_testflight`: Deploy to TestFlight
- `deploy_appstore`: Deploy to App Store
- `increment_version`: Increment version number and build number
- `match_development`: Sync development certificates
- `match_appstore`: Sync App Store certificates

#### Usage

```bash
cd ios
bundle install
bundle exec fastlane [lane_name]
```

## CI/CD Pipelines

### GitHub Actions

The GitHub Actions workflows are located in the `.github/workflows` directory:

1. **PR Validation (`pr-validation.yml`)**: Runs on pull requests to validate code quality, run tests, and check builds.
2. **Mobile CI/CD (`mobile-ci-cd.yml`)**: Handles building and deploying the app to different environments.

#### Environments

- **Development**: Triggered on pushes to the `develop` branch or manually with the `development` environment.
- **QA**: Triggered on pushes to the `qa` branch or manually with the `qa` environment.
- **Production**: Triggered on pushes to the `main` branch or manually with the `production` environment. Requires manual approval.

#### Manual Workflow Dispatch

You can manually trigger the CI/CD workflow with specific parameters:

1. Go to the Actions tab in GitHub
2. Select "Mobile App CI/CD" workflow
3. Click "Run workflow"
4. Choose the environment and platform
5. Click "Run workflow"

### Azure Pipelines

The Azure Pipelines configuration is located in the `azure-pipelines.yml` file and follows a similar structure to the GitHub Actions workflows.

#### Stages

- **PR Validation**: Runs on pull requests to validate code quality, run tests, and check builds.
- **Development**: Builds the app for the development environment.
- **QA**: Builds and deploys the app to the QA environment.
- **Production**: Builds and deploys the app to the production environment. Requires manual approval.

## Environment Configuration

Environment-specific variables are stored in `.env.*` files in the `android/fastlane` and `ios/fastlane` directories:

- `.env.default`: Default environment variables
- `.env.development`: Development-specific variables
- `.env.qa`: QA-specific variables
- `.env.production`: Production-specific variables

## Required Secrets

The following secrets need to be configured in your CI/CD environment:

### Android

- `GOOGLE_PLAY_JSON_KEY_PATH`: Path to the Google Play service account JSON key file

### iOS

- `APPLE_ID`: Apple ID email
- `APPLE_TEAM_ID`: Apple Developer Team ID
- `MATCH_GIT_URL`: Git URL for match certificate repository
- `MATCH_PASSWORD`: Password for match certificate encryption
- `FASTLANE_PASSWORD`: App-specific password for Apple ID

### General

- `CODECOV_TOKEN`: Token for uploading code coverage to Codecov (optional)
