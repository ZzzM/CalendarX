//
//  Theme.swift
//  CalendarX
//
//  Created by zm on 2021/10/26.
//
import SwiftUI

enum Theme: Int, CaseIterable {

    case system, light, dark

    var colorScheme: ColorScheme? {
        switch self {
        case .light: return .light
        case .dark: return .dark
        default: return .none
        }
    }

    var title: LocalizedStringKey {
        switch self {
        case .light: return L10n.Theme.light
        case .dark: return L10n.Theme.dark
        default: return L10n.Theme.system
        }
    }
}
