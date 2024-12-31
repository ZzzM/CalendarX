//
//  AppStore.swift
//  CalendarX
//
//  Created by zm on 2024/12/30.
//

import CalendarXLib
import SwiftUI

@MainActor
class AppStore: ObservableObject {
    
    @AppStorage(AppStorageKey.theme, store: .group)
    var theme: Theme = .system

    @AppStorage(AppStorageKey.appearance, store: .group)
    var appearance: Appearance = .default

    @AppStorage(AppStorageKey.language, store: .group)
    var language: Language = .system
}


extension AppStore {
    var accentColor: Color { appearance.accentColor }
    var backgroundColor: Color { appearance.backgroundColor }

    var colorScheme: ColorScheme? { theme.colorScheme }
    var locale: Locale { language.locale }
}
