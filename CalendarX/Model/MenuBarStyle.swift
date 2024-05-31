//
//  MenubarStyle.swift
//  CalendarX
//
//  Created by zm on 2023/2/17.
//

import SwiftUI
import CalendarXShared

enum MenubarStyle: Int, CaseIterable, Decodable {
    // 2.2.0 or earlier
//    case style1, style2, style3, style4,

    // 2.2.1 or later
//    case `default`, text, date
    
    // 2.3.5 or later
    case icon, date

    var title: LocalizedStringKey {

        switch self {
        case .date: return L10n.MenubarStyle.date
        default: return L10n.MenubarStyle.icon
        }

    }
    
    var isNotDate: Bool { self != .date }
}
