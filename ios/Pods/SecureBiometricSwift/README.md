# SecureBiometricSwift

Securing Local Authentication with Keychain for iOS.

## CocoaPods

```shell
pod 'SecureBiometricSwift'
```

## Swift Package Manager

In your `Package.swift` file, add `SecureBiometricSwift` dependency to corresponding targets:

```swift
let package = Package(
  dependencies: [
    .package(url: "https://github.com/prongbang/SecureBiometricSwift.git", from: "0.0.2"),
  ],
)
```

## How to use

### Encrypt

```swift
import SecureBiometricSwift

let secureBiometricSwift = LocalSecureBiometricSwift()

let plainText = "Hello"
let cipherText = secureBiometricSwift.encrypt(plainText: plainText)
```

### Decrypt

```swift
import SecureBiometricSwift

let secureBiometricSwift = LocalSecureBiometricSwift()

let plainText = secureBiometricSwift.decrypt(cipherText: cipherText)
```
