//
//  HAPLog.swift
//  
//
//  Created by Alsey Coleman Miller on 3/3/23.
//

import Foundation

internal func HAPLog(_ subsystem: String, _ category: String, _ message: String) {
    subsystem.withCString { subsystemCString in
        category.withCString { categoryCString in
            let log = HAPLogObject(subsystem: subsystemCString, category: categoryCString)
            HAPLogMessage(log, message)
        }
    }
}
