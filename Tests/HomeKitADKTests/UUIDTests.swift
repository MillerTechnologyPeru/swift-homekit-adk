//
//  UUIDTests.swift
//  
//
//  Created by Alsey Coleman Miller on 3/3/23.
//

import Foundation
import XCTest
@testable import HomeKitADK
import Bluetooth

final class UUIDTests: XCTestCase {
     
    func testEqual() throws {
        XCTAssertEqual(HAPUUID(), HAPUUID())
        XCTAssertEqual(HAPUUID(appleDefined: 0x0000), HAPUUID(appleDefined: 0x0000))
        XCTAssertEqual(HAPUUID(appleDefined: 0x0001), HAPUUID(appleDefined: 0x0001))
    }
    
    func testAppleDefined() {
        XCTAssertEqual(UUID(homeKit: HAPUUID(appleDefined: 0x0000)).uuidString, "00000000-0000-1000-8000-0026BB765291")
        XCTAssertEqual(UUID(homeKit: HAPUUID(appleDefined: 0x0001)).uuidString, "00000001-0000-1000-8000-0026BB765291")
    }
    
    func testCustom() {
        let string = "34AB8811-AC7F-4340-BAC3-FD6A85F9943B"
        let uuid = HAPUUID(bytes: ( 0x3B, 0x94, 0xF9, 0x85, 0x6A, 0xFD, 0xC3, 0xBA, 0x40, 0x43, 0x7F, 0xAC, 0x11, 0x88, 0xAB, 0x34 ))
        XCTAssertFalse(uuid.isAppleDefined)
        //XCTAssertEqual(uuid.description, string)
        XCTAssertEqual(BluetoothUUID(homeKit: uuid).description, string)
    }
}
