# Hushh App Build & Deployment Commands

## Development Commands

### Run App
```bash
# Run user app in development mode
flutter run -t lib/user.dart --dart-define-from-file=env/prod.json --flavor user
```

## Build Commands

### Android Builds
```bash
# Build Android APK (Release)
flutter build apk --release \
    --dart-define-from-file=env/prod.json \
    --build-number=32 \
    --build-name=1.0.1

# Build Android App Bundle (Release)
flutter build appbundle --release \
    --dart-define-from-file=env/prod.json \
    --build-number=32 \
    --build-name=1.0.1
```

### iOS Build
```bash
# Build iOS IPA
flutter build ipa \
    --dart-define-from-file=env/prod.json \
    --build-number=32 \
    --build-name=1.0.1 \
    -t lib/user.dart
```

### Web Build & Deploy
```bash
# Build and deploy web version
flutter build web --web-renderer html \
    --dart-define-from-file=env/prod.json \
    -t lib/agent.dart
firebase deploy
```

## Keystore Management

### View Keystore Information
```bash
# View production keystore details
keytool -list -v -keystore hushh-keystore.jks -alias upload

# View debug keystore details
keytool -list -v \
    -keystore ~/.android/debug.keystore \
    -alias androiddebugkey \
    -storepass android \
    -keypass android
```

## Code Generation

### Run Build Runner
```bash
# Generate code using build_runner
flutter pub run build_runner build
```

## Universal Build Script

### Using build_app.dart
```bash
# Build for iOS
dart run build_app.dart -os=IOS -type=user -build=1.0.1+34

# Build for Android
dart run build_app.dart -os=ANDROID -type=user -build=1.0.1+34

# Build App Bundle
dart run build_app.dart -os=APPBUNDLE -type=user -build=1.0.1+34

# Build for specific environment (dev/prod)
dart run build_app.dart -os=IOS -type=user -build=1.0.1+34 -env=dev
```

## Command Parameters

### Environment Files
- `--dart-define-from-file=env/prod.json`: Production environment
- `--dart-define-from-file=env/dev.json`: Development environment

### Build Types
- `-type=user`: User app build
- `-type=agent`: Agent app build

### Operating Systems
- `-os=IOS`: iOS build
- `-os=ANDROID`: Android build
- `-os=APPBUNDLE`: Android App Bundle build

### Build Numbers
- `--build-number=32`: Version code
- `--build-name=1.0.1`: Version name

## Notes
1. Always ensure you have the correct environment file in the `env/` directory
2. For iOS builds, ensure you have proper certificates and provisioning profiles
3. For Android builds, ensure you have the correct keystore file
4. The build_app.dart script provides a unified way to build for different platforms
5. Web builds use HTML renderer for better compatibility

## Common Issues & Solutions
1. If build fails, check:
   - Environment file exists and is valid
   - Keystore file is present and valid
   - All dependencies are up to date
   - Flutter is on the correct channel
2. For iOS build issues:
   - Check certificates and provisioning profiles
   - Ensure Xcode is properly configured
3. For Android build issues:
   - Verify keystore file location
   - Check build.gradle configurations 