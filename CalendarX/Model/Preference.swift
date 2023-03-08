//
//  Preferences.swift
//  Bingpaper
//
//  Created by zm on 2021/10/26.
//
import SwiftUI


struct Preference {

    static let shared = Preference()

    @AppStorage(AppStorageKey.theme, store: .group)
    var theme: Theme = .system

    @AppStorage(AppStorageKey.tint, store: .group)
    var tint: String = Appearance.tint

    @AppStorage(AppStorageKey.language, store: .group)
    var language: Language = .system
    
}

extension Preference {
    var color: Color { Color(hex: tint) }
    var colorScheme: ColorScheme? { theme.colorScheme }
    var locale: Locale { language.locale }
}



