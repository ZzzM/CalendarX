//
//  MenubarPreference.swift
//  CalendarX
//
//  Created by zm on 2023/2/13.
//

import SwiftUI

//MARK: Menubar Date&Time Style
typealias DTTag = (offset: Int, element: DTType)

enum DTType: String, Codable {
    case lm, ld, sm, sd, e, a, t
}

struct DTIndex: Decodable {
    let isShown: Bool, index: Int
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
    var text: String = AppInfo.name
    
}

