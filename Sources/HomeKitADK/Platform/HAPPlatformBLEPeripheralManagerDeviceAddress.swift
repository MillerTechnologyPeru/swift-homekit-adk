//
//  HAPPlatformBLEPeripheralManagerDeviceAddress.swift
//  
//
//  Created by Alsey Coleman Miller on 3/3/23.
//

import Foundation
import Bluetooth
@_exported import CHomeKitADK

public extension HAPPlatformBLEPeripheralManagerDeviceAddress {
    
    init(_ address: BluetoothAddress) {
        self.init(bytes: address.littleEndian.bytes)
    }
}

public extension BluetoothAddress {
    
    init(homeKit address: HAPPlatformBLEPeripheralManagerDeviceAddress) {
        self.init(littleEndian: .init(bytes: address.bytes))
    }
}

extension HAPPlatformBLEPeripheralManagerDeviceAddress: CustomStringConvertible {
    
    public var description: String {
        return BluetoothAddress(homeKit: self).description
    }
}

extension HAPPlatformBLEPeripheralManagerDeviceAddress: RawRepresentable {
    
    public init?(rawValue: String) {
        guard let address = BluetoothAddress(rawValue: rawValue) else {
            return nil
        }
        self.init(address)
    }
    
    public var rawValue: String {
        BluetoothAddress(homeKit: self).rawValue
    }
}
