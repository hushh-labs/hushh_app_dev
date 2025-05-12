//
//  KeyManager.swift
//  
//
//  Created by M on 3/10/2565 BE.
//  Copyright © 2565 BE prongbang. All rights reserved.
//

import Foundation
import LocalAuthentication
import CommonCrypto

public protocol KeyManager {
    func createKey(keyConfig: KeyConfig) -> SecKey?
    func getOrCreateKey(keyConfig: KeyConfig) -> SecKey?
}
