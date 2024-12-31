//
//  Date+.swift
//  CalendarX
//
//  Created by zm on 2022/2/21.
//

import Foundation

extension Date {
    public var isInvalidNextWeekday: Bool {
        let components = DateComponents(
            calendar: .gregorian,
            year: year,
            month: month,
            weekday: weekday,
            weekdayOrdinal: weekdayOrdinal + 1
        )
        return !components.isValidDate
    }

    public func inSameMonth(as date: Date) -> Bool {
        Calendar.gregorian.isDate(self, equalTo: date, toGranularity: .month)
    }

    public func isSameDay(as date: Date) -> Bool {
        Calendar.gregorian.isDate(self, inSameDayAs: date)
    }

    public var inToday: Bool {
        Calendar.gregorian.isDateInToday(self)
    }

    public var inWeekend: Bool {
        Calendar.gregorian.isDateInWeekend(self)
    }

    public var weekday: Int {
        Calendar.gregorian.component(.weekday, from: self)
    }

    public var weekOfMonth: Int {
        Calendar.gregorian.component(.weekOfMonth, from: self)
    }

    public var weekdayOrdinal: Int {
        Calendar.gregorian.component(.weekdayOrdinal, from: self)
    }

    public var year: Int {
        get {
            return Calendar.gregorian.component(.year, from: self)
        }
        set {
            guard newValue > 0 else { return }
            added(component: .year, value: newValue - year)
        }
    }

    public var month: Int {
        get {
            return Calendar.gregorian.component(.month, from: self)
        }
        set {
            guard newValue > 0 else { return }
            added(component: .month, value: newValue - month)
        }
    }

    public var day: Int {
        Calendar.gregorian.component(.day, from: self)
    }

    public var yesterday: Date {
        adding(component: .day, value: -1)
    }

    public var tomorrow: Date {
        adding(component: .day, value: 1)
    }

    public mutating func lastMonth() {
        added(component: .month, value: -1)
    }

    public mutating func nextMonth() {
        added(component: .month, value: 1)
    }

    public mutating func lastYear() {
        added(component: .year, value: -1)
    }

    public mutating func nextYear() {
        added(component: .year, value: 1)
    }

    public var startOfTomorrow: Date {
        let startOfDay = Calendar.gregorian.startOfDay(for: self)
        return Calendar.gregorian.date(byAdding: .day, value: 1, to: startOfDay) ?? self
    }

    public var startOfMonth: Date {
        let components = Calendar.gregorian.dateComponents([.year, .month], from: self)
        return Calendar.gregorian.date(from: components) ?? self
    }

    public var nextMin: Date {
        var components = Calendar.gregorian.dateComponents([.year, .month, .day, .hour, .minute], from: self)
        components.minute! += 1
        return Calendar.gregorian.date(from: components) ?? self
    }

    public var nextSec: Date {
        var components = Calendar.gregorian.dateComponents([.year, .month, .day, .hour, .minute, .second], from: self)
        components.second! += 1
        return Calendar.gregorian.date(from: components) ?? self
    }

    private func adding(_ calendar: Calendar = .gregorian, component: Calendar.Component, value: Int) -> Date {
        calendar.date(byAdding: component, value: value, to: self) ?? self
    }

    private mutating func added(_ calendar: Calendar = .gregorian, component: Calendar.Component, value: Int) {
        if let date = calendar.date(byAdding: component, value: value, to: self) {
            self = date
        }
    }
}

extension Date {

    public var eventsKey: String { "\(year).\(month).\(day)" }

    public var lunarYear: Int {
        Calendar.chinese.component(.year, from: self)
    }

    public var lunarMonth: Int {
        Calendar.chinese.component(.month, from: self)
    }

    public var lunarDay: Int {
        Calendar.chinese.component(.day, from: self)
    }

    public var isLeapMonth: Bool {
        Calendar.chinese.dateComponents([.year, .month, .day], from: self).isLeapMonth ?? false
    }
}

extension Date: Swift.RawRepresentable {
    public var rawValue: String {
        timeIntervalSinceReferenceDate.description
    }

    public init?(rawValue: String) {
        self = Date(timeIntervalSinceReferenceDate: Double(rawValue) ?? 0.0)
    }
}
