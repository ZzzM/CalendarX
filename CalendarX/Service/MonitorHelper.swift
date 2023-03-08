//
//  MonitorHelper.swift
//  CalendarX
//
//  Created by zm on 2022/4/1.
//

import AppKit

class MonitorHelper {
    
    private var monitor: Any?
    private var mask: NSEvent.EventTypeMask = []
    private let handler: (NSEvent?) -> Void

    init(mask: NSEvent.EventTypeMask = [.leftMouseDown, .rightMouseDown],
         handler: @escaping (NSEvent?) -> Void) {
        self.mask = mask
        self.handler = handler
    }

    deinit {
        stop()
    }
}

extension MonitorHelper {
    func start() {
        monitor = NSEvent.addGlobalMonitorForEvents(matching: mask, handler: handler)
    }

    func stop() {
        guard monitor != nil else { return }
        NSEvent.removeMonitor(monitor!)
        monitor = .none
    }
}
