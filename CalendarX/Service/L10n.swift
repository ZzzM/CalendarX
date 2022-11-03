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
        static let text = "menubarStyle.text".l10nKey
        static let date = "menubarStyle.date".l10nKey
        static let tips = "menubarStyle.tips".l10nKey
        static let save = "menubarStyle.save".l10nKey
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

//    static func statusBarTitle() -> String {
//
//        let style = Preference.shared.menuBarStyle
//        if .date == style {
//            return dateString(from: Preference.shared.menuBarDateFormat)
//        } else if .text == style {
//            return Preference.shared.menuBarText
//        } else {
//            return XDate().day.description
//        }
//
//    }


    static func dateString(from dateFormat: String) -> String {
        formatter.locale = locale
        formatter.dateFormat = dateFormat
        return formatter.string(from: XDate())
    }

}


