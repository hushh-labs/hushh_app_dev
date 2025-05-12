//
//  File.swift
//  
//
//  Created by M on 3/10/2565 BE.
//  Copyright © 2565 BE prongbang. All rights reserved.
//

import Foundation
import LocalAuthentication

public protocol KeychainManager {
    func getPwSecAccessControl() -> SecAccessControl
    func getBioSecAccessControl() -> SecAccessControl
    func createEntry(key: String, data: Data, password: String) -> OSStatus
    func createBioProtectedEntry(key: String, data: Data) -> OSStatus
    func remove(key: String)
    func loadPassProtected(key: String, context: LAContext?) -> Data?
    func loadBioProtected(
        key: String, context: LAContext?,
        prompt: String?
    ) -> Data?
    func available(key: String) -> Bool
    func makeAndStoreKey(
        name: String,
        requiresBiometry: Bool
    ) throws -> SecKey
    func loadKey(name: String) -> SecKey?
    func removeKey(name: String)
}
