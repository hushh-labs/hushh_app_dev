//
//  PublicKeyManager.swift
//  
//
//  Created by M on 3/10/2565 BE.
//  Copyright © 2565 BE prongbang. All rights reserved.
//

import Foundation
import LocalAuthentication
import CommonCrypto

@available(macOS 10.13.4, *)
public class PublicKeyManager : KeyManager {

    private let keychainManager: KeychainManager
    
    private var key: SecKey?
    
    public init(keychainManager: KeychainManager) {
        self.keychainManager = keychainManager
    }
    
    public func createKey(keyConfig: KeyConfig) -> SecKey? {
        var key = keychainManager.loadKey(name: keyConfig.name)
        guard key == nil else {
            return key
        }
        
        do {
            key = try keychainManager.makeAndStoreKey(
                name: keyConfig.name,
                requiresBiometry: keyConfig.requiresBiometry
            )
            return key
        } catch let error {
            print("Can't create key : \(error.localizedDescription)")
        }
        
        return nil
    }
    
    public func getOrCreateKey(keyConfig: KeyConfig) -> SecKey? {
        guard key == nil else {
            return key
        }
        
        key = self.createKey(keyConfig: keyConfig)
        guard key != nil else {
            print("Can't create public key")
            return nil
        }
        
        return key
    }
    
}
