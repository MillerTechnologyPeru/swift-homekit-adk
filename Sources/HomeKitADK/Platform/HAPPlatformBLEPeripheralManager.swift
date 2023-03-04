//
//  HAPPlatformBLEPeripheralManager.swift
//  
//
//  Created by Alsey Coleman Miller on 3/3/23.
//

#if os(Linux)
import Glibc
import BluetoothLinux
#elseif canImport(Darwin)
import Darwin
import DarwinGATT
#endif
#if canImport(IOBluetooth)
import IOBluetooth
#endif

import Foundation
import CoreFoundation
import Bluetooth
import GATT
import CHomeKitADK

fileprivate func HAPPlatformBLEPeripheralManagerLog(_ message: String) {
    HAPLog(kHAPPlatform_LogSubsystem, "BLEPeripheralManager", message)
}

private let log = HAPPlatformBLEPeripheralManagerLog

extension HAPPlatform {
    
    static func loadPeripheralManager() async throws {
        #if os(Linux)
        var hostController: HostController! = await HostController.default
        // keep trying to load Bluetooth device
        while hostController == nil {
            #if DEBUG
            log("No Bluetooth adapters found")
            #endif
            try await Task.sleep(nanoseconds: 5 * 1_000_000_000)
            hostController = await HostController.default
        }
        self.hostController = hostController
        let address = try await hostController.readDeviceAddress()
        log("Bluetooth Controller: \(address)")
        let serverOptions = GATTPeripheralOptions(
            maximumTransmissionUnit: .max,
            maximumPreparedWrites: 1000
        )
        let peripheral = LinuxPeripheral(
            hostController: hostController,
            options: serverOptions,
            socket: BluetoothLinux.L2CAPSocket.self
        )
        #elseif canImport(Darwin)
        let peripheral = DarwinPeripheral()
        #endif
        peripheral.log = HAPPlatformBLEPeripheralManagerLog
        self.peripheralManager = peripheral
        
    }
}

/**
 Create Bluetooth LE Peripheral Manager
 
 ```void HAPPlatformBLEPeripheralManagerCreate(
         HAPPlatformBLEPeripheralManagerRef blePeripheralManager,
         const HAPPlatformBLEPeripheralManagerOptions* options)
 ```
 */
@_silgen_name("HAPPlatformBLEPeripheralManagerCreate")
public func HAPPlatformBLEPeripheralManagerCreate(
    blePeripheralManager: HAPPlatformBLEPeripheralManagerRef,
    options: UnsafePointer<HAPPlatformBLEPeripheralManagerOptions>
) {
    log(#function)
}

/// `void HAPPlatformBLEPeripheralManagerSetDelegate(HAPPlatformBLEPeripheralManagerRef blePeripheralManager_, const HAPPlatformBLEPeripheralManagerDelegate* _Nullable delegate_)
@_silgen_name("HAPPlatformBLEPeripheralManagerSetDelegate")
public func HAPPlatformBLEPeripheralManagerSetDelegate(
    blePeripheralManager: HAPPlatformBLEPeripheralManagerRef,
    delegate: UnsafePointer<HAPPlatformBLEPeripheralManagerDelegate>
) {
    log(#function)
}

/// `void HAPPlatformBLEPeripheralManagerSetDeviceAddress(HAPPlatformBLEPeripheralManagerRef blePeripheralManager, const HAPPlatformBLEPeripheralManagerDeviceAddress* deviceAddress)`
@_silgen_name("HAPPlatformBLEPeripheralManagerSetDeviceAddress")
public func HAPPlatformBLEPeripheralManagerSetDeviceAddress(
    blePeripheralManager: HAPPlatformBLEPeripheralManagerRef,
    deviceAddress: UnsafePointer<HAPPlatformBLEPeripheralManagerDeviceAddress>
) {
    log("\(#function) \(deviceAddress.pointee.description)")
}

@_silgen_name("HAPPlatformBLEPeripheralManagerSetDeviceName")
public func HAPPlatformBLEPeripheralManagerSetDeviceName(
    blePeripheralManager: HAPPlatformBLEPeripheralManagerRef,
    deviceName: UnsafePointer<CChar>
) {
    let name = String(cString: deviceName)
    log("\(#function) \(name)")
    #if os(Linux)
    Task {
        HAPPlatform.hostController?.writeLocalName(deviceName)
    }
    #elseif canImport(IOBluetooth)
    //IOBluetoothHostController.default().nameAsString()
    #endif
}

@_silgen_name("HAPPlatformBLEPeripheralManagerAddService")
public func HAPPlatformBLEPeripheralManagerAddService(
    blePeripheralManager: HAPPlatformBLEPeripheralManagerRef,
    type: UnsafePointer<HAPPlatformBLEPeripheralManagerUUID>,
    isPrimary: Bool
) -> CHomeKitADK.HAPError {
    log("\(#function) \(type.pointee) isPrimary \(isPrimary)")
    
    return kHAPError_None
}

/**
 * Removes all published services from the local GATT database.
 *
 * - Only services that were added through HAPPlatformBLEPeripheralManager methods are affected.
 *
 * @param      blePeripheralManager BLE peripheral manager.
 */
@_silgen_name("HAPPlatformBLEPeripheralManagerRemoveAllServices")
public func HAPPlatformBLEPeripheralManagerRemoveAllServices(
    blePeripheralManager: HAPPlatformBLEPeripheralManagerRef
) {
    log("\(#function)")
}

@_silgen_name("HAPPlatformBLEPeripheralManagerAddCharacteristic")
public func HAPPlatformBLEPeripheralManagerAddCharacteristic(
    blePeripheralManager: HAPPlatformBLEPeripheralManagerRef
) -> CHomeKitADK.HAPError {
    log("\(#function)")
    return kHAPError_None
}

@_silgen_name("HAPPlatformBLEPeripheralManagerAddDescriptor")
public func HAPPlatformBLEPeripheralManagerAddDescriptor(
    blePeripheralManager: HAPPlatformBLEPeripheralManagerRef
) -> CHomeKitADK.HAPError {
    log("\(#function)")
    return kHAPError_None
}

@_silgen_name("HAPPlatformBLEPeripheralManagerCancelCentralConnection")
public func HAPPlatformBLEPeripheralManagerCancelCentralConnection(
    blePeripheralManager: HAPPlatformBLEPeripheralManagerRef
) {
    log("\(#function)")
}

@_silgen_name("HAPPlatformBLEPeripheralManagerPublishServices")
public func HAPPlatformBLEPeripheralManagerPublishServices(
    blePeripheralManager: HAPPlatformBLEPeripheralManagerRef
) {
    log("\(#function)")
}

@_silgen_name("HAPPlatformBLEPeripheralManagerSendHandleValueIndication")
public func HAPPlatformBLEPeripheralManagerSendHandleValueIndication(
    blePeripheralManager: HAPPlatformBLEPeripheralManagerRef
) -> CHomeKitADK.HAPError {
    log("\(#function)")
    return kHAPError_None
}

@_silgen_name("HAPPlatformBLEPeripheralManagerStartAdvertising")
public func HAPPlatformBLEPeripheralManagerStartAdvertising(
    blePeripheralManager: HAPPlatformBLEPeripheralManagerRef
) {
    log("\(#function)")
    Task {
        try await HAPPlatform.peripheralManager?.start()
    }
}

@_silgen_name("HAPPlatformBLEPeripheralManagerStopAdvertising")
public func HAPPlatformBLEPeripheralManagerStopAdvertising(
    blePeripheralManager: HAPPlatformBLEPeripheralManagerRef
) {
    log("\(#function)")
    #if canImport(Darwin)
    HAPPlatform.peripheralManager?.stop()
    #else
    Task {
        try await HAPPlatform.peripheralManager?.stop()
    }
    #endif
}


