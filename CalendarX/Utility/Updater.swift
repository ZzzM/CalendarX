//
//  Updater.swift
//  CalendarX
//
//  Created by zm on 2023/2/22.
//

import AppKit
import CalendarXLib
import Sparkle
import SwiftUI
@preconcurrency import UserNotifications

@MainActor
class Updater: NSObject {

    private let UpdateNotificationId = "UpdateNotificationId"

    private lazy var updaterController = SPUStandardUpdaterController(
        startingUpdater: false,
        updaterDelegate: self,
        userDriverDelegate: self
    )

    private let appStore: AppStore

    @AppStorage(AppStorageKey.includeBetaChannel, store: .group)
    var includeBetaChannel = false


    var automaticallyChecksForUpdates: Bool {
        get {
            updaterController.updater.automaticallyChecksForUpdates
        }
        set {
            updaterController.updater.automaticallyChecksForUpdates = newValue
        }
    }

    init(appStore: AppStore) {
        self.appStore = appStore
        super.init()
        updaterController.startUpdater()
        UNUserNotificationCenter.current().delegate = self
    }

    func checkForUpdates() {
        updaterController.checkForUpdates(.none)
    }
}

extension Updater: @preconcurrency SPUUpdaterDelegate {
    public func allowedChannels(for updater: SPUUpdater) -> Set<String> {
        includeBetaChannel ? ["beta"]:[]
    }
}


extension Updater: @preconcurrency SPUStandardUserDriverDelegate {

    var supportsGentleScheduledUpdateReminders: Bool { true }

    func standardUserDriverShouldHandleShowingScheduledUpdate(
        _ update: SUAppcastItem,
        andInImmediateFocus immediateFocus: Bool
    ) -> Bool {
        false
    }

    func standardUserDriverWillHandleShowingUpdate(
        _ handleShowingUpdate: Bool,
        forUpdate update: SUAppcastItem,
        state: SPUUserUpdateState
    ) {
        if state.userInitiated { return }
        let version = "\(update.displayVersionString)(\(update.versionString))"
        let title = L10n.Updater.title(locale: appStore.locale)
        let body = L10n.Updater.body(locale: appStore.locale, version: version)
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default
        let request = UNNotificationRequest(identifier: UpdateNotificationId, content: content, trigger: .none)
        UNUserNotificationCenter.current().add(request)
    }

    func standardUserDriverDidReceiveUserAttention(forUpdate update: SUAppcastItem) {
        UNUserNotificationCenter.current().removeDeliveredNotifications(withIdentifiers: [UpdateNotificationId])
    }
}

extension Updater: @preconcurrency UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification) async
        -> UNNotificationPresentationOptions
    {
        [.badge, .list, .sound, .banner]
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse) async {
        guard response.notification.request.identifier == UpdateNotificationId else { return }
        guard response.actionIdentifier == UNNotificationDefaultActionIdentifier else { return }
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            checkForUpdates()
        }
    }
}
