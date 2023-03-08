//
//  L10n.swift
//  CalendarX
//
//  Created by zm on 2022/3/30.
//

import Foundation
import SwiftUI

typealias CalDate = Date

struct L10n {
    
    private static let formatter = DateFormatter()
    
    private static var locale: Locale { Preference.shared.locale }
    
    static var inChinese: Bool { locale.inChinese }
    
    enum Settings {
        static let title = "settings.title".l10nKey
        static let appearance = "settings.appearance".l10nKey
        static let calendar = "settings.calendar".l10nKey
        static let auto = "settings.auto".l10nKey
        static let language = "settings.language".l10nKey
        static let recommendations = "settings.recommendations".l10nKey
        static let menubarStyle = "settings.menubarStyle".l10nKey
        static let launchAtLogin = "settings.launchAtLogin".l10nKey
        static let version = "settings.version".l10nKey
        static let checkForUpdates = "settings.checkForUpdates".l10nKey
        static let about = "settings.about".l10nKey
    }
    
    enum Calendar {
        static let showEvents = "calendar.showEvents".l10nKey
        static let startWeekOn = "calendar.startWeekOn".l10nKey
        static let showLunar = "calendar.showLunar".l10nKey
        static let showHolidays = "calendar.showHolidays".l10nKey
    }
    
    enum Appearance {
        static let hex = "appearance.hex".l10nKey
        static let tint = "appearance.tint".l10nKey
    }
    
    enum Alert {
        static let exit = "alert.exit".l10nKey
        static let notifications = "alert.notifications".l10nKey
        static let calendars = "alert.calendars".l10nKey

        static let exitMessage = "alert.exitMessage".l10nKey
        static let notificationsMessage = "alert.notificationsMessage".l10nKey
        static let calendarsMessage = "alert.calendarsMessage".l10nKey
        
        static let ok = "alert.ok".l10nKey
        static let yes = "alert.yes".l10nKey
        static let no = "alert.no".l10nKey

    }
    
    enum Theme {
        static let system = "theme.system".l10nKey
        static let dark = "theme.dark".l10nKey
        static let light = "theme.light".l10nKey
    }
    
    enum Language {
        static let system = "theme.system".l10nKey
        static let en_US = "English".l10nKey
        static let zh_CN = "简体中文".l10nKey
    }
    
    enum MenubarStyle {
        static let `default` = "menubarStyle.default".l10nKey
        static let text = "menubarStyle.text".l10nKey
        static let date = "menubarStyle.date".l10nKey
        static let tips = "menubarStyle.tips".l10nKey
        static let save = "menubarStyle.save".l10nKey
        static let use24 = "menubarStyle.use24".l10nKey
        static let showSeconds = "menubarStyle.showSeconds".l10nKey
    }
    
    enum Date {
        static let allDay = "date.allDay".l10nKey
        static let events = "date.events".l10nKey
        static let noEvents = "date.noEvents".l10nKey
    }
    
    enum Updater {
        static var available: String { "updater.available".localized(bundle) }
        static func update(_ version: String) -> String { "updater.update".localized(bundle, args: version) }
    }
    
}

extension L10n {
    
    static func timeline(from date: CalDate) -> String {
        formatter.locale = .posix
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        return formatter.string(from: date)
    }

    static func shortWeekday(from date: CalDate) -> String {
        formatter.locale = locale
        return inChinese ? formatter.veryShortWeekdaySymbols[date.weekday - 1] :
        formatter.shortWeekdaySymbols[date.weekday - 1]
    }

    static func monthSymbol(from month: Int) -> String {
        formatter.locale = locale
        return formatter.shortMonthSymbols[month - 1]
    }

    static func weekdaySymbol(from weekday: CalWeekday) -> String {
        formatter.locale = locale
        return formatter.shortWeekdaySymbols[weekday.rawValue - 1]
    }

    
    static func dateItemTitle(_ pref: MenubarPreference) -> String {
        let date = CalDate(), types = pref.shownTypes,
            use24h = pref.use24h, showSeconds = pref.showSeconds
        
        return dateTitle(types: types) {
            switch $0 {
            case .lm: return date.lunarMonthString
            case .ld: return date.lunarDayString
            case .sm:
                return monthSymbol(from: date.month)
            case .sd:
                formatter.locale = locale
                formatter.dateFormat = L10n.inChinese ? "d日":"d"
                return formatter.string(from: date)
            case .e:
                formatter.locale = locale
                formatter.dateFormat = "E"
                return formatter.string(from: date)
            case .a:
                formatter.locale = locale
                formatter.dateFormat = "a"
                return formatter.string(from: date)
            case .t:
                formatter.locale = .posix
                formatter.dateFormat = (use24h ? "HH:mm":"h:mm") + (showSeconds ? ":ss":"")
                return formatter.string(from: date)
            }
        }
    }

    
    static func dateTitle(types: [DTType], map: (DTType) -> String) -> String {
        guard  let type = types.first else { return AppInfo.name }
        var titleArray = [map(type)]
        for (index, type) in types.enumerated()  {
            guard index  > 0 else { continue }
            var title = map(type)
            if inChinese {
                let preIndex = index - 1,  preType = types[preIndex]
                if (type == .ld && preType == .lm) ||
                    (type == .sd && preType == .sm) {
                    title = titleArray[preIndex] + title
                    titleArray[preIndex] = ""
                }
            }
            titleArray.append(title)
        }
        return titleArray.joined(separator: " ")
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

