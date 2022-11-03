//
//  MenuBarStyle.swift
//  CalendarX
//
//  Created by zm on 2022/4/1.
//

import SwiftUI

enum MenuBarStyle: String, CaseIterable {
    // 2.2.0 or earlier
//    case style1, style2, style3, style4,

    // 2.2.1 or later
    case `default`, text, date

    var title: LocalizedStringKey {

        switch self {
        case .text: return L10n.MenubarStyle.text
        case .date: return L10n.MenubarStyle.date
        default: return L10n.MenubarStyle.default
        }
//        isDefault ? L10n.MenubarStyle.default:
//        L10n.statusBarTitle(style: self).l10nKey
    }

    var isDefault: Bool { self == .default }
    var isDate: Bool { self == .date }
}
