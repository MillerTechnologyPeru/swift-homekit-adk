//
//  HAPUUID.swift
//  
//
//  Created by Alsey Coleman Miller on 3/3/23.
//

import Foundation
import Bluetooth
@_exported import CHomeKitADK

public extension HAPUUID {
    
    init(appleDefined: UInt32) {
        let bytes = appleDefined.littleEndian.bytes
        self.init(bytes: (0x91, 0x52, 0x76, 0xBB, 0x26, 0x00, 0x00, 0x80, 0x00, 0x10, 0x00, 0x00, bytes.3, bytes.2, bytes.1, bytes.0))
    }
    
    var isAppleDefined: Bool {
        withUnsafePointer(to: self) {
            HAPUUIDIsAppleDefined($0)
        }
    }
}

// MARK: - Equatable

extension HAPUUID: Equatable {
    
    public static func == (lhs: HAPUUID, rhs: HAPUUID) -> Bool {
        return withUnsafePointer(to: lhs) { lhsPointer in
            withUnsafePointer(to: rhs) { rhsPointer in
                HAPUUIDAreEqual(lhsPointer, rhsPointer)
            }
        }
    }
}

// MARK: - CustomStringConvertible

extension HAPUUID: CustomStringConvertible {
    
    public var description: String {
        return withUnsafePointer(to: self) { uuid in
            let byteCount = HAPUUIDGetNumDescriptionBytes(uuid)
            assert(byteCount > 0)
            return String.init(unsafeUninitializedCapacity: byteCount, initializingUTF8With: { buffer in
                let error = HAPUUIDGetDescription(uuid, buffer.baseAddress!, byteCount)
                precondition(error == kHAPError_None)
                return byteCount
            })
        }
    }
}

// MARK: - Foundation UUID

public extension Foundation.UUID {
    
    init(homeKit uuid: HAPUUID) {
        self.init(uuid: uuid.bytes)
    }
}

public extension HAPUUID {
    
    init(uuid: Foundation.UUID) {
        self.init(bytes: uuid.uuid)
    }
}

// MARK: - Bluetooth UUID

public extension BluetoothUUID {
    
    init(homeKit uuid: HAPUUID) {
        self.init(littleEndian: .bit128(.init(homeKit: uuid)))
    }
}

public extension Bluetooth.UInt128 {
    
    init(homeKit uuid: HAPUUID) {
        self.init(bytes: (uuid.bytes.15, uuid.bytes.14, uuid.bytes.13, uuid.bytes.12, uuid.bytes.11, uuid.bytes.10, uuid.bytes.9, uuid.bytes.8, uuid.bytes.7, uuid.bytes.6, uuid.bytes.5, uuid.bytes.4, uuid.bytes.3, uuid.bytes.2, uuid.bytes.1, uuid.bytes.0))
    }
}
