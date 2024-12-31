//
//  CalendarXWidget+.swift
//  CalendarX
//
//  Created by zm on 2024/5/31.
//

import CalendarXLib
import SwiftUI

@MainActor
extension WidgetConfigurationIntent {
    func colorItem(from colorInfo: ColorInfo) -> WidgetColor {
        WidgetColor(identifier: colorInfo.hex, display: colorInfo.name(from: locale))
    }

    var accentColor: Color {
        let lightAccent = lightAccentColor?.identifier ?? Bundle.defaultLightAccent.hex
        let darkAccent = darkAccentColor?.identifier ?? Bundle.defaultDarkAccent.hex
        guard let colorScheme else { return Color(light: lightAccent, dark: darkAccent) }
        return colorScheme == .light ? Color(hex: lightAccent) : Color(hex: darkAccent)
    }

    var backgroundColor: Color {
        let lightBackground = lightBackgroundColor?.identifier ?? Bundle.defaultLightBackground.hex
        let darkBackground = darkBackgroundColor?.identifier ?? Bundle.defaultDarkBackground.hex
        guard let colorScheme else { return Color(light: lightBackground, dark: darkBackground) }
        return colorScheme == .light ? Color(hex: lightBackground) : Color(hex: darkBackground)
    }

    var colorScheme: ColorScheme? {
        Theme(rawValue: theme.rawValue - 1)?.colorScheme
    }

    var locale: Locale {
        Language(rawValue: language.rawValue - 1)?.locale ?? .current
    }

    var firstWeekday: AppWeekday {
        AppWeekday(rawValue: startWeekOn.rawValue) ?? .sunday
    }
}
