//
//  MainViewModel.swift
//  CalendarX
//
//  Created by zm on 2022/1/27.
//

import CalendarXLib
import SwiftUI

@MainActor
class MainViewModel: ObservableObject {
 
    @Published
    var interval: TimeInterval

    @Published
    var date: Date
    
    var calendar: Calendar = .gregorian

    init() {
        date = Date()
        interval = Date().timeIntervalSince1970
        NotificationCenter.default
            .publisher(for: .EKEventStoreChanged)
            .map { _ in Date().timeIntervalSince1970 }
            .assign(to: &$interval)

        NotificationCenter.default
            .publisher(for: .calendarDayChanged)
            .map { _ in Date() }
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

