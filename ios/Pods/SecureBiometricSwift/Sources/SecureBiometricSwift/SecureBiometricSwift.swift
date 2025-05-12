//
//  SecureBiometricSwift.swift
//
//
//  Created by M on 3/10/2565 BE.
//  Copyright © 2565 BE prongbang. All rights reserved.
//


import Foundation

public protocol SecureBiometricSwift {
    func encrypt(plainText: String) -> String?
    
    func decrypt(cipherText: String) -> String?
}
