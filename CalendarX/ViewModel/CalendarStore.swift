//
//  CalendarViewModel.swift
//  CalendarStore
//
//  Created by zm on 2024/12/25.
//

import CalendarXLib
import SwiftUI

@MainActor
class CalendarStore: ObservableObject {
    
    @AppStorage(CalendarStorageKey.weekday, store: .group)
    var weekday: AppWeekday = .sunday

    @AppStorage(CalendarStorageKey.showEvents, store: .group)
    var showEvents: Bool = false

    @AppStorage(CalendarStorageKey.showLunar, store: .group)
    var showLunar: Bool = true

    @AppStorage(CalendarStorageKey.showHolidays, store: .group)
    var showHolidays: Bool = true

    @AppStorage(CalendarStorageKey.keyboardShortcut, store: .group)
    var keyboardShortcut: Bool = true
}
