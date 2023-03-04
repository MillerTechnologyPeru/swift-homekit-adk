//
//  HAPPlatform.swift
//  
//
//  Created by Alsey Coleman Miller on 3/3/23.
//

import Foundation
import CoreFoundation
#if canImport(NetService)
import NetService
#endif

/// Platform singletons
internal struct HAPPlatform {
        
    static var netService: NetService?
}
