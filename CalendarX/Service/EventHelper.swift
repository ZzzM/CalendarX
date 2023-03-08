//
//  EventHelper.swift
//  CalendarX
//
//  Created by zm on 2022/2/23.
//


import EventKit

typealias CalEvent = EKEvent
typealias CalWeekday = EKWeekday

struct EventHelper {

    private static let store = EKEventStore()

    
    private static var authorizationStatus: EKAuthorizationStatus {
        EKEventStore.authorizationStatus(for: .event)
    }
    
    static var isDenied: Bool {
        authorizationStatus == .denied ||
        authorizationStatus == .restricted
    }
    
    static var isNotDetermined: Bool {
        authorizationStatus == .notDetermined
    }

    static var isAuthorized: Bool {
        authorizationStatus == .authorized
    }

    static func start() {
        if isAuthorized { return }
        guard CalendarPreference.shared.showEvents else { return }
        CalendarPreference.shared.showEvents = false
    }
    
    static func requestAccess() async -> Bool {
        do {
            return try await store.requestAccess(to: .event)
        } catch {
            return false
        }
    }

    static func fetchEvents(with start: Date, end: Date) -> [CalEvent] {

        guard isAuthorized else { return [] }
        let calendars = store.calendars(for: .event).filter {
            "中国大陆节假日" != $0.title
        }
        let predicate = store.predicateForEvents(withStart: start.yesterday, end: end.tomorrow, calendars: calendars)

        return store.events(matching: predicate)
    }
}
