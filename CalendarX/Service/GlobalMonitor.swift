//
//  GlobalMonitor.swift
//  CalendarX
//
//  Created by zm on 2022/4/1.
//

import AppKit

class GlobalMonitor {
    private var monitor: Any?
    private let mask: NSEvent.EventTypeMask
    private let handler: (NSEvent?) -> Void

    init(mask: NSEvent.EventTypeMask = [.leftMouseDown, .rightMouseDown],
         handler: @escaping (NSEvent?) -> Void) {
        self.mask = mask
        self.handler = handler
    }
}

extension GlobalMonitor {
    func start() {
        monitor = NSEvent.addGlobalMonitorForEvents(matching: mask, handler: handler)
    }

    func stop() {
        guard monitor != nil else { return }
        NSEvent.removeMonitor(monitor!)
        monitor = .none
    }
}
