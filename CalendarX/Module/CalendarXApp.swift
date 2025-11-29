//
//  CalendarXApp.swift
//  CalendarX
//
//  Created by zm on 2021/12/1.
//

import CalendarXLib
import SwiftUI
import WidgetKit

extension EnvironmentValues {
    @Entry
    var authorizer = Authorizer()
}

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

@MainActor
class CalendarXDelegate: NSObject & NSApplicationDelegate {

    private var menubarController: MenubarController?

    func applicationWillFinishLaunching(_ notification: Notification) {
        NSRunningApplication
            .runningApplications(withBundleIdentifier: Bundle.identifier)
            .filter(\.isFinishedLaunching)
            .forEach { $0.terminate() }
    }

    func applicationDidFinishLaunching(_ notification: Notification) {

        let appStore = AppStore()
        let menubarStore = MenubarStore()
        let calendarStore = CalendarStore()
        let router = Router()
        let dialog = Dialog()
        let authorizer = Authorizer()
        let updater = Updater(appStore: appStore)

        bootstrap(calendarStore: calendarStore, authorizer: authorizer, updater: updater)

        let rootScreen = RootScreen(updater: updater)
            .environment(\.authorizer, authorizer)
            .environmentObject(appStore)
            .environmentObject(menubarStore)
            .environmentObject(calendarStore)
            .environmentObject(router)
            .environmentObject(dialog)
        let popover = MenubarPopover(router, rootScreen: rootScreen)

        menubarController = MenubarController(appStore: appStore, menubarStore: menubarStore, popover: popover)

    }
}

extension CalendarXDelegate {

    private func bootstrap(calendarStore: CalendarStore, authorizer: Authorizer, updater: Updater) {
        resolveEventsAuthorization(authorizer: authorizer, calendarStore: calendarStore)
        resolveNotificationsAuthorization(authorizer: authorizer, updater: updater)
        NotificationCenter.default
            .addObserver(forName: .NSCalendarDayChanged, object: .none, queue: .main) { _ in
                NotificationCenter.default.post(name: .calendarDayChanged, object: .none)
            }
    }

    private func resolveEventsAuthorization(authorizer: Authorizer, calendarStore: CalendarStore) {
        WidgetCenter.shared.reloadAllTimelines()
        if authorizer.allowFullAccessToEvents { return }
        if calendarStore.showEvents { calendarStore.showEvents.toggle() }
    }

    private func resolveNotificationsAuthorization(authorizer: Authorizer, updater: Updater) {
        Task {
            if await authorizer.allowNotifications { return }
            if updater.automaticallyChecksForUpdates {
                updater.automaticallyChecksForUpdates.toggle()
            }
        }
    }
}
