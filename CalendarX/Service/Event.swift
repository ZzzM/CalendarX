//
//  Event.swift
//  CalendarX
//
//  Created by zm on 2022/2/23.
//


import EventKit

typealias XEvent = EKEvent
typealias XWeekday = EKWeekday

struct Event {

    private static let store = EKEventStore()

    private static var authorizationStatus: EKAuthorizationStatus {
        EKEventStore.authorizationStatus(for: .event)
    }

    static var isDenied: Bool {
        authorizationStatus == .denied ||
        authorizationStatus == .restricted
    }

    static var isAuthorized: Bool {
        EKEventStore.authorizationStatus(for: .event)  == .authorized
    }

    @MainActor
    static func requestAccess() async -> Bool {
        do {
            return try await store.requestAccess(to: .event)
        } catch {
            return false
        }
    }

    static func fetchEvents(with start: Date, end: Date) -> [XEvent] {

        guard isAuthorized else { return [] }
        let predicate = store.predicateForEvents(withStart: start.yesterday, end: end.tomorrow, calendars: .none)
        return store.events(matching: predicate)
    }
}
