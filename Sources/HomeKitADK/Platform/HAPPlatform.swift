//
//  HAPPlatform.swift
//  
//
//  Created by Alsey Coleman Miller on 3/3/23.
//

#if os(Linux)
import Glibc
import BluetoothLinux
import NetService
#elseif canImport(Darwin)
import Darwin
import DarwinGATT
#endif

import Foundation
import CoreFoundation
import Bluetooth
import GATT

/// Platform singletons
internal struct HAPPlatform {
        
    static var netService: NetService?
    
    #if os(Linux)
    static var hostController: BluetoothLinux.HostController?
    #endif
    
    static var peripheralManager: HAPPeripheral?
}

#if os(Linux)
public typealias HAPCentral = GATTCentral<BluetoothLinux.HostController, BluetoothLinux.L2CAPSocket>
public typealias HAPPeripheral = GATTPeripheral<BluetoothLinux.HostController, BluetoothLinux.L2CAPSocket>
#elseif os(macOS)
public typealias HAPCentral = DarwinCentral
public typealias HAPPeripheral = DarwinPeripheral
#else
#error("Unsupported platform")
#endif
