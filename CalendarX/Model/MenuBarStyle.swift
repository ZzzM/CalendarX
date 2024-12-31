//
//  MenubarStyle.swift
//  CalendarX
//
//  Created by zm on 2023/2/17.
//

import CalendarXLib
import SwiftUI

@MainActor
enum MenubarStyle: Int, CaseIterable, Decodable {
    // 2.2.0 or earlier
    //    case style1, style2, style3, style4,

    // 2.2.1 or later
    //    case `default`, text, date

    // 2.3.5 or later
    case icon, date

    var title: LocalizedStringKey {
        switch self {
        case .date: L10n.MenubarStyle.date
        default: L10n.MenubarStyle.icon
        }
    }
}

// MARK: Menubar Date&Time Style
enum MenubarDateType: String, Codable, Hashable {
    case lm, ld, sm, sd, e, a, t
}

@MainActor
extension [MenubarDateType] {
    func generateTitle(locale: Locale, transform: (Locale, Element) -> String) -> String {
        let condition: (Element, Element) -> Bool = {
            if locale.inChinese {
                ($0 == .lm && $1 == .ld) || ($0 == .sm && $1 == .sd)
            } else {
                $0 == .lm && $1 == .ld
            }
        }
        return chunked(by: condition)
            .map { $0.reduce("") { $0 + transform(locale, $1) } }
            .joined(separator: " ")
    }
}
