//
//  LocalSecureBiometricSwift.swift
//  
//
//  Created by M on 3/10/2565 BE.
//  Copyright © 2565 BE prongbang. All rights reserved.
//

import Foundation

@available(macOS 10.13.4, *)
public class LocalSecureBiometricSwift : SecureBiometricSwift {

    private var cryptographyManager: CryptographyManager?

    public init() {
        let keyConfig = KeyConfig(name: "Keychain.SecureBiometric", requiresBiometry: true)
        let keychainManager = KeychainAccessManager()
        let keyManager = PublicKeyManager(keychainManager: keychainManager)
        cryptographyManager = BiometricCryptographyManager(keyManager: keyManager, keyConfig: keyConfig)
    }
    
    public func encrypt(plainText: String) -> String? {
        return cryptographyManager?.encrypt(plainText: plainText)
    }
    
    public func decrypt(cipherText: String) -> String? {
        return cryptographyManager?.decrypt(cipherText: cipherText)
    }
    
}
