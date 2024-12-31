//
//  MenubarPopover.swift
//  CalendarX
//
//  Created by zm on 2022/1/4.
//

import AppKit
import SwiftUI

@MainActor
class MenubarPopover: NSPopover {
    
    private let privateKey = "shouldHideAnchor"
    
    private var eventMonitor: Any?

    private let router: Router
    
    
    init<Content>(_ router: Router, rootScreen: Content) where Content: View {
        self.router = router
        super.init()
        contentViewController = NSHostingController(rootView: rootScreen)
        contentSize = .init(width: .mainWidth, height: .mainHeight)
        shouldHideAnchor()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func show(_ sender: Any?) {
        guard let button = sender as? NSStatusBarButton else { return }
        guard let event = NSApp.currentEvent else { return }
        router.set(event.isRightClicked ? .settings : .calendar)
        show(relativeTo: button.bounds, of: button, preferredEdge: .minY)
        contentViewController?.view.window?.becomeKey()
        startEventMonitor()
    }

    override func close() {
        router.set(.empty)
        super.close()
        contentViewController?.view.window?.resignKey()
        stopEventMonitor()
    }

}

extension MenubarPopover {

    func startEventMonitor() {
        eventMonitor = NSEvent.addGlobalMonitorForEvents(matching: [.leftMouseDown, .rightMouseDown] ) { [weak self] _ in
            guard let self else { return }
            guard isShown else { return }
            close()
        }
    }

    func stopEventMonitor() {
        guard eventMonitor != nil else { return }
        NSEvent.removeMonitor(eventMonitor!)
        eventMonitor = .none
    }
}


extension MenubarPopover {

    private func shouldHideAnchor() {
        if value(forKey: privateKey) is String {
            return
        }
        setValue(true, forKey: privateKey)
    }

    override func value(forUndefinedKey key: String) -> Any? {
        key == privateKey ? key : .none
    }

}
