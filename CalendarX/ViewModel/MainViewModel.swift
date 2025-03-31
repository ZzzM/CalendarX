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

        if #available(macOS 12.0, *) {
            Task { [weak self] in
                for await value in NotificationCenter.default
                    .notifications(named: .NSCalendarDayChanged)
                    .compactMap({ _ in Date() })
                {
                    guard let self else { return }
                    date = value
                }
            }
        } else {
            NotificationCenter.default
                .publisher(for: .NSCalendarDayChanged)
                .map { _ in Date() }
                .assign(to: &$date)
        }

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

