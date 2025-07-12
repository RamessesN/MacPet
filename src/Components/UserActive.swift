//
//  UserActive.swift
//  macPet
//
//  Created by 赵禹惟 on 2025/7/13.
//

import IOKit
import Foundation

func getUserTime() -> TimeInterval {
    var iterator: io_iterator_t = 0
    let result = IOServiceGetMatchingServices(kIOMainPortDefault, IOServiceMatching("IOHIDSystem"), &iterator)
    guard result == KERN_SUCCESS else { return 0 }

    let entry: io_registry_entry_t = IOIteratorNext(iterator)
    IOObjectRelease(iterator)
    guard entry != 0 else { return 0 }

    var properties: Unmanaged<CFMutableDictionary>?
    guard IORegistryEntryCreateCFProperties(entry, &properties, kCFAllocatorDefault, 0) == KERN_SUCCESS,
          let prop = properties?.takeUnretainedValue() as? [String: Any],
          let idleNS = prop["HIDIdleTime"] as? UInt64 else {
        IOObjectRelease(entry)
        return 0
    }

    IOObjectRelease(entry)
    let idleTimeInSec = Double(idleNS) / 1_000_000_000
    return idleTimeInSec
}
