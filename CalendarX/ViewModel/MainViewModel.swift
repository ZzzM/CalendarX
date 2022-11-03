//
//  MainViewModel.swift
//  CalendarX
//
//  Created by zm on 2022/1/27.
//

import SwiftUI

class MainViewModel: ObservableObject {


    @Published
    var date: Date

    @Published
    var timestamp: TimeInterval

    init() {
        date = Date()
        timestamp = Date().timeIntervalSince1970
        NotificationCenter.default
            .publisher(for: .EKEventStoreChanged)
            .map { _ in Date().timeIntervalSince1970 }
            .assign(to: &$timestamp)
        NotificationCenter.default
            .publisher(for: .NSCalendarDayChanged)
            .map { _ in Date().timeIntervalSince1970 }
            .assign(to: &$timestamp)
    }

    func nextMonth() { date.nextMonth() }

    func lastMonth() { date.lastMonth() }

    func today() { date = Date() }

}
