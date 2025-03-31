//
//  Theme.swift
//  CalendarXLib
//
//  Created by zm on 2024/12/30.
//

import SwiftUI

@MainActor
public enum Theme: Int, CaseIterable {
    case system, light, dark

    public var colorScheme: ColorScheme? {
        switch self {
        case .light: .light
        case .dark: .dark
        default: .none
        }
    }

    public var title: LocalizedStringKey {
        switch self {
        case .light: L10n.Theme.light
        case .dark: L10n.Theme.dark
        default: L10n.Theme.system
        }
    }
}
