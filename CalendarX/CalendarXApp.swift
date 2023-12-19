//
//  CalendarXApp.swift
//  CalendarX
//
//  Created by zm on 2021/12/1.
//

import SwiftUI
import CalendarXShared

@main
struct CalendarXApp: App {

    @NSApplicationDelegateAdaptor(CalendarXDelegate.self)
    private var delegate
    
    init() {

        LaunchHelper.migrateIfNeeded()
        CalendarPreference.check()
        Updater.start()

    }

    var body: some Scene {
        Settings {
            EmptyView()
        }
    }
}

class CalendarXDelegate: NSObject & NSApplicationDelegate {

    lazy var rootView = RootView()
    lazy var popover = MenubarPopover(rootView)
    lazy var controller =  MenubarController(popover)

    func applicationWillFinishLaunching(_ notification: Notification) {

        NSRunningApplication
            .runningApplications(withBundleIdentifier: AppBundle.identifier)
            .filter { $0.isFinishedLaunching }
            .forEach { $0.terminate() }
        
    }
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        _ = controller
    }


}

