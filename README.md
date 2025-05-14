# hushh_app

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## Flutter Version

This project was built with Flutter 3.29.3.

## Running the Flutter App with Environment and Flavor

To run the app with a specific environment and flavor, use the following commands:

### 1. Run with Environment and Flavor (Default Device)
```sh
flutter run -t lib/user.dart --dart-define-from-file=env/prod.json --flavor user
```

### 2. Run on a Specific Device (e.g., iPhone)
First, list your connected devices:
```sh
flutter devices
```
Then, run the app on your desired device (replace DEVICE_ID with your device's ID):
```sh
flutter run -d DEVICE_ID -t lib/user.dart --dart-define-from-file=env/prod.json --flavor user
```

- `-t lib/user.dart` specifies the custom Dart entrypoint.
- `--dart-define-from-file=env/prod.json` loads environment variables from the specified file.
- `--flavor user` uses the 'user' build flavor.

Make sure your device is connected and trusted for development.
