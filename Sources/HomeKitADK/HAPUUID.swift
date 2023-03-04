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
        self.init(bytes: (0x91, 0x52, 0x76, 0xBB, 0x26, 0x00, 0x00, 0x80, 0x00, 0x10, 0x00, 0x00, bytes.0, bytes.1, bytes.2, bytes.3))
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
        self.init(bluetooth: .init(homeKit: uuid))
    }
}

public extension HAPUUID {
    
    init(uuid: Foundation.UUID) {
        self.init(UInt128(uuid: uuid))
    }
}

// MARK: - Bluetooth UUID

public extension BluetoothUUID {
    
    init(homeKit uuid: HAPUUID) {
        self = .bit128(.init(homeKit: uuid))
    }
}

public extension HAPUUID {
    
    init(bluetooth uuid: BluetoothUUID) {
        self.init(UInt128(uuid))
    }
}

public extension Bluetooth.UInt128 {
    
    init(homeKit uuid: HAPUUID) {
        self.init(littleEndian: .init(bytes: uuid.bytes))
    }
}

public extension HAPUUID {
    
    init(_ value: UInt128) {
        self.init(bytes: value.littleEndian.bytes)
    }
}
