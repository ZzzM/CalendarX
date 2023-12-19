//
//  CalendarPreference.swift
//  CalendarX
//
//  Created by zm on 2023/3/2.
//

import SwiftUI
import CalendarXShared
import WidgetKit

struct CalendarPreference  {
    
    static let shared = CalendarPreference()
    
    @AppStorage(CalendarStorageKey.weekday, store: .group)
    var weekday: AppWeekday = .sunday
    
    @AppStorage(CalendarStorageKey.showEvents, store: .group)
    var showEvents: Bool = false
    
    @AppStorage(CalendarStorageKey.showLunar, store: .group)
    var showLunar: Bool = true
    
    @AppStorage(CalendarStorageKey.showHolidays, store: .group)
    var showHolidays: Bool = true
    
}

extension CalendarPreference {
    static func check() {
        WidgetCenter.shared.reloadAllTimelines()
        if EventHelper.isAuthorized { return }
        guard shared.showEvents else { return }
        shared.showEvents = false
    }
}
