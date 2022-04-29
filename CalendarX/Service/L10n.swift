//
//  L10n.swift
//  CalendarX
//
//  Created by zm on 2022/3/30.
//

import Foundation

typealias XDate = Date

struct L10n {

    private static let formatter = DateFormatter()

    private static var locale: Locale { Preference.shared.locale }

    static var inChinese: Bool { locale.identifier.contains("zh") }

    enum Settings {
        static let title = "settings.title".l10nKey
        static let menuBarStyle = "settings.menuBarStyle".l10nKey
        static let theme = "settings.theme".l10nKey
        static let tint = "settings.tint".l10nKey
        static let showSchedule = "settings.showSchedule".l10nKey
        static let startWeekOn = "settings.startWeekOn".l10nKey
        static let launchAtLogin = "settings.launchAtLogin".l10nKey
        static let version = "settings.version".l10nKey
        static let checkForUpdates = "settings.checkForUpdates".l10nKey
        static let quitApp = "settings.quitApp".l10nKey
    }

    enum Theme {
        static let system = "theme.system".l10nKey
        static let dark = "theme.dark".l10nKey
        static let light = "theme.light".l10nKey
    }

    enum MenubarStyle {
        static let `default` = "menubarStyle.default".l10nKey
    }

    enum Date {
        static let festivals = "date.festivals".l10nKey
        static let schedules = "date.schedules".l10nKey
        static let noFestivals = "date.noFestivals".l10nKey
        static let noSchedules = "date.noSchedules".l10nKey
    }

    static func timeline(from date: XDate) -> String {
        formatter.locale = locale
        formatter.dateFormat = inChinese ? "M月d日 a h:mm":"MMM d, h:mm a"
        return formatter.string(from: date)
    }

    static func shortWeekday(from date: XDate) -> String {
        formatter.locale = locale
        return inChinese ? formatter.veryShortWeekdaySymbols[date.weekday - 1] :
        formatter.shortWeekdaySymbols[date.weekday - 1]
    }

    static func monthSymbol(from month: Int) -> String {
        formatter.locale = locale
        return formatter.shortMonthSymbols[month - 1]
    }


    static func weekdaySymbol(from weekday: XWeekday) -> String {
        formatter.locale = locale
        return formatter.shortWeekdaySymbols[weekday.rawValue - 1]
    }

    static func statusBarTitle(from date: XDate = XDate(), style: MenuBarStyle = Preference.shared.menuBarStyle) -> String {
        formatter.locale = locale
        if let dateFormat = statusBarFormat(from: style)  {
            formatter.dateFormat = dateFormat
            return formatter.string(from: date)
        } else {
            return date.day.description
        }
    }

    private static func statusBarFormat(from style: MenuBarStyle) -> String? {
        switch style {
        case .style1: return inChinese ? "M月d日 EE HH:mm" : "E, MMM d, HH:mm"
        case .style2: return inChinese ? "M月d日 EE" : "E, MMM d"
        case .style3: return inChinese ? "M月d日 HH:mm" : "MMM d, HH:mm"
        case .style4: return inChinese ? "EE HH:mm" : "E, HH:mm"
        default: return .none
        }
    }
}


