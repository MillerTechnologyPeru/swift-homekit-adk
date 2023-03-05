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
import CoreBluetooth
#endif
#if canImport(IOBluetooth)
import IOBluetooth
#endif

import Foundation
import CoreFoundation
import Bluetooth
import BluetoothGATT
import GATT
import CHomeKitADK

fileprivate func HAPPlatformBLEPeripheralManagerLog(_ message: String) {
    HAPLog(kHAPPlatform_LogSubsystem, "BLEPeripheralManager", message)
}

#if DEBUG
private let log = HAPPlatformBLEPeripheralManagerLog
#else
private let log: (String) -> () = { _ in }
#endif

public actor HAPGATTController {
            
    // MARK: - Properties
    
    let peripheral: HAPPeripheral
    
    fileprivate(set) var delegate: UnsafePointer<HAPPlatformBLEPeripheralManagerDelegate>?
    
    fileprivate static var lastTask: Task<Void, Error>?
    
    fileprivate static var services = [GATTAttribute.Service]()
        
    // MARK: - Initialization
    
    public init(peripheral: HAPPeripheral) async throws {
        self.peripheral = peripheral
        
        // set callbacks
        self.peripheral.willRead = { [unowned self] in
            return await self.willRead($0)
        }
        self.peripheral.willWrite = { [unowned self] in
            return await self.willWrite($0)
        }
        self.peripheral.didWrite = { [unowned self] (confirmation) in
            await self.didWrite(confirmation)
        }
    }
    
    // MARK: - Methods
    
    static func task(_ task: @escaping (HAPGATTController) async throws -> ()) {
        let lastTask = self.lastTask
        self.lastTask = Task(priority: .userInitiated) {
            try await lastTask?.value
            guard let controller = HAPPlatform.gattController else {
                log("\(self) not initialized")
                fatalError("\(self) not initialized")
            }
            do {
                try await task(controller)
            }
            catch {
                log("Error: \(error)")
                throw error
            }
        }
    }
    
    func setDelegate(_ delegate: UnsafePointer<HAPPlatformBLEPeripheralManagerDelegate>) {
        self.delegate = delegate
    }
    
    func addService(uuid: PendingService.UUID, isPrimary: Bool) {
        
    }
    
    func addCharacteristic(
        uuid: PendingCharacteristic.UUID,
        properties: PendingCharacteristic.Properties,
        value: Data?
    ) {
        
    }
    
    private func willRead(_ request: GATTReadRequest<HAPPeripheral.Central>) async -> ATTError? {
        
        return nil
    }
    
    private func willWrite(_ request: GATTWriteRequest<HAPPeripheral.Central>)async -> ATTError? {
        
        return nil
    }
    
    private func didWrite(_ confirmation: GATTWriteConfirmation<HAPPeripheral.Central>) async {
        
        
    }
}

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
        let address = try await hostController.readDeviceAddress()
        log("Bluetooth Controller: \(address)")
        let serverOptions = GATTPeripheralOptions(
            maximumTransmissionUnit: .max,
            maximumPreparedWrites: 1000
        )
        let peripheral = HAPPeripheral(
            hostController: hostController,
            options: serverOptions,
            socket: BluetoothLinux.L2CAPSocket.self
        )
        #elseif canImport(Darwin)
        let options: DarwinPeripheral.Options = [
            "CBManagerIsPrivilegedDaemonKey": true as NSNumber,
            "CBCentralManagerScanOptionAllowDuplicatesKey": true as NSNumber
        ]
        let peripheral = DarwinPeripheral(options: options)
        #endif
        peripheral.log = HAPPlatformBLEPeripheralManagerLog
        #if canImport(Darwin)
        try await peripheral.waitPowerOn()
        #endif
        self.gattController = try await HAPGATTController(peripheral: peripheral)
    }
}

internal extension HAPGATTController {
    
    struct PendingProfile {
        
        var services: [PendingService]
    }
    
    struct PendingService {
        
        typealias UUID = HAPPlatformBLEPeripheralManagerUUID
        
        let uuid: UUID
        
        let isPrimary: Bool
        
        var characteristics: [PendingCharacteristic]
    }
    
    struct PendingCharacteristic {
        
        typealias UUID = HAPPlatformBLEPeripheralManagerUUID
        
        typealias Properties = HAPPlatformBLEPeripheralManagerCharacteristicProperties
        
        let uuid: UUID
        
        let properties: Properties
        
        let value: Data?
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
public func HAPPlatformBLEPeripheralManagerCreate() {
    log("Create Peripheral Manager")
    HAPGATTController.lastTask = Task {
        try await HAPPlatform.loadPeripheralManager()
    }
}

/// `void HAPPlatformBLEPeripheralManagerSetDelegate(HAPPlatformBLEPeripheralManagerRef blePeripheralManager_, const HAPPlatformBLEPeripheralManagerDelegate* _Nullable delegate_)
@_silgen_name("HAPPlatformBLEPeripheralManagerSetDelegate")
public func HAPPlatformBLEPeripheralManagerSetDelegate(
    blePeripheralManager: HAPPlatformBLEPeripheralManagerRef,
    delegate: UnsafePointer<HAPPlatformBLEPeripheralManagerDelegate>
) {
    log("Set Delegate")
    HAPGATTController.task { controller in
        await controller.setDelegate(delegate)
    }
}

/// `void HAPPlatformBLEPeripheralManagerSetDeviceAddress(HAPPlatformBLEPeripheralManagerRef blePeripheralManager, const HAPPlatformBLEPeripheralManagerDeviceAddress* deviceAddress)`
@_silgen_name("HAPPlatformBLEPeripheralManagerSetDeviceAddress")
public func HAPPlatformBLEPeripheralManagerSetDeviceAddress(
    blePeripheralManager: HAPPlatformBLEPeripheralManagerRef,
    deviceAddress: inout HAPPlatformBLEPeripheralManagerDeviceAddress
) {
    log("Set Device Address \(deviceAddress.description)")
}

@_silgen_name("HAPPlatformBLEPeripheralManagerSetDeviceName")
public func HAPPlatformBLEPeripheralManagerSetDeviceName(
    blePeripheralManager: HAPPlatformBLEPeripheralManagerRef,
    deviceName: UnsafePointer<CChar>
) {
    let name = String(cString: deviceName)
    log("Set Device Name \"\(name)\"")
    HAPGATTController.task { controller in
        #if os(Linux)
        try await controller.peripheral.hostController.writeLocalName(name)
        #elseif canImport(IOBluetooth)
        //IOBluetoothHostController.default().nameAsString()
        #endif
    }
}

@_silgen_name("HAPPlatformBLEPeripheralManagerAddService")
public func HAPPlatformBLEPeripheralManagerAddService(
    blePeripheralManager: HAPPlatformBLEPeripheralManagerRef,
    type: inout HAPPlatformBLEPeripheralManagerUUID,
    isPrimary: Bool
) -> CHomeKitADK.HAPError {
    log("Add\(isPrimary ? " primary" : "") Service \(type.description)")
    let service = GATTAttribute.Service(
        uuid: BluetoothUUID(homeKit: type),
        primary: isPrimary,
        characteristics: [],
        includedServices: []
    )
    HAPGATTController.services.append(service)
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
    log("Remove All Services")
    HAPGATTController.services.removeAll()
    HAPGATTController.task { controller in
        await controller.peripheral.removeAllServices()
    }
}

@_silgen_name("HAPPlatformBLEPeripheralManagerAddCharacteristic")
public func HAPPlatformBLEPeripheralManagerAddCharacteristic(
    blePeripheralManager: HAPPlatformBLEPeripheralManagerRef,
    type: inout HAPPlatformBLEPeripheralManagerUUID,
    properties: HAPPlatformBLEPeripheralManagerCharacteristicProperties,
    constBytes: UnsafeRawPointer?,
    constNumBytes: Int,
    valueHandle: inout HAPPlatformBLEPeripheralManagerAttributeHandle,
    cccDescriptorHandle: UnsafeMutablePointer<HAPPlatformBLEPeripheralManagerAttributeHandle>?
) -> CHomeKitADK.HAPError {
    log("Add Characteristic \(type.description)")
    let data = constBytes.map { Data(bytes: $0, count: constNumBytes) }
    let characteristic = GATTAttribute.Characteristic(
        uuid: BluetoothUUID(homeKit: type),
        value: data ?? Data(),
        permissions: .init(homeKit: properties),
        properties: .init(homeKit: properties),
        descriptors: []
    )
    var services = HAPGATTController.services
    let lastServiceIndex = services.count - 1
    services[lastServiceIndex].characteristics.append(characteristic)
    valueHandle = GATTDatabase(services: services).last!.handle
    if properties.notify || properties.indicate {
        let descriptor = GATTClientCharacteristicConfiguration().descriptor
        assert(cccDescriptorHandle != nil)
        let lastCharacteristicIndex = services[lastServiceIndex].characteristics.count - 1
        services[lastServiceIndex].characteristics[lastCharacteristicIndex].descriptors.append(descriptor)
        cccDescriptorHandle?.pointee = GATTDatabase(services: services).last!.handle
    }
    HAPGATTController.services = services
    return kHAPError_None
}

@_silgen_name("HAPPlatformBLEPeripheralManagerAddDescriptor")
public func HAPPlatformBLEPeripheralManagerAddDescriptor(
    blePeripheralManager: HAPPlatformBLEPeripheralManagerRef,
    type: inout HAPPlatformBLEPeripheralManagerUUID,
    properties: HAPPlatformBLEPeripheralManagerCharacteristicProperties,
    constBytes: UnsafeRawPointer?,
    constNumBytes: Int,
    descriptorHandle: inout HAPPlatformBLEPeripheralManagerAttributeHandle
) -> CHomeKitADK.HAPError {
    log("Add Descriptor \(type.description)")
    let data = constBytes.map { Data(bytes: $0, count: constNumBytes) }
    let descriptor = GATTAttribute.Descriptor(
        uuid: BluetoothUUID(homeKit: type),
        value: data ?? Data(),
        permissions: .init(homeKit: properties)
    )
    var services = HAPGATTController.services
    let lastServiceIndex = services.count - 1
    let lastCharacteristicIndex = services[lastServiceIndex].characteristics.count - 1
    services[lastServiceIndex].characteristics[lastCharacteristicIndex].descriptors.append(descriptor)
    descriptorHandle = GATTDatabase(services: services).last!.handle
    HAPGATTController.services = services
    return kHAPError_None
}

@_silgen_name("HAPPlatformBLEPeripheralManagerCancelCentralConnection")
public func HAPPlatformBLEPeripheralManagerCancelCentralConnection(
    blePeripheralManager: HAPPlatformBLEPeripheralManagerRef,
    connectionHandle: HAPPlatformBLEPeripheralManagerConnectionHandle
) {
    log("Cancel Connection \(connectionHandle.toHexadecimal())")
    HAPGATTController.task { _ in
        //$0.peripheral.activeConnections.contains()
    }
}

@_silgen_name("HAPPlatformBLEPeripheralManagerPublishServices")
public func HAPPlatformBLEPeripheralManagerPublishServices(
    blePeripheralManager: HAPPlatformBLEPeripheralManagerRef
) {
    log("Publish Services")
    
    // add pending services
    let pendingServices = HAPGATTController.services
    HAPGATTController.services.removeAll()
    HAPGATTController.task {
        $0.peripheral.removeAllServices()
        for service in pendingServices {
            _ = try await $0.peripheral.add(service: service)
        }
    }
}

@_silgen_name("HAPPlatformBLEPeripheralManagerSendHandleValueIndication")
public func HAPPlatformBLEPeripheralManagerSendHandleValueIndication(
    blePeripheralManager: HAPPlatformBLEPeripheralManagerRef,
    connectionHandle: HAPPlatformBLEPeripheralManagerConnectionHandle,
    valueHandle: HAPPlatformBLEPeripheralManagerAttributeHandle,
    bytes: UnsafeRawPointer?,
    numBytes: Int
) -> CHomeKitADK.HAPError {
    log("Send Handle Value Indication for connection \(connectionHandle.toHexadecimal())")
    return kHAPError_None
}

@_silgen_name("HAPPlatformBLEPeripheralManagerStartAdvertising")
public func HAPPlatformBLEPeripheralManagerStartAdvertising(
    blePeripheralManager: HAPPlatformBLEPeripheralManagerRef,
    advertisingInterval: HAPBLEAdvertisingInterval,
    advertisingBytes: UnsafeRawPointer,
    numAdvertisingBytes: Int,
    scanResponseBytes: UnsafeRawPointer?,
    numScanResponseBytes: Int
) {
    log("Start Advertising with \(AdvertisingInterval(rawValue: advertisingInterval)?.description ?? advertisingInterval.description) interval")
    
    #if canImport(CoreBluetooth)
    // CoreBluetooth automatically prepends 3 bytes for Flags to our advertisement data
    // (It adds flag 0x06: LE General Discoverable Mode bit + BR/EDR Not Supported bit)
    
    assert(numAdvertisingBytes >= 3);
    let advertisingBytes = advertisingBytes.advanced(by: 3);
    let numAdvertisingBytes = numAdvertisingBytes - 3;
    assert(numScanResponseBytes >= 2);
    let scanResponseBytes = scanResponseBytes?.advanced(by: 2);
    let numScanResponseBytes = numScanResponseBytes - 2;
    let advertisingData = Data(bytes: advertisingBytes, count: numAdvertisingBytes)
    let scanResponse = numScanResponseBytes > 0 ? Data(bytes: scanResponseBytes!, count: numScanResponseBytes) : Data()
    let options: DarwinPeripheral.AdvertisingOptions = [
        "CBAdvertisementDataAppleMfgData": advertisingData as NSData,
        CBAdvertisementDataLocalNameKey: scanResponse as NSData
    ]
    HAPGATTController.task {
        try await $0.peripheral.start(options: options)
    }
    #elseif os(Linux)
    HAPGATTController.task {
        let hostController = $0.peripheral.hostController
        do { try await hostController.enableLowEnergyAdvertising(false) }
        catch HCIError.commandDisallowed { }
        let advertisingData = Data(bytes: advertisingBytes, count: numAdvertisingBytes)
        try await hostController.setLowEnergyAdvertisingData(.init(data: advertisingData)!)
        if let pointer = scanResponseBytes, numScanResponseBytes > 0 {
            let data =  Data(bytes: pointer, count: numScanResponseBytes)
            try await hostController.setLowEnergyScanResponse(.init(data: data)!)
        }
        try await $0.peripheral.start()
    }
    #endif
}

@_silgen_name("HAPPlatformBLEPeripheralManagerStopAdvertising")
public func HAPPlatformBLEPeripheralManagerStopAdvertising(
    blePeripheralManager: HAPPlatformBLEPeripheralManagerRef
) {
    log("Stop Advrertising")
    HAPGATTController.task {
        $0.peripheral.stop()
    }
}
