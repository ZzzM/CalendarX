//
//  MenubarStyle.swift
//  CalendarX
//
//  Created by zm on 2023/2/17.
//

import SwiftUI

enum MenubarStyle: Int, CaseIterable, Decodable {
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

    }
    
    var isNotDate: Bool { self != .date }
}
