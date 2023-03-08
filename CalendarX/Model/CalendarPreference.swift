//
//  CalendarPreference.swift
//  CalendarX
//
//  Created by zm on 2023/3/2.
//

import SwiftUI

struct CalendarPreference  {
    
    static let shared = CalendarPreference()
    
    @AppStorage(CalendarStorageKey.weekday, store: .group)
    var weekday: CalWeekday = .sunday
    
    @AppStorage(CalendarStorageKey.showEvents, store: .group)
    var showEvents: Bool = false
    
    @AppStorage(CalendarStorageKey.showLunar, store: .group)
    var showLunar: Bool = true
    
    @AppStorage(CalendarStorageKey.showHolidays, store: .group)
    var showHolidays: Bool = true
    
}
