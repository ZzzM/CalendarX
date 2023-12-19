//
//  MenubarPreference.swift
//  CalendarX
//
//  Created by zm on 2023/2/13.
//

import SwiftUI
import CalendarXShared

//MARK: Menubar Date&Time Style
enum DTType: String, Codable, Hashable {
    case lm, ld, sm, sd, e, a, t
}

struct MenubarPreference  {

    static let shared = MenubarPreference()

    @AppStorage(MenubarStorageKey.style, store: .group)
    var style: MenubarStyle = .default

    // Date Style
    // Use a 24-hour clock
    @AppStorage(MenubarStorageKey.use24h, store: .group)
    var use24h: Bool = true

    // Display the time with seconds
    @AppStorage(MenubarStorageKey.showSeconds, store: .group)
    var showSeconds: Bool = false

    @AppStorage(MenubarStorageKey.shownTypes, store: .group)
    var shownTypes: [DTType] = [.sm, .sd, .e, .t]

    @AppStorage(MenubarStorageKey.hiddenTypes, store: .group)
    var hiddenTypes: [DTType] = [.lm, .ld, .a]

    // Text Style
    @AppStorage(MenubarStorageKey.text, store: .group)
    var text: String = AppBundle.name

}

extension MenubarPreference {
    var dateItemTitle: String {
        let date = Date()

        return dateTitle(types: shownTypes) {
            switch $0 {
            case .lm: return L10n.lm(from: date)
            case .ld: return L10n.ld(from: date)
            case .sm: return L10n.sm(from: date)
            case .sd: return L10n.sd(from: date)
            case .e: return L10n.e(from: date)
            case .a: return L10n.a(from: date)
            case .t: return L10n.t(from: date, use24h: use24h, showSeconds: showSeconds)
            }

        }
    }

    func dateTitle(types: [DTType], map: (DTType) -> String) -> String {
        guard  let type = types.first else { return AppBundle.name }
        var titleArray = [map(type)]
        for (index, type) in types.enumerated()  {
            guard index  > 0 else { continue }
            var title = map(type)
            if L10n.inChinese {
                let preIndex = index - 1,  preType = types[preIndex]
                if (type == .ld && preType == .lm) ||
                    (type == .sd && preType == .sm) {
                    title = titleArray[preIndex] + title
                    titleArray[preIndex] = ""
                }
            }
            titleArray.append(title)
        }
        return titleArray.joined(separator: " ")
    }
}
