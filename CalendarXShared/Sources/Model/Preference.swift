//
//  Preferences.swift
//  Bingpaper
//
//  Created by zm on 2021/10/26.
//
import SwiftUI

public struct Preference {

    public static let shared = Preference()

    @AppStorage(AppStorageKey.theme, store: .group)
    public var theme: Theme = .system

    @AppStorage(AppStorageKey.tint, store: .group)
    public var tint: String = Appearance.tint

    @AppStorage(AppStorageKey.language, store: .group)
    public var language: Language = .system

}

public extension Preference {
    var color: Color { Color(hex: tint) }
    var colorScheme: ColorScheme? { theme.colorScheme }
    var locale: Locale { language.locale }
}

public enum Theme: Int, CaseIterable {

    case system, light, dark

    public var colorScheme: ColorScheme? {
        switch self {
        case .light: return .light
        case .dark: return .dark
        default: return .none
        }
    }

    public var title: LocalizedStringKey {
        switch self {
        case .light: return L10n.Theme.light
        case .dark: return L10n.Theme.dark
        default: return L10n.Theme.system
        }
    }
}

public enum Language: Int, CaseIterable {

    case system, zh_CN, en_US

    public var locale: Locale {
        switch self {
        case .zh_CN: return .zh
        case .en_US: return .en
        default: return .current
        }
    }

    public var title: LocalizedStringKey {
        switch self {
        case .zh_CN: return L10n.Language.zh_CN
        case .en_US: return L10n.Language.en_US
        default: return L10n.Language.system
        }
    }

}
