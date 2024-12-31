//
//  L10n.swift
//  CalendarX
//
//  Created by zm on 2022/3/30.
//

import Foundation
import SwiftUI

@MainActor
public enum L10n {

    @MainActor
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

    @MainActor
    public enum Calendar {
        public static let showEvents = "calendar.showEvents".l10nKey
        public static let startWeekOn = "calendar.startWeekOn".l10nKey
        public static let showLunar = "calendar.showLunar".l10nKey
        public static let showHolidays = "calendar.showHolidays".l10nKey
        public static let keyboardShortcut = "calendar.keyboardShortcut".l10nKey
    }

    @MainActor
    public enum Appearance {
        public static let accentColor = "appearance.accentColor".l10nKey
        public static let backgroundColor = "appearance.backgroundColor".l10nKey
    }

    @MainActor
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

    @MainActor
    public enum Theme {
        public static let title = "theme.title".l10nKey
        public static let system = "theme.system".l10nKey
        public static let dark = "theme.dark".l10nKey
        public static let light = "theme.light".l10nKey
    }

    @MainActor
    public enum Language {
        public static let system = "theme.system".l10nKey
        public static let en_US = "English".l10nKey
        public static let zh_CN = "简体中文".l10nKey
    }

    @MainActor
    public enum MenubarStyle {
        public static let icon = "menubarStyle.icon".l10nKey
        public static let text = "menubarStyle.text".l10nKey
        public static let date = "menubarStyle.date".l10nKey
        public static let save = "menubarStyle.save".l10nKey
        public static let use24 = "menubarStyle.use24".l10nKey
        public static let showSeconds = "menubarStyle.showSeconds".l10nKey
    }

    @MainActor
    public enum Date {
        public static let allDay = "date.allDay".l10nKey
        public static let events = "date.events".l10nKey
        public static let noEvents = "date.noEvents".l10nKey
    }

    @MainActor
    public enum Updater {

        public static func available(locale: Locale) -> String { "updater.available".localized(locale.bundle) }
        public static func update(locale: Locale, version: String) -> String {
            "updater.update".localized(locale.bundle, args: version)
        }
    }
}

// MARK: Widget
extension L10n {

    @MainActor
    public enum LargeWidget {
        public static let displayName = "largeWidget.displayName".l10nKey
        public static let description = "largeWidget.description".l10nKey
    }
}
