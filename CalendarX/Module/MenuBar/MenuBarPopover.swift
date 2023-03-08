//
//  MenubarPopover.swift
//  CalendarX
//
//  Created by zm on 2022/1/4.
//

import AppKit
import SwiftUI

class MenubarPopover: NSPopover {

    init<Content>(_ rootView: Content) where Content : View {
        super.init()
        contentViewController = NSHostingController(rootView: rootView)
        contentSize = .init(width: .mainWidth, height: .mainHeight)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func show(_ sender: Any?) {
        guard let button = sender as? NSStatusBarButton else { return }
        show(relativeTo: button.bounds, of: button, preferredEdge: .minY)
        contentViewController?.view.window?.becomeKey()
    }

    override func close() {
        super.close()
        contentViewController?.view.window?.resignKey()
    }

}

