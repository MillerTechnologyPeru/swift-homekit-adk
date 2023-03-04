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
        
        let uuids: [(UInt32, String)] = [
            (0x00000000, "00000000-0000-1000-8000-0026BB765291"),
            (0x00000001, "00000001-0000-1000-8000-0026BB765291"),
            (0x00000002, "00000002-0000-1000-8000-0026BB765291"),
            (0x00000003, "00000003-0000-1000-8000-0026BB765291"),
            (0xFFFFFFFF, "FFFFFFFF-0000-1000-8000-0026BB765291")
        ]
        
        for (value, uuidString) in uuids {
            let uuid = HAPUUID(appleDefined: value)
            XCTAssert(uuid.isAppleDefined)
            XCTAssertEqual(UUID(homeKit: uuid), UUID(uuidString: uuidString))
            //XCTAssertEqual(uuid.description, value.toHexadecimal())
            XCTAssertEqual(UUID(homeKit: HAPUUID(appleDefined: value)).uuidString, uuidString)
        }
    }
    
    func testCustom() {
        let string = "34AB8811-AC7F-4340-BAC3-FD6A85F9943B"
        let uuid = HAPUUID(bytes: ( 0x3B, 0x94, 0xF9, 0x85, 0x6A, 0xFD, 0xC3, 0xBA, 0x40, 0x43, 0x7F, 0xAC, 0x11, 0x88, 0xAB, 0x34 ))
        XCTAssertFalse(uuid.isAppleDefined)
        //XCTAssertEqual(uuid.description, string)
        XCTAssertEqual(BluetoothUUID(homeKit: uuid).description, string)
        
        XCTAssertFalse(HAPUUID(uuid: UUID()).isAppleDefined)
        XCTAssertFalse(HAPUUID(uuid: UUID(uuidString: "7D99A285-5F8D-4349-841E-4FC8E4DA3C3A")!).isAppleDefined)
    }
}
