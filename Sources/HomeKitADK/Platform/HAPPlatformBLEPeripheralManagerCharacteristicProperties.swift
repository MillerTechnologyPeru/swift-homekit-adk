//
//  HAPPlatformBLEPeripheralManagerCharacteristicProperties.swift
//  
//
//  Created by Alsey Coleman Miller on 3/4/23.
//

import Foundation
import CoreFoundation
import Bluetooth
import GATT
import CHomeKitADK

public extension BitMaskOptionSet where Self.Element == GATT.CharacteristicProperty {
    
    init(homeKit properties: HAPPlatformBLEPeripheralManagerCharacteristicProperties) {
        self.init()
        if properties.read {
            insert(.read)
        }
        if properties.write {
            insert(.write)
        }
        if properties.writeWithoutResponse {
            insert(.writeWithoutResponse)
        }
        if properties.notify {
            insert(.notify)
        }
        if properties.indicate {
            insert(.indicate)
        }
    }
}

public extension BitMaskOptionSet where Self.Element == ATTAttributePermission {
    
    init(homeKit properties: HAPPlatformBLEPeripheralManagerCharacteristicProperties) {
        self.init()
        if properties.read || properties.notify || properties.indicate {
            insert(.read)
        }
        if properties.write || properties.writeWithoutResponse {
            insert(.write)
        }
    }
}
