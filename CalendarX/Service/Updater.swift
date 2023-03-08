//
//  Updater.swift
//  CalendarX
//
//  Created by zm on 2023/2/22.
//

import Sparkle
import UserNotifications
import Cocoa

class Updater: NSObject {
    
    static let version = " \(AppInfo.version) ( \(AppInfo.commitHash) ) "
    
    private static let UpdateNotificationId = "UpdateNotificationId"
    
    private static let shared = Updater()
    
    private lazy var controller = SPUStandardUpdaterController(startingUpdater: false,
                                                               updaterDelegate: .none,
                                                               userDriverDelegate: Self.shared)
    
    static var automaticallyChecksForUpdates: Bool {
        get {
            shared.controller.updater.automaticallyChecksForUpdates
        }
        set {
            shared.controller.updater.automaticallyChecksForUpdates = newValue
        }
    }
    
    static func start() {
        shared.controller.startUpdater()
        UNUserNotificationCenter.current().delegate = shared
        resetAutomaticallyChecksForUpdates()
    }
    
    static func resetAutomaticallyChecksForUpdates() {
        if isAuthorized { return }
        guard automaticallyChecksForUpdates else { return }
        automaticallyChecksForUpdates = false
    }
    
    static func checkForUpdates() {
        shared.controller.checkForUpdates(.none)
    }
    
}


extension Updater {
    
    private static var authorizationStatus: UNAuthorizationStatus? {
        let semaphore = DispatchSemaphore(value: 0)
        var notificationSettings: UNNotificationSettings?
        DispatchQueue.global().async {
            UNUserNotificationCenter.current().getNotificationSettings { settings in
                notificationSettings = settings
                semaphore.signal()
            }
        }
        semaphore.wait()
        return notificationSettings?.authorizationStatus
    }
    
    static var isNotDetermined: Bool {
        authorizationStatus == .notDetermined
    }
    
    static var isDenied: Bool {
        authorizationStatus == .denied
    }
    
    static var isAuthorized: Bool {
        authorizationStatus == .authorized
    }
    
    static func requestAuthorization() async -> Bool {
        do {
            return try await UNUserNotificationCenter.current().requestAuthorization(options: [.badge, .alert, .sound])
        } catch {
            return false
        }
    }
    
    // Notification

    private static func notify(_ title: String, body: String) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default
        let request = UNNotificationRequest(identifier: UpdateNotificationId, content: content, trigger: .none)
        UNUserNotificationCenter.current().add(request)
    }
    
    private static func remove() {
        UNUserNotificationCenter.current().removeDeliveredNotifications(withIdentifiers: [UpdateNotificationId])
    }
    
}

extension Updater: SPUStandardUserDriverDelegate {
    
    var supportsGentleScheduledUpdateReminders: Bool { true }
    
    
    func standardUserDriverShouldHandleShowingScheduledUpdate(_ update: SUAppcastItem, andInImmediateFocus immediateFocus: Bool) -> Bool {
        false
    }
    
    func standardUserDriverWillHandleShowingUpdate(_ handleShowingUpdate: Bool, forUpdate update: SUAppcastItem, state: SPUUserUpdateState) {
        if state.userInitiated { return }
        Self.notify(L10n.Updater.available, body: L10n.Updater.update(update.displayVersionString))
    }
    
    func standardUserDriverDidReceiveUserAttention(forUpdate update: SUAppcastItem) {
        Self.remove()
    }

}


extension Updater: UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification) async -> UNNotificationPresentationOptions {
        [.badge, .list, .sound, .banner]
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse) async {
        guard  response.notification.request.identifier == Self.UpdateNotificationId else { return }
        guard  response.actionIdentifier  == UNNotificationDefaultActionIdentifier else { return }
        Task { @MainActor in
            Self.checkForUpdates()
        }
    }

}
