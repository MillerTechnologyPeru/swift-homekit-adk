//
//  HAPPlatformServiceDiscovery.swift
//  
//
//  Created by Alsey Coleman Miller on 3/3/23.
//

import Foundation
import CoreFoundation
import Dispatch
import CHomeKitADK
#if canImport(NetService)
import NetService
#endif

fileprivate func HAPPlatformServiceDiscoveryLog(_ message: String) {
    HAPLog(kHAPPlatform_LogSubsystem, "ServiceDiscovery", message)
}

/**
 void HAPPlatformServiceDiscoveryCreate(
         HAPPlatformServiceDiscoveryRef serviceDiscovery,
         const HAPPlatformServiceDiscoveryOptions* options)
 */
@_silgen_name("HAPPlatformServiceDiscoveryCreate")
public func _HAPPlatformServiceDiscoveryCreate(
    serviceDiscovery: HAPPlatformServiceDiscoveryRef,
    options: UnsafePointer<HAPPlatformServiceDiscoveryOptions>
) {
    
}

/**
 ```
 void HAPPlatformServiceDiscoveryRegister(
         HAPPlatformServiceDiscoveryRef serviceDiscovery,
         const char* name,
         const char* protocol,
         uint16_t port,
         HAPPlatformServiceDiscoveryTXTRecord* txtRecords,
         size_t numTXTRecords)
 ```
 */
@_silgen_name("HAPPlatformServiceDiscoveryRegister")
public func _HAPPlatformServiceDiscoveryRegister(
    serviceDiscovery: HAPPlatformServiceDiscoveryRef,
    name: UnsafePointer<CChar>,
    type: UnsafePointer<CChar>,
    port: UInt16,
    txtRecords: UnsafeMutablePointer<HAPPlatformServiceDiscoveryTXTRecord>,
    numTXTRecords: Int
) {
    let type = String(cString: type)
    let name = String(cString: name)
    let netService = NetService(
        domain: "",
        type: type,
        name: name,
        port: numericCast(port)
    )
    HAPPlatform.netService = netService
    _HAPPlatformServiceDiscoveryUpdateTXTRecords(
        serviceDiscovery: serviceDiscovery,
        txtRecords: txtRecords,
        numTXTRecords: numTXTRecords
    )
    netService.publish()
    HAPPlatformServiceDiscoveryLog("Publishing \(name):\(type) on port \(port)");
}

/// `void HAPPlatformServiceDiscoveryStop(HAPPlatformServiceDiscoveryRef serviceDiscovery)`
@_silgen_name("HAPPlatformServiceDiscoveryStop")
public func _HAPPlatformServiceDiscoveryStop(
    serviceDiscovery: HAPPlatformServiceDiscoveryRef
) {
    HAPPlatform.netService?.stop()
    HAPPlatform.netService = nil
}

/**
 void HAPPlatformServiceDiscoveryUpdateTXTRecords(
         HAPPlatformServiceDiscoveryRef serviceDiscovery,
         HAPPlatformServiceDiscoveryTXTRecord* txtRecords,
         size_t numTXTRecords)
 */
@_silgen_name("HAPPlatformServiceDiscoveryUpdateTXTRecords")
public func _HAPPlatformServiceDiscoveryUpdateTXTRecords(
    serviceDiscovery: HAPPlatformServiceDiscoveryRef,
    txtRecords: UnsafeMutablePointer<HAPPlatformServiceDiscoveryTXTRecord>,
    numTXTRecords: Int
) {
    guard let service = HAPPlatform.netService else {
        fatalError("Missing singleton")
    }
    var txtRecord = [String: Data]()
    txtRecord.reserveCapacity(numTXTRecords)
    for i in 0 ..< numTXTRecords {
        let record = txtRecords[i]
        let key = String(cString: record.key)
        let data = Data(bytes: record.value.bytes!, count: record.value.numBytes)
        txtRecord[key] = data
    }
    let recordData = NetService.data(fromTXTRecord: txtRecord)
    service.setTXTRecord(recordData)
    for (key, data) in txtRecord {
        HAPPlatformServiceDiscoveryLog("Txt record: \(key):\(String(data: data, encoding: .utf8) ?? "0x" + data.toHexadecimal())")
    }
}
