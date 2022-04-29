//
//  CalendarXApp.swift
//  CalendarX
//
//  Created by zm on 2021/12/1.
//

import SwiftUI

@main
struct CalendarXApp: App {

    @NSApplicationDelegateAdaptor(CalendarXDelegate.self)
    private var delegate

    var body: some Scene {
        Settings {
            EmptyView()
        }
    }
}

class CalendarXDelegate: NSObject & NSApplicationDelegate {

    lazy var popover = MenuBarPopover(RootView())
    lazy var controller =  MenuBarController(popover)
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        _ = controller
    }

}


