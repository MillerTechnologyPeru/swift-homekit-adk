//
//  HAPPlatformRunLoop.swift
//  
//
//  Created by Alsey Coleman Miller on 3/3/23.
//

import Foundation
import CoreFoundation
import Dispatch
import CHomeKitADK

/// `void HAPPlatformRunLoopCreate(const HAPPlatformRunLoopOptions* options)`
@_silgen_name("HAPPlatformRunLoopCreate")
public func _HAPPlatformRunLoopCreate(options: UnsafePointer<HAPPlatformRunLoopOptions>) {
    
}

@_silgen_name("HAPPlatformRunLoopRelease")
public func _HAPPlatformRunLoopRelease() {
    
}

/// `void HAPPlatformRunLoopRun(void)`
@_silgen_name("HAPPlatformRunLoopRun")
public func _HAPPlatformRunLoopRun() {
    CFRunLoopRun()
}

/// `void HAPPlatformRunLoopStop(void)`
@_silgen_name("HAPPlatformRunLoopStop")
public func _HAPPlatformRunLoopStop() {
    CFRunLoopStop(CFRunLoopGetCurrent())
}

/// ```
/// HAPError HAPPlatformRunLoopScheduleCallback(
///        HAPPlatformRunLoopCallback callback,
///        void* _Nullable context,
///        size_t contextSize)
///  ```
///
@_silgen_name("HAPPlatformRunLoopScheduleCallback")
public func _HAPPlatformRunLoopScheduleCallback(
    callback: HAPPlatformRunLoopCallback,
    context: UnsafeMutableRawPointer,
    contextSize: Int
) -> CHomeKitADK.HAPError {
    DispatchQueue.main.async {
        callback(context, contextSize)
    }
    return kHAPError_None
}
