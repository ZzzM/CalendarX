//
//  Preferences.swift
//  Bingpaper
//
//  Created by zm on 2021/10/26.
//
import SwiftUI

class Preference: ObservableObject {

    static let shared = Preference()


    @AppStorage(wrappedValue: .system, AppStorageKey.theme)
    var theme: Theme

    @AppStorage(wrappedValue: 0, AppStorageKey.tint)
    var tint

    @AppStorage(wrappedValue: .system, AppStorageKey.language)
    var language: Language

    @AppStorage(wrappedValue: .sunday, AppStorageKey.weekday)
    var weekday: XWeekday

    @AppStorage(wrappedValue: true, AppStorageKey.showSchedule)
    var showSchedule

    @AppStorage(wrappedValue: .default, AppStorageKey.menuBarStyle)
    var menuBarStyle: MenuBarStyle

    @AppStorage(wrappedValue: AppInfo.name, AppStorageKey.menuBarText)
    var menuBarText: String

    @AppStorage(wrappedValue: AppInfo.dateFormat, AppStorageKey.menuBarDateFormat)
    var menuBarDateFormat: String

}

extension Preference {
    var color: Color { Tint[tint] }
    var colorScheme: ColorScheme? { theme.colorScheme }
    var locale: Locale { language.locale }
}
