# CbM Mobile App

A cross-platform mobile application for the Condition-based Monitoring (CbM) platform, built with React Native and Expo. The app is designed to deliver condition monitoring and sensor management capabilities on iOS and Android devices, branded as the TDK SenSEi app.

## Overview

This mobile application provides a modern, native experience for interacting with the CbM platform. Built with cutting-edge React Native technologies, it offers seamless performance across iOS and Android platforms with a single codebase.

## Tech Stack

### Core Framework
- **React Native** (0.81.4) - Cross-platform mobile framework
- **React** (19.1.0) - UI library
- **Expo** (^54.0.0) - Development platform and toolchain
- **Expo Router** (^6.0.10) - File-based routing with typed routes

### State Management & Data Fetching
- **Zustand** (^4.5.1) - Lightweight state management
- **TanStack Query** (^5.90.2) - Powerful data synchronization and caching
- **Axios** (^1.12.2) - HTTP client for API requests

### Styling
- **NativeWind** (4.1.21) - Tailwind CSS for React Native
- **Tailwind CSS** (^3.4.0) - Utility-first CSS framework

### Internationalization
- **i18next** (^25.5.3) - i18n framework
- **react-i18next** (^16.0.0) - React bindings for i18next
- **expo-localization** (^17.0.7) - Device locale detection

### Development Tools
- **TypeScript** (~5.9.2) - Static type checking
- **ESLint** (^9.25.1) - Code linting
- **Prettier** (^3.6.2) - Code formatting
- **Husky** (^9.1.7) - Git hooks management

## Project Structure

```
CbM_mobile_app/
├── app/                    # Expo Router file-based routing
│   ├── index.tsx          # Home screen
│   ├── _layout.tsx        # Root layout with providers
│   └── +not-found.tsx     # 404 screen
├── components/            # Reusable UI components
│   └── common/
│       └── ErrorBoundary.tsx  # Error boundary component
├── services/              # External services and APIs
│   ├── api/
│   │   ├── apiService.ts  # API service layer with axios
│   │   └── apiConfig.ts   # API configuration and endpoints
│   └── storage/           # Local storage utilities
├── providers/             # React context providers
│   └── Providers.tsx      # Main providers wrapper (React Query, Error Boundary)
├── store/                 # Zustand state management stores
├── i18n/                  # Internationalization
│   ├── index.ts           # i18n configuration
│   └── locales/           # Translation files
│       ├── en/            # English translations
│       ├── ja/            # Japanese translations
│       └── zh/            # Chinese translations
├── constants/             # App-wide constants
│   └── errorCodes.ts      # API error code definitions
├── types/                 # TypeScript type definitions
│   └── api.ts             # API-related types
├── queries/               # TanStack Query hooks
├── screens/               # Screen components
├── utils/                 # Utility functions
├── assets/                # Static assets (images, fonts, etc.)
└── android/               # Android-specific native code
└── ios/                   # iOS-specific native code
```

## Features

### Current Implementation
- File-based routing with Expo Router
- Internationalization support (English, Japanese, Chinese)
- API service layer with type-safe axios wrapper
- Global error boundary with development/production modes
- State management with Zustand
- Server state management with TanStack Query
- Tailwind CSS styling with NativeWind
- TypeScript for type safety
- Code quality tools (ESLint, Prettier, Husky)

### Key Components
- **Error Boundary**: Catches and displays runtime errors gracefully
  - Development mode: Detailed error information with stack traces
  - Production mode: User-friendly error messages
- **API Service**: Centralized HTTP client with methods for GET, POST, PUT, PATCH, DELETE
- **i18n**: Automatic device language detection with fallback to English

## Getting Started

### Prerequisites
- Node.js (LTS version recommended)
- Bun (package manager) or npm/yarn
- iOS Simulator (macOS only) or Android Emulator
- Xcode (for iOS development on macOS)
- Android Studio (for Android development)

### Installation

1. Clone the repository:
```bash
git clone <repository-url>
cd CbM_mobile_app
```

2. Install dependencies:
```bash
bun install
```

3. Set up environment variables:
   - Copy `.env.local` and configure:
```bash
EXPO_PUBLIC_API_BASE_URL=https://your-api-url.com
```

### Running the App

Start the development server:
```bash
bun start
# or
npm start
```

Run on specific platforms:
```bash
bun run ios        # Run on iOS simulator
bun run android    # Run on Android emulator
bun run web        # Run in web browser
```

### Building for Production

Generate native projects:
```bash
bun run prebuild
```

## Development

### Code Quality

Format and lint code:
```bash
bun run format     # Format and fix all issues
bun run lint       # Check for linting issues
```

Git hooks are automatically set up via Husky to run formatting on staged files before commits.

### Project Configuration

- **TypeScript**: Strict mode enabled with path aliases (`@/*`)
- **Expo Config**: Configured for iOS and Android with typed routes enabled
- **ESLint**: Expo preset with Prettier integration and TanStack Query rules
- **Tailwind**: Configured for app and component directories with NativeWind preset

## API Integration

The app communicates with the CbM platform API configured via environment variables. The API service layer provides:
- Automatic request/response handling
- Configurable timeout (30 seconds default)
- TypeScript type safety for requests and responses
- Centralized error handling

Example API usage:
```typescript
import { apiService } from '@/services/api/apiService';

// GET request
const data = await apiService.get<ResponseType>('/endpoint');

// POST request
const result = await apiService.post<ResponseType>('/endpoint', { payload });
```

## Environment Configuration

Environment variables are managed through `.env.local` file:
- `EXPO_PUBLIC_API_BASE_URL`: Base URL for API requests (currently: https://dashboard-devv2.qeexo.com)

## Internationalization

The app supports multiple languages with automatic device language detection:
- English (en) - Default fallback language
- Japanese (ja)
- Chinese (zh)

Add translations in `i18n/locales/{language}/translation.json`.

Usage in components:
```typescript
import { useTranslation } from 'react-i18next';

const { t } = useTranslation();
<Text>{t('welcomeToApp')}</Text>
```

## Error Codes

Predefined error codes are available in `constants/errorCodes.ts` for handling specific API errors:
- Location, sensor, and asset management errors
- Company and department management errors
- Authentication errors
- Custom field validation errors

## Platform Support

- **iOS**: iPhone and iPad (tablet support enabled)
- **Android**: Phone and tablet
- **Web**: Progressive Web App (PWA) support via Metro bundler

### Bundle Identifiers
- iOS: `com.anonymous.CbM-mobile-app`
- Android: `com.anonymous.CbM_mobile_app`

## Contributing

1. Create a feature branch from `main`
2. Follow the existing code style and conventions
3. Write meaningful commit messages
4. Ensure all linting and formatting checks pass
5. Submit a pull request for review

## License

Proprietary - All rights reserved

## Contact

For questions or support, please contact the development team.

---

Built with React Native and Expo
# Workflow test - Wed Oct 22 17:57:48 IST 2025
