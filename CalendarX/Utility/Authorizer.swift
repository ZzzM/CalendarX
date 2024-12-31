//
//  Authorizer.swift
//  CalendarX
//
//  Created by zm on 2024/12/25.
//


import SwiftUI
@preconcurrency import UserNotifications
import CalendarXLib


@MainActor
struct Authorizer {

    enum Status {
        case unknown
        case notRequested
        case granted
        case denied
    }

}

extension Authorizer {
    var notificationsuStatus: Status {
        get async {
            await UNUserNotificationCenter.current().notificationSettings().authorizationStatus.map
        }
    }

    var allowNotifications: Bool {
        get async {
            await notificationsuStatus == .granted
        }
    }

    func requestNotificationsAuthorization() async -> Bool {
        do {
            return try await UNUserNotificationCenter.current().requestAuthorization(options: [.badge, .alert, .sound])
        } catch {
            return false
        }
    }
}

extension Authorizer {
    
    var eventsStatus: Status {
        AppEventStore.authorizationStatus(for: .event).map
    }

    var allowFullAccessToEvents: Bool {
        eventsStatus == .granted
    }

    func requestEventsAuthorization() async -> Bool {
        do {
            return if #available(macOS 14.0, *) {
                try await AppEventStore().requestFullAccessToEvents()
            } else {
                try await AppEventStore().requestAccess(to: .event)
            }
        } catch {
            return false
        }
    }

}

extension AppAuthorizationStatus {
    var map: Authorizer.Status {
        if #available(macOS 14.0, *) {
            switch self {
            case .denied, .restricted, .writeOnly: .denied
            case .fullAccess: .granted
            case .notDetermined: .notRequested
            default: .notRequested
            }
        } else {
            switch self {
            case .denied, .restricted: .denied
            case .authorized: .granted
            case .notDetermined: .notRequested
            default: .notRequested
            }
        }

    }
}

extension UNAuthorizationStatus {
    var map: Authorizer.Status {
        switch self {
        case .denied: .denied
        case .authorized: .granted
        case .notDetermined, .provisional: .notRequested
        default: .notRequested
        }
    }
}
