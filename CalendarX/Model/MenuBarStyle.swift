//
//  MenuBarStyle.swift
//  CalendarX
//
//  Created by zm on 2022/4/1.
//

import SwiftUI

enum MenuBarStyle: String, CaseIterable {
    case style1, style2, style3, style4, `default`

    var title: LocalizedStringKey {
        isDefault ? L10n.MenubarStyle.default:
        L10n.statusBarTitle(style: self).l10nKey
    }

    var isDefault: Bool { self == .default }
}
