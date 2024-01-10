//
//  L10n.swift
//  CalendarX
//
//  Created by zm on 2022/3/30.
//

import Foundation
import SwiftUI

public typealias L10Date = Date

public struct L10n {

    private static let formatter = DateFormatter()

    private static var locale: Locale { Preference.shared.locale }

    public static var inChinese: Bool { locale.inChinese }

    public enum Settings {
        public static let title = "settings.title".l10nKey
        public static let appearance = "settings.appearance".l10nKey
        public static let calendar = "settings.calendar".l10nKey
        public static let auto = "settings.auto".l10nKey
        public static let language = "settings.language".l10nKey
        public static let recommendations = "settings.recommendations".l10nKey
        public static let menubarStyle = "settings.menubarStyle".l10nKey
        public static let launchAtLogin = "settings.launchAtLogin".l10nKey
        public static let version = "settings.version".l10nKey
        public static let checkForUpdates = "settings.checkForUpdates".l10nKey
        public static let about = "settings.about".l10nKey
    }

    public enum Calendar {
        public static let showEvents = "calendar.showEvents".l10nKey
        public static let startWeekOn = "calendar.startWeekOn".l10nKey
        public static let showLunar = "calendar.showLunar".l10nKey
        public static let showHolidays = "calendar.showHolidays".l10nKey
        public static let keyboardShortcut = "calendar.keyboardShortcut".l10nKey
    }

    public enum Appearance {
        public static let hex = "appearance.hex".l10nKey
        public static let tint = "appearance.tint".l10nKey
    }

    public enum Alert {
        public static let exit = "alert.exit".l10nKey
        public static let notifications = "alert.notifications".l10nKey
        public static let calendars = "alert.calendars".l10nKey

        public static let exitMessage = "alert.exitMessage".l10nKey
        public static let notificationsMessage = "alert.notificationsMessage".l10nKey
        public static let calendarsMessage = "alert.calendarsMessage".l10nKey
        public static let keyboardShortcutMessage = "alert.keyboardShortcutMessage".l10nKey

        public static let ok = "alert.ok".l10nKey
        public static let yes = "alert.yes".l10nKey
        public static let no = "alert.no".l10nKey
    }

    public enum Theme {
       public static let system = "theme.system".l10nKey
       public static let dark = "theme.dark".l10nKey
       public static let light = "theme.light".l10nKey
    }

    public enum Language {
        public static let system = "theme.system".l10nKey
        public static let en_US = "English".l10nKey
        public static let zh_CN = "简体中文".l10nKey
    }

    public enum MenubarStyle {
        public static let `default` = "menubarStyle.default".l10nKey
        public static let text = "menubarStyle.text".l10nKey
        public static let date = "menubarStyle.date".l10nKey
        public static let tips = "menubarStyle.tips".l10nKey
        public static let save = "menubarStyle.save".l10nKey
        public static let use24 = "menubarStyle.use24".l10nKey
        public static let showSeconds = "menubarStyle.showSeconds".l10nKey
    }

    public enum Date {
        public static let allDay = "date.allDay".l10nKey
        public static let events = "date.events".l10nKey
        public static let noEvents = "date.noEvents".l10nKey
    }

    public enum Updater {
        public static var available: String { "updater.available".localized(bundle) }
        public static func update(_ version: String) -> String { "updater.update".localized(bundle, args: version) }
    }

}




@available(macOSApplicationExtension, unavailable)
public extension L10n {

    static func timeline(from date: L10Date) -> String {
        formatter.locale = .posix
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        return formatter.string(from: date)
    }

    static func shortWeekday(from date: L10Date) -> String {
        formatter.locale = locale
        return inChinese ? formatter.veryShortWeekdaySymbols[date.weekday - 1] :
        formatter.shortWeekdaySymbols[date.weekday - 1]
    }

    static func monthSymbol(from month: Int) -> String {
        formatter.locale = locale
        return formatter.shortMonthSymbols[month - 1]
    }

    static func weekdaySymbol(from weekday: AppWeekday) -> String {
        formatter.locale = locale
        return formatter.shortWeekdaySymbols[weekday.rawValue - 1]
    }

}

//MARK: Widget
public extension L10n {
    public enum LargeWidget {
       public static let displayName = "largeWidget.displayName".l10nKey
       public static let description = "largeWidget.description".l10nKey
    }
}

public extension L10n {
    static func widgetShortWeekday(from date: L10Date, locale: Locale) -> String {
        formatter.locale = locale
        return locale.inChinese ? formatter.veryShortWeekdaySymbols[date.weekday - 1] :
        formatter.shortWeekdaySymbols[date.weekday - 1]
    }

    static func widgetMonthSymbol(from month: Int, locale: Locale) -> String {
        formatter.locale = locale
        return formatter.shortMonthSymbols[month - 1]
    }

    static func widgetWeekdaySymbol(from weekday: AppWeekday, locale: Locale) -> String {
        formatter.locale = locale
        return formatter.shortWeekdaySymbols[weekday.rawValue - 1]
    }
}

//MARK: Menubar Date&Time Style
public extension L10n {
     static func lm(from date: L10Date) -> String { date.lunarMonthString }
     static func ld(from date: L10Date) -> String { date.lunarDayString }
     static func sm(from date: L10Date) -> String { monthSymbol(from: date.month) }

     static func sd(from date: L10Date) -> String {
        formatter.locale = locale
        formatter.dateFormat = L10n.inChinese ? "d日":"d"
        return formatter.string(from: date)
    }

     static func e(from date: L10Date) -> String {
        formatter.locale = locale
        formatter.dateFormat = "E"
        return formatter.string(from: date)
    }

     static func a(from date: L10Date) -> String {
        formatter.locale = locale
        formatter.dateFormat = "a"
        return formatter.string(from: date)
    }

     static func t(from date: L10Date, use24h: Bool, showSeconds: Bool) -> String {
        formatter.locale = .posix
        formatter.dateFormat = (use24h ? "HH:mm":"h:mm") + (showSeconds ? ":ss":"")
        return formatter.string(from: date)
    }
}

extension L10n {
    static var bundle: Bundle {
        let fileName =  {
            switch locale {
            case .zh: return "zh-Hans"
            case .en: return "en"
            default: return "zh-Hans"
            }
        }
        guard let path = Bundle.main.path(forResource: fileName(), ofType: "lproj") else { return .main }
        return Bundle(path: path) ?? .main
    }
}

