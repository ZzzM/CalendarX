//
//  MenubarStore.swift
//  CalendarX
//
//  Created by zm on 2024/12/30.
//

import CalendarXLib
import SwiftUI

@MainActor
class MenubarStore: ObservableObject {
   

    @AppStorage(MenubarStorageKey.style, store: .group)
    var style: MenubarStyle = .icon

    // Date Style
    // Use a 24-hour clock
    @AppStorage(MenubarStorageKey.use24h, store: .group)
    var use24h: Bool = true

    // Display the time with seconds
    @AppStorage(MenubarStorageKey.showSeconds, store: .group)
    var showSeconds: Bool = false

    @AppStorage(MenubarStorageKey.shownTypes, store: .group)
    var shownTypes: [MenubarDateType] = [.sm, .sd, .e, .t]

    @AppStorage(MenubarStorageKey.hiddenTypes, store: .group)
    var hiddenTypes: [MenubarDateType] = [.lm, .ld, .a]

    // Menubar Icon
    @AppStorage(MenubarStorageKey.iconType, store: .group)
    var iconType: MenubarIcon = .c
}

extension MenubarStore {
    
    func dateItemTitle(locale: Locale) -> String {
        shownTypes.generateTitle(locale: locale, transform: transform)
    }
    
    private func transform(locale: Locale, type: MenubarDateType) -> String {
        let date = Date()
        return switch type {
        case .lm: date.lm
        case .ld: date.ld
        case .sm: date.sm(locale: locale)
        case .sd: date.sd(locale: locale)
        case .e: date.e(locale: locale)
        case .a: date.a(locale: locale)
        case .t: date.t(use24h: use24h, showSeconds: showSeconds)
        }
    }

}
