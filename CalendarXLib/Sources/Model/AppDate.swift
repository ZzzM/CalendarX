import EventKit
import SwiftUI

public typealias AppDateFormatter = DateFormatter
public typealias AppWeekday = EKWeekday
public typealias AppAuthorizationStatus = EKAuthorizationStatus
public typealias AppEventStore = EKEventStore
public typealias AppEvent = EKEvent
public typealias AppDate = Date

@MainActor
extension AppDateFormatter {
    private static let shared = AppDateFormatter()

    static func monthSymbol(index: Int, locale: Locale) -> String {
        shared.locale = locale
        return shared.shortMonthSymbols[index]
    }

    static func weekdaySymbol(index: Int, locale: Locale) -> String {
        shared.locale = locale
        return shared.shortWeekdaySymbols[index]
    }

    static func weekday(index: Int, locale: Locale) -> String {
        shared.locale = locale
        return shared.weekdaySymbols[index]
    }

    static func shortWeekday(index: Int, locale: Locale) -> String {
        shared.locale = locale
        return locale.inChinese
            ? shared.veryShortWeekdaySymbols[index] : shared.shortWeekdaySymbols[index]
    }

    static func eventTimeline(date: AppDate) -> String {
        shared.locale = .posix
        shared.dateFormat = "yyyy-MM-dd HH:mm"
        return shared.string(from: date)
    }

    static func sd(date: AppDate, locale: Locale) -> String {
        shared.locale = locale
        shared.dateFormat = locale.inChinese ? "d日" : "d"
        return shared.string(from: date)
    }

    static func e(date: AppDate, locale: Locale) -> String {
        shared.locale = locale
        shared.dateFormat = "E"
        return shared.string(from: date)
    }

    static func a(date: AppDate, locale: Locale) -> String {
        shared.locale = locale
        shared.dateFormat = "a"
        return shared.string(from: date)
    }

    static func t(date: AppDate, use24h: Bool, showSeconds: Bool) -> String {
        shared.locale = .posix
        shared.dateFormat = (use24h ? "HH:mm" : "h:mm") + (showSeconds ? ":ss" : "")
        return shared.string(from: date)
    }

}

extension AppEvent {
    public var color: Color { .init(cg: calendar.cgColor) }
    public var eventsKey: String { startDate.eventsKey }
}

@MainActor
extension AppWeekday {

    public static let allCases: [Self] = [.sunday, .monday, .tuesday, wednesday, thursday, friday, saturday]

    public func symbol(locale: Locale) -> String {
        AppDateFormatter.weekdaySymbol(index: rawValue - 1, locale: locale)
    }
}

@MainActor
extension AppDate {

    public var title: String { day.description }
    public var lunarDateTitle: String {
        (isLeapMonth ? "[润]" : "") + lunarMonthString + lunarDayString
    }
    public var lunarYearTitle: String {

        let shengxiao = Lunar.shengxiao
        let tiangan = Lunar.tiangan
        let dizhi = Lunar.dizhi

        let sIndex = (lunarYear - 1) % shengxiao.count
        let tIndex = (lunarYear - 1) % tiangan.count
        let dIndex = (lunarYear - 1) % dizhi.count

        return tiangan[tIndex] + dizhi[dIndex] + shengxiao[sIndex] + "年"
    }
    private var lunarMonthString: String { Lunar.months[lunarMonth - 1] }
    private var lunarDayString: String { Lunar.days[lunarDay - 1] }

    private var lunarMonthTitle: String { (isLeapMonth ? "润" : "") + lunarMonthString }

    var lunarDayTitle: String { lunarDay == 1 ? lunarMonthTitle : lunarDayString }
    var sYKey: String { year.description }
    var sMDKey: String { String(format: "%02d%02d", month, day) }
    var sMWKey: String { String(format: "%02d%d%d", month, weekdayOrdinal, weekday) }
    var lMDKey: String { String(format: "%02d%02d", lunarMonth, lunarDay) }

}

@MainActor
extension AppDate {

    public var eventTimeline: String { AppDateFormatter.eventTimeline(date: self) }

    public func weekOfYearString(calendar: Calendar) -> String {
        "\(calendar.component(.weekOfYear, from: self))"
    }

    public func weekOfYearTitle(calendar: Calendar, locale: Locale) -> String {
        let weekday = AppDateFormatter.weekday(index: weekday - 1, locale: locale)
        let weekOfYear = weekOfYearString(calendar: calendar)
        return locale.inChinese
            ? "第\(weekOfYear)周 \(weekday)" : "Week \(weekOfYear), \(weekday)"
    }

    public func shortWeekday(locale: Locale) -> String { AppDateFormatter.shortWeekday(index: weekday - 1, locale: locale) }

    public func monthSymbol(index: Int = -1, locale: Locale) -> String {
        AppDateFormatter.monthSymbol(index: (index < 0 ? month : index) - 1, locale: locale)
    }

}

// MARK: Menubar Date&Time Style
@MainActor
extension AppDate {
    public var lm: String { lunarMonthString }

    public var ld: String { lunarDayString }

    public func sm(locale: Locale) -> String { monthSymbol(locale: locale) }

    public func sd(locale: Locale) -> String { AppDateFormatter.sd(date: self, locale: locale) }

    public func e(locale: Locale) -> String { AppDateFormatter.e(date: self, locale: locale) }

    public func a(locale: Locale) -> String { AppDateFormatter.a(date: self, locale: locale) }

    public func t(use24h: Bool, showSeconds: Bool) -> String {
        AppDateFormatter.t(date: self, use24h: use24h, showSeconds: showSeconds)
    }
}
