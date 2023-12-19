//
//  Date+.swift
//  CalendarX
//
//  Created by zm on 2022/2/21.
//

import Foundation

public extension Date {
    
    var isInvalidNextWeekday: Bool {
        let components = DateComponents(calendar: .gregorian, year: year, month: month, weekday: weekday, weekdayOrdinal: weekdayOrdinal + 1)
        return !components.isValidDate
    }


    func inSameMonth(as date: Date) -> Bool {
        Calendar.gregorian.isDate(self, equalTo: date, toGranularity: .month)
    }

    func isSameDay(as date: Date) -> Bool {
        Calendar.gregorian.isDate(self, inSameDayAs: date)
    }

    var inToday: Bool {
        Calendar.gregorian.isDateInToday(self)
    }

    var inWeekend: Bool {
        Calendar.gregorian.isDateInWeekend(self)
    }

    var weekday: Int {
        Calendar.gregorian.component(.weekday, from: self)
    }

    var weekOfMonth: Int {
        Calendar.gregorian.component(.weekOfMonth, from: self)
    }

    var weekdayOrdinal: Int {
        Calendar.gregorian.component(.weekdayOrdinal, from: self)
    }

    var year: Int {
        get {
            return Calendar.gregorian.component(.year, from: self)
        }
        set {
            guard newValue > 0 else { return }
            added(component: .year, value: newValue - year)
        }
    }

    var month: Int {
        get {
            return Calendar.gregorian.component(.month, from: self)
        }
        set {
            guard newValue > 0 else { return }
            added(component: .month, value: newValue - month)
        }
    }

    var day: Int {
        Calendar.gregorian.component(.day, from: self)
    }

    var yesterday: Date {
        adding(component: .day, value: -1)
    }

    var tomorrow: Date {
        adding(component: .day, value: 1)
    }


    mutating func lastMonth() {
        added(component: .month, value: -1)
    }

    mutating func nextMonth() {
        added(component: .month, value: 1)
    }

    var startOfTomorrow: Date {
        let startOfDay = Calendar.gregorian.startOfDay(for: self)
        return Calendar.gregorian.date(byAdding: .day, value: 1, to: startOfDay) ?? self
    }

    var startOfMonth: Date {
        let components = Calendar.gregorian.dateComponents([.year, .month], from: self)
        return Calendar.gregorian.date(from: components) ?? self
    }

    var nextMin: Date {
        var components = Calendar.gregorian.dateComponents([.year, .month, .day, .hour, .minute], from: self)
        components.minute! += 1
        return Calendar.gregorian.date(from: components) ?? self
    }

    var nextSec: Date {
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

public extension Date {
    
    var lunarYear: Int {
        Calendar.chinese.component(.year, from: self)
    }

    var lunarMonthString: String {
        Lunar.months[lunarMonth - 1]
    }

    var lunarDayString: String {
        Lunar.days[lunarDay - 1]
    }

    var lunarMonth: Int {
        Calendar.chinese.component(.month, from: self)
    }

    var lunarDay: Int {
        Calendar.chinese.component(.day, from: self)
    }

    var isLeapMonth: Bool {
        Calendar.chinese.dateComponents([.year, .month, .day], from: self).isLeapMonth ?? false
    }
}
