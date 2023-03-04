//
//  HAPPlatformBLEPeripheralManagerUUID.swift
//  
//
//  Created by Alsey Coleman Miller on 3/3/23.
//

import Foundation
import Bluetooth
@_exported import CHomeKitADK

// MARK: - CustomStringConvertible

extension HAPPlatformBLEPeripheralManagerUUID: CustomStringConvertible {
    
    public var description: String {
        rawValue
    }
}

// MARK: - RawRepresentable

extension HAPPlatformBLEPeripheralManagerUUID: RawRepresentable {
    
    public init?(rawValue: String) {
        guard let uuid = UUID(uuidString: rawValue) else {
            return nil
        }
        self.init(uuid: uuid)
    }
    
    public var rawValue: String {
        UUID(homeKit: self).description
    }
}

// MARK: - Foundation UUID

public extension Foundation.UUID {
    
    init(homeKit uuid: HAPPlatformBLEPeripheralManagerUUID) {
        self.init(bluetooth: .init(homeKit: uuid))
    }
}

public extension HAPPlatformBLEPeripheralManagerUUID {
    
    init(uuid: Foundation.UUID) {
        self.init(UInt128(uuid: uuid))
    }
}

// MARK: - Bluetooth UUID

public extension BluetoothUUID {
    
    init(homeKit uuid: HAPPlatformBLEPeripheralManagerUUID) {
        self = .bit128(.init(homeKit: uuid))
    }
}

public extension HAPPlatformBLEPeripheralManagerUUID {
    
    init(bluetooth uuid: BluetoothUUID) {
        self.init(UInt128(uuid))
    }
}

public extension Bluetooth.UInt128 {
    
    init(homeKit uuid: HAPPlatformBLEPeripheralManagerUUID) {
        self.init(littleEndian: .init(bytes: uuid.bytes))
    }
}

public extension HAPPlatformBLEPeripheralManagerUUID {
    
    init(_ value: UInt128) {
        self.init(bytes: value.littleEndian.bytes)
    }
}
