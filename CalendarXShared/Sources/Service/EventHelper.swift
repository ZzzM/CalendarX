//
//  EventHelper.swift
//  CalendarX
//
//  Created by zm on 2022/2/23.
//


import EventKit

public struct EventHelper {

    private static var store = EKEventStore()

    private static var authorizationStatus: EKAuthorizationStatus {
        EKEventStore.authorizationStatus(for: .event)
    }

    public static var isDenied: Bool {
        authorizationStatus == .denied ||
        authorizationStatus == .restricted
    }
    
    public static var isNotDetermined: Bool {
        authorizationStatus == .notDetermined
    }

    public static var isAuthorized: Bool {
        if #available(macOS 14.0, *) {
            authorizationStatus == .fullAccess
        } else {
            authorizationStatus == .authorized
        }
    }

    public static func requestAccess() async -> Bool {
        do {
            if #available(macOS 14.0, *) {
                return try await store.requestFullAccessToEvents()
            } else {
                return try await store.requestAccess(to: .event)
            }
        } catch {
            return false
        }
    }

    public static func fetchEvents(with start: Date, end: Date) -> [AppEvent] {

        let calendars = store.calendars(for: .event).filter {
            "中国大陆节假日" != $0.title
        }
        let predicate = store.predicateForEvents(withStart: start.yesterday, end: end.tomorrow, calendars: calendars)

        return store.events(matching: predicate)

    }
}
