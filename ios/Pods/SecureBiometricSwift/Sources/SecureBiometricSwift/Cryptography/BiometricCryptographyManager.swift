//
//  BiometricCryptographyManager.swift
//  
//
//  Created by M on 3/10/2565 BE.
//  Copyright © 2565 BE prongbang. All rights reserved.
//

import Foundation

public class BiometricCryptographyManager : CryptographyManager {
    
    private let keyManager: KeyManager
    private let keyConfig: KeyConfig
    
    public init(keyManager: KeyManager, keyConfig: KeyConfig) {
        self.keyManager = keyManager
        self.keyConfig = keyConfig
    }
    
    public func encrypt(plainText: String) -> String? {
        
        let key = keyManager.getOrCreateKey(keyConfig: keyConfig)
        guard key != nil else {
            return nil
        }
        
        guard let publicKey = SecKeyCopyPublicKey(key!) else {
            print("Can't get public key and ")
            return nil
        }
        
        let algorithm: SecKeyAlgorithm = .eciesEncryptionCofactorVariableIVX963SHA256AESGCM
        guard SecKeyIsAlgorithmSupported(publicKey, .encrypt, algorithm) else {
            print("Algorith not supported")
            return nil
        }
        
        var error: Unmanaged<CFError>?
        let clearTextData = plainText.data(using: .utf8)!
        let cipherTextData = SecKeyCreateEncryptedData(
            publicKey, algorithm,
            clearTextData as CFData,
            &error
        ) as Data?
        
        guard cipherTextData != nil else {
            print("Can't encrypt: \((error!.takeRetainedValue() as Error).localizedDescription)")
            return nil
        }
        
        return cipherTextData!.hexString()
    }
    
    public func decrypt(cipherText: String) -> String? {
        
        let key = keyManager.getOrCreateKey(keyConfig: keyConfig)
        guard key != nil else {
            return nil
        }
        
        let cipherTextData = Data(hexString: cipherText)
        guard cipherTextData != nil else {
            print("Can't convert hex to data")
            return nil
        }
        
        let algorithm: SecKeyAlgorithm = .eciesEncryptionCofactorVariableIVX963SHA256AESGCM
        guard SecKeyIsAlgorithmSupported(key!, .decrypt, algorithm) else {
            print("Algorith not supported")
            return nil
        }
        
        // SecKeyCreateDecryptedData call is blocking when the used key is protected by biometry authentication.
        // If that's not the case, dispatching to a background thread isn't necessary.
        
        return doAsync {

            var error: Unmanaged<CFError>?
            let clearTextData = SecKeyCreateDecryptedData(
                key!,
                algorithm,
                cipherTextData! as CFData,
                &error
            ) as Data?

            guard clearTextData != nil else {
                print("Can't decrypt: \((error!.takeRetainedValue() as Error).localizedDescription)")
                return nil
            }
            return String(decoding: clearTextData!, as: UTF8.self)

        }.await()
        
    }
    
}
