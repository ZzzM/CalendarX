//
//  MainViewModel.swift
//  CalendarX
//
//  Created by zm on 2022/1/27.
//

import SwiftUI

class MainViewModel: ObservableObject {
    
    private let pref = Preference.shared
    
    private let calendarPref = CalendarPreference.shared
    
    @Published
    var interval: TimeInterval
    
    @Published
    var date: Date
    
    var weekday: CalWeekday { calendarPref.weekday }
    
    var showEvents: Bool { calendarPref.showEvents }
    
    var showLunar: Bool { calendarPref.showLunar }
    
    var showHolidays: Bool { calendarPref.showHolidays }
    
    var colorScheme: ColorScheme? { pref.colorScheme }
    
    var tint: Color { pref.color }
    
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
            .map { _ in Date().timeIntervalSince1970 }
            .receive(on: DispatchQueue.main)
            .assign(to: &$interval)
    }
    
    func lastMonth() {
        date.lastMonth()
    }
    
    func nextMonth() {
        date.nextMonth()
    }
    
    func reset() {
        date = Date()
    }

}
