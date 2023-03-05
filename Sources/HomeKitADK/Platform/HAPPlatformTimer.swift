//
//  HAPPlatformTimer.swift
//  
//
//  Created by Alsey Coleman Miller on 3/5/23.
//

import Foundation
import CoreFoundation
import Dispatch
import CHomeKitADK

fileprivate func HAPPlatformTimerLog(_ message: String) {
    HAPLog(kHAPPlatform_LogSubsystem, "Timer", message)
}

#if DEBUG
private let log = HAPPlatformTimerLog
#else
private let log: (String) -> () = { _ in }
#endif

@_silgen_name("HAPPlatformTimerRegister")
public func HAPPlatformTimerRegister(
    timer timerPointer: inout UnsafeMutableRawPointer,
    deadline: HAPTime,
    callback: HAPPlatformTimerCallback,
    context: UnsafeMutableRawPointer
) -> CHomeKitADK.HAPError {
    log("Register timer")
    let timer: Timer
    if Thread.isMainThread {
        timer = .homeKitScheduled(
            deadline: deadline,
            callback: callback,
            context: context
        )
    } else {
        // needs to be sync since timer has to be updated, but can only
        // do this if not already on the main thread
        timer = DispatchQueue.main.sync {
            return .homeKitScheduled(
                deadline: deadline,
                callback: callback,
                context: context
            )
        }
    }
    timerPointer = Unmanaged<Timer>.passRetained(timer).toOpaque()
    return kHAPError_None
}

@_silgen_name("HAPPlatformTimerDeregister")
public func HAPPlatformTimerDeregister(
    timer: UnsafeRawPointer
) {
    log("Deregister timer")
    Unmanaged<Timer>.fromOpaque(timer).release()
}

internal extension Timer {
    
    static func homeKitScheduled(
        deadline: HAPTime,
        callback: HAPPlatformTimerCallback,
        context: UnsafeMutableRawPointer
    ) -> Timer {
        let currentTime = HAPPlatformClockGetCurrent()
        let interval: TimeInterval
        if (deadline > currentTime) {
            interval = TimeInterval(deadline - currentTime) / 1000.0
        } else {
            interval = 0
        }
        return .scheduledTimer(withTimeInterval: interval, repeats: false) { timer in
            log("Timer fired on thread \(Thread.current.description)")
            let timerPointer = Unmanaged<Timer>.passUnretained(timer).toOpaque()
            callback(UInt(bitPattern: timerPointer), context)
        }
    }
}
