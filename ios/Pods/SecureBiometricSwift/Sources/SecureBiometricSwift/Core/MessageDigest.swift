//
//  MessageDigest.swift
//  
//
//  Created by M on 3/10/2565 BE.
//  Copyright © 2565 BE prongbang. All rights reserved.
//

import Foundation
import CommonCrypto

public class MessageDigest {
    
    public static func sha256(data : Data) -> Data {
        var hash = [UInt8](repeating: 0,  count: Int(CC_SHA256_DIGEST_LENGTH))
        data.withUnsafeBytes {
            _ = CC_SHA256($0, CC_LONG(data.count), &hash)
        }
        return Data(bytes: hash)
    }
    
}
