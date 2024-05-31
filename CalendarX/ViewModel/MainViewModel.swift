//
//  MainViewModel.swift
//  CalendarX
//
//  Created by zm on 2022/1/27.
//

import SwiftUI
import Combine
import CalendarXShared

class MainViewModel: ObservableObject {
    
    private let pref = Preference.shared
    
    private let calendarPref = CalendarPreference.shared
    
    @Published
    var interval: TimeInterval
    
    @Published
    var date: Date

    var weekday: AppWeekday { calendarPref.weekday }

    var showEvents: Bool { calendarPref.showEvents }
    
    var showLunar: Bool { calendarPref.showLunar }
    
    var showHolidays: Bool { calendarPref.showHolidays }
    
    var keyboardShortcut: Bool { calendarPref.keyboardShortcut }

    var colorScheme: ColorScheme? { pref.colorScheme }

    var tint: Color { pref.accentColor }

    init() {
        date = Date()
        interval = Date().timeIntervalSince1970
        NotificationCenter.default
            .publisher(for: .EKEventStoreChanged)
            .map { _ in Date().timeIntervalSince1970 }
            .receive(on: DispatchQueue.main)
            .assign(to: &$interval)
        NotificationCenter.default
            .publisher(for: .NSCalendarDayChanged)
            .map { _ in Date() }
            .receive(on: DispatchQueue.main)
            .assign(to: &$date)
    }
    
    func lastMonth() {
        date.lastMonth()
    }
    
    func nextMonth() {
        date.nextMonth()
    }

    func lastYear() {
        date.lastYear()
    }

    func nextYear() {
        date.nextYear()
    }

    func reset() {
        date = Date()
    }


}
