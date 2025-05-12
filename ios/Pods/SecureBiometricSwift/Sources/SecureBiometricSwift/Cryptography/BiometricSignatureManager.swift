//
//  BiometricSignatureManager.swift
//  
//
//  Created by M on 3/10/2565 BE.
//  Copyright © 2565 BE prongbang. All rights reserved.
//

import Foundation
import CommonCrypto

public class BiometricSignatureManager : SignatureManager {
    
    private let keyManager: KeyManager
    private let keyConfig: KeyConfig
    
    public init(keyManager: KeyManager, keyConfig: KeyConfig) {
        self.keyManager = keyManager
        self.keyConfig = keyConfig
    }
    
    public func sign(algorithm: SecKeyAlgorithm, data: Data) -> String? {
        
        let key = keyManager.getOrCreateKey(keyConfig: keyConfig)
        guard key != nil else {
            return nil
        }
        
        guard SecKeyIsAlgorithmSupported(key!, .sign, algorithm) else {
            print("Algorith not supported")
            return nil
        }
        
        // SecKeyCreateSignature call is blocking when the used key is protected by biometry authentication.
        // If that's not the case, dispatching to a background thread isn't necessary.
        return doAsync {
            
            var error: Unmanaged<CFError>?
            let signature = SecKeyCreateSignature(
                key!, algorithm,
                data as CFData,
                &error
            ) as Data?
            
            guard signature != nil else {
                print("Can't sign: \((error!.takeRetainedValue() as Error).localizedDescription)")
                return nil
            }
            
            return signature!.hexString()
        }.await()
        
    }
    
    public func signMessage(message: String) -> String? {
        sign(
            algorithm: .ecdsaSignatureMessageX962SHA256,
            data: message.data(using: .utf8)!
        )
    }
    
    public func signDigest(message: String) -> String? {
        sign(
            algorithm: .ecdsaSignatureDigestX962SHA256,
            data: MessageDigest.sha256(data: message.data(using: .utf8)!)
        )
    }
    
    public func verify(message: String, signature: String) -> Bool {
        
        let key = keyManager.getOrCreateKey(keyConfig: keyConfig)
        guard key != nil else {
            return false
        }
        
        let signatureData = Data(hexString: signature)
        guard signatureData != nil else {
            return false
        }
        
        guard let publicKey = SecKeyCopyPublicKey(key!) else {
            print("Can't get public key")
            return false
        }
        
        let algorithm: SecKeyAlgorithm = .ecdsaSignatureMessageX962SHA256
        guard SecKeyIsAlgorithmSupported(publicKey, .verify, algorithm) else {
            print("Algorithm is not supported")
            return false
        }
        
        let clearTextData = message.data(using: .utf8)!
        var error: Unmanaged<CFError>?
        guard SecKeyVerifySignature(
            publicKey, algorithm,
            clearTextData as CFData,
            signatureData! as CFData,
            &error
        ) else {
            print("Can't verify/wrong signature")
            return false
        }
        
        return true
    }
    
}
