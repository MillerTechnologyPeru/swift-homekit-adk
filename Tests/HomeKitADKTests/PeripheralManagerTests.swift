//
//  PeripheralManagerTests.swift
//  
//
//  Created by Alsey Coleman Miller on 3/4/23.
//

import Foundation
import XCTest
import Bluetooth
@testable import HomeKitADK

final class PeripheralManagerTests: XCTestCase {
    
    typealias DeviceAddress = HAPPlatformBLEPeripheralManagerDeviceAddress
    
    typealias DeviceUUID = HAPPlatformBLEPeripheralManagerUUID
    
    func testDeviceAddress() {
        let string = "54:7D:D1:78:A6:3A"
        guard let address = DeviceAddress(rawValue: string) else {
            XCTFail()
            return
        }
        XCTAssertEqual(address.rawValue, string)
        XCTAssertEqual(address.description, string)
        XCTAssertEqual(BluetoothAddress(rawValue: string), BluetoothAddress(homeKit: address))
    }
    
    func testUUID() {
        let string = "55A58486-6C37-4D6A-B2DB-CCD52DE9C84A"
        guard let uuid = DeviceUUID(rawValue: string) else {
            XCTFail()
            return
        }
        XCTAssertEqual(uuid.rawValue, string)
        XCTAssertEqual(uuid.description, string)
        XCTAssertEqual(BluetoothUUID(rawValue: string), BluetoothUUID(homeKit: uuid))
    }
}
